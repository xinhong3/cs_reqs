from itertools import product
from .solver import Solver, And, Or, get_leaves
from .course_catalog import (
    catalog, upper_division,
    Passed, Taken, Major, Standing, Unsupported, Permission,
    CourseAttr,
)

def C_or_higher(grade): return grade in {'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C'}

## whether a class is upper-division, i.e., 300-level or above
def upper_division(course): return int(course[4:]) >= 300

# For the purpose of determining grade point average, grades are assigned
# point values as follows:
grade_to_points = {
  'A': 4.00, 'A-': 3.67,
  'B+': 3.33, 'B': 3.00, 'B-': 2.67,
  'C+': 2.33, 'C': 2.00, 'C-': 1.67,
  'D+': 1.33, 'D': 1.00,
#   'F': 0.00, 'I/F': 0.00, 'Q': 0.00
}
GRADES = grade_to_points.keys()

MAX_SEM = 10       # upper bound on future semesters
CREDIT_LIMIT = 15  # max credits per semester

class UsedInSci(CourseAttr): pass

bio  = {'BIO 201', 'BIO 204'}; bio2 = {'BIO 202', 'BIO 204'}; bio3 = {'BIO 203', 'BIO 204'}
che  = {'CHE 131', 'CHE 133'}; che2 = {'CHE 152', 'CHE 154'}
phy  = {'PHY 126', 'PHY 133'}; phy2 = {'PHY 131', 'PHY 133'}; phy3 = {'PHY 141', 'PHY 133'}
sci_combs = [bio, bio2, bio3, che, che2, phy, phy2, phy3]

sci_more = {'AST 203', 'AST 205',
            'CHE 132', 'CHE 321', 'CHE 322', 'CHE 331', 'CHE 332',
            'GEO 102', 'GEO 103', 'GEO 112', 'GEO 123', 'GEO 122',
            'PHY 125', 'PHY 127', 'PHY 132', 'PHY 134', 'PHY 142',
            'PHY 251', 'PHY 252'}

sci_ids  = sorted(set().union(*sci_combs) | sci_more)

# differentiate between Taken and Passed for sci vs non-sci
def pred_for(cid):
    return Taken(cid) if cid in sci_ids else Passed(cid)

# history is the taken list of tuples
# attrs are additional attributes of the student such as major, standing, etc.
# add a boolean for check, to make it a checker
# ALDA
# have_to take course
def plan(history, *attrs, exclude=set()):
    # non-sci courses passed with C or higher at SB
    solver = Solver(*attrs, ignore=(Unsupported, Permission))
    model = solver.model

    # helper: create grade-dimension vars for science courses
    graded = set()
    def add_graded(cid, grade=None):
        if cid not in graded:
            graded.add(cid)
            solver.define(Taken(cid), Or(*[Taken(cid, g) for g in GRADES]))
            if grade is None:   # solver picks — at most one grade
                model.add(sum(solver[Taken(cid, g)] for g in GRADES) <= 1)
        if grade is not None:   # known grade — pin it
            for g in GRADES:
                solver.pin(Taken(cid, g), 1 if g == grade else 0)
 
    # record history in the model
    known = set()
    for cid, cr, grade, loc in history:
        known.add(cid)
        if cid in sci_ids and grade in grade_to_points:
            add_graded(cid, grade=grade)
        elif C_or_higher(grade):
            solver.pin(Passed(cid), 1)
 
    # exclude certain courses based on student preferences - if a required course is excluded the planner won't find a solution
    for cid in exclude:
        known.add(cid)
        if cid in sci_ids: add_graded(cid)
        solver.pin(pred_for(cid), 0)

    # fetch credits earned for each course
    hist_credits = {cid: cr for cid, cr, grade, loc in history}
    # use actual credits earned from history if available, else for future courses get credits from the catalog
    credits = lambda c: hist_credits.get(c, catalog[c].credits)

    # still need to handle OR Tools for integer variables as solver class only handles BoolVars for now
    sem = {}
    for cid in catalog:
        sem[cid] = model.new_int_var(0, MAX_SEM, f"sem_{cid}")
        if cid in known:
            model.add(sem[cid] == 0)
        else:
            if cid in sci_ids: add_graded(cid)
            v = solver[pred_for(cid)]
            model.add(sem[cid] >  0).only_enforce_if(v)
            model.add(sem[cid] == 0).only_enforce_if(v.negated())

    reqs = {}
    # 1. Required Introductory Courses
    prog = {'CSE 114', 'CSE 214', 'CSE 216'}
    prog2 = {'CSE 160', 'CSE 161', 'CSE 260', 'CSE 261'}  ## Honors
    dmath = {'CSE 215'}
    dmath2 = {'CSE 150'}  # Honors
    sys = {'CSE 220'}
    intro_courses = prog | prog2 | dmath | dmath2 | sys
    reqs["intro"] = And(Or(And(Passed(*prog)), And(Passed(*prog2))), Or(And(Passed(*dmath)), And(Passed(*dmath2))), And(Passed(*sys)))

    # 2. Required Advanced Courses
    theory = {'CSE 303'}
    theory2 = {'CSE 350'}  # Honors
    algo = {'CSE 373'}
    algo2 = {'CSE 385'}  # Honors
    other = {'CSE 310', 'CSE 316', 'CSE 320', 'CSE 416'}
    adv_courses = theory | theory2 | algo | algo2 | other
    reqs["adv"] = And(Or(And(Passed(*theory)), And(Passed(*theory2))), Or(And(Passed(*algo)), And(Passed(*algo2))), And(Passed(*other)))


    # 3. Computer Science Electives  ## simpler than 2025
    #
    # Four upper-division technical CSE electives, each of which must carry at
    # least three credits. Technical electives do not include teaching practica
    # (CSE 475), the senior honors project (CSE 495, 496), and courses
    # designated as non-technical in the course description (such as CSE 301).
    elect_exclude = {'CSE 475', 'CSE 495', 'CSE 300', 'CSE 301', 'CSE 312'}

    ## list of eligible electives
    electives = {
        c for c in catalog
        if c[:3] == 'CSE'
        and upper_division(c)
        and credits(c) >= 3
        and c not in adv_courses | elect_exclude
    }

    model.add(sum(solver.constraint(Passed(c)) for c in electives) >= 4)

    # 4. AMS 151, AMS 161 Applied Calculus I, II
    calc = {'AMS 151', 'AMS 161'}
    calc2 = {'MAT 125', 'MAT 126', 'MAT 127'}
    calc3 = {'MAT 131', 'MAT 132'}
    reqs["calc"] = Or(And(Passed(*calc)), And(Passed(*calc2)), And(Passed(*calc3)))

    # 5. One of the following linear algebra courses
    alg = {'MAT 211'}
    alg2 = {'AMS 210'}
    reqs["alg"] = Or(And(Passed(*alg)), And(Passed(*alg2))) # wrap in And just in case courses are added to the sets

    # 6. Both of the following:
    fmath = {'AMS 301'}
    sta =   {'AMS 310'}
    sta2 =  {'AMS 311'}
    reqs["sta"] = And(And(Passed(*fmath)), Or(And(Passed(*sta)), And(Passed(*sta2))))

    # 7. At least one natural science lecture/laboratory combination
    # each comb is a pair that must both be taken — Or across all valid pairs

    ## reqs["Requirement 7"] = Or(*[And(UsedInSci(*comb)) for comb in sci_combs])

    # 8. Additional natural science courses selected from above and following list
    # The courses selected in 7 and 8 must carry at least 9 credits total
    
    for cid in sci_ids:     # used is a subset of taken
        model.add_implication(solver[UsedInSci(cid)], solver[Taken(cid)])
 
    # at least one complete lecture/lab combo must be in the subset
    solver.require(Or(*[And(*[UsedInSci(cid) for cid in comb]) for comb in sci_combs]))
 
    used_credit_total = sum(solver[UsedInSci(cid)] * credits(cid) for cid in sci_ids)
    model.add(used_credit_total >= 9)
 
    used_grade = {}
    for cid in sci_ids:
        for g in grade_to_points:
            ug = model.new_bool_var(f"{cid}_{g}_used")
            model.add_implication(ug, solver[Taken(cid, g)])
            model.add_implication(ug, solver[UsedInSci(cid)])
            used_grade[(cid, g)] = ug
        model.add(sum(used_grade[(cid, g)] for g in grade_to_points) == solver[UsedInSci(cid)])
 
    used_weighted_sum = sum(used_grade[(cid, g)] * int(grade_to_points[g] * 100) * credits(cid) for cid in sci_ids for g in grade_to_points)
 
    # The grade point average for the courses in Requirements 7 and 8 must be
    # at least 2.00.
    ## GPA >= 2.0  <=>  weighted_sum >= 200 * total_credits  (scaled by 100)
    model.add(used_weighted_sum >= 200 * used_credit_total)

    # 9. Professional Ethics
    ethics_courses = {'CSE 312'}
    reqs["ethics"] = And(Passed(*ethics_courses))

    # 10. Upper-Division Writing Requirement
    writing_courses = {'CSE 300'}
    reqs["writing"] = And(Passed(*writing_courses))

    for expr in reqs.values():
        solver.require(expr)

    # At least 24 credits from items 1 to 3 below, and at least 18 credits from
    # items 2 and 3, must be completed at Stony Brook.
    ## courses are filtered for the ones taken at Stony Brook.
    items123_courses = intro_courses | adv_courses | electives
    items23_courses  = adv_courses | electives

    model.add(sum(solver[pred_for(c)] * credits(c) for c in items123_courses) >= 24)
    model.add(sum(solver[pred_for(c)] * credits(c) for c in items23_courses)  >= 18)

    # Completion of the major requires approximately 80 credits.
    # model.add(sum(solver[pred_for(c)] * credits(c) for c in catalog)  >= 80)

    # pre-req course requirement
    prereqs = {cid: c.prereq for cid, c in catalog.items() if c.prereq}

    for cid, expr in prereqs.items():
        if cid in known: continue
        prereq_sat = solver.constraint(expr)
        if prereq_sat is not None: model.add_implication(solver[Passed(cid)], prereq_sat) # boolean: prereqs must hold
        for p in get_leaves(expr):
            if p in sem:
                model.add(sem[p] < sem[cid]).only_enforce_if(solver[Passed(cid)])

    # credit limit per semester to spread courses out

    for s in range(1, MAX_SEM + 1):
        sem_credits = []
        for cid in catalog:
            b = model.new_bool_var(f"{cid}_s{s}")
            model.add(sem[cid] == s).only_enforce_if(b)
            model.add(sem[cid] != s).only_enforce_if(b.negated())
            sem_credits.append(credits(cid) * b)
        model.add(sum(sem_credits) <= CREDIT_LIMIT)

    # calculate the time (no. of semesters) taken to graduate
    last_sem = model.new_int_var(0, MAX_SEM, "last_sem")
    model.add_max_equality(last_sem, [sem[cid] for cid in catalog])

    # calculate total number of new courses taken
    new_courses = sum(solver[pred_for(cid)] for cid in catalog if cid not in known)

    # retreive grades for courses already taken
    grades = {cid: grade for (cid, cr, grade, loc) in history}

    planned_grade_sum = sum(
        solver[Taken(cid, g)] * int(grade_to_points[g] * 100)
        for cid in graded if cid not in grades
        for g in GRADES)
    
    # minimize total grade points and number of semesters
    model.minimize(last_sem * 10_000_000 + new_courses * 10_000 + planned_grade_sum)

    # run the solver
    status, obj = solver.solve()
 
    if obj is None:
        print("No solution:", status)
        return {}
    print(f"Status: {status} — {obj // 10_000_000} more semester(s)\n")
 
    schedule = {cid: solver.value(sem[cid])
                for cid in catalog if solver.value(sem[cid]) > 0}
 
    # retreive grades chosen by the planner for courses
    for cid in graded:
        if cid not in grades:
            for g in GRADES:
                if Taken(cid, g) in solver and solver.value(Taken(cid, g)):
                    grades[cid] = g
                    break
    # hardcode remaining (non-sci) courses to have minimum grade of C
    for cid in schedule:
        if cid not in grades:
            grades[cid] = 'C'
 
    # report which courses satisfy which requirements (witness)
    reqs["elect"] = Or(Passed(*electives))
    reqs["sci"] = {cid for cid in sci_ids if solver.value(UsedInSci(cid))}
    
    checked = {}
    for name, expr in sorted(reqs.items()):
        if isinstance(expr, set):
            wit = sorted(expr)
        else:
            wit = sorted(cid for cid in get_leaves(expr) if solver.value(Passed(cid)))
        checked[name] = (True, wit)
        print(f"{name} : {', '.join(fmt(c, grades) for c in wit)}")
 
    items123_cr = sum(credits(c) for c in items123_courses if solver.value(pred_for(c)))
    items23_cr  = sum(credits(c) for c in items23_courses  if solver.value(pred_for(c)))
    checked['credits_at_SB'] = (True, [f'items123 = {items123_cr}', f'items23 = {items23_cr}'])
    checked['degree'] = (True, [])
    print(f"credits_at_sb : items 1-3 = {items123_cr} (≥24), items 2-3 = {items23_cr} (≥18)")
 
    # printing semester-wise schedule of courses
    by_sem = {}
    for cid, s in schedule.items():
        by_sem.setdefault(s, []).append(cid)
    print(f"New courses to take ({len(schedule)}):")
    for s in sorted(by_sem):
        total = sum(credits(c) for c in by_sem[s])
        print(f"  Semester +{s} ({total} cr): {', '.join(fmt(c, grades) for c in sorted(by_sem[s]))}")
    
    return checked, schedule, grades

def fmt(cid, grades):
    return f"{cid} ({grades[cid]})" if cid in grades else cid

if __name__ == '__main__':
    # Test: student has taken intro programming + CSE 220
    taken_ids = {'CSE 114', 'CSE 214', 'CSE 216', 'CSE 220'}
    history   = [(cid, catalog[cid].credits, "A", "SB") for cid in taken_ids]

    plan(history, Major("CSE"), Standing("U4"))

    ## course - semester mapping
    ## abstraction for counting/aggregation?