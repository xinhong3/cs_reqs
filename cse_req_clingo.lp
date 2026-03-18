%%%%% TO RUN: copy the this file and the KB file (kb_complete.lp) into the following:
%%%%%         https://potassco.org/clingo/run/ (it works for clingo v5.7.2)
%%%%%         click the toggle for "lua" and it should be blue and says "python"
%%%%%         paste the code and click "Run"

%%%%% Guide: https://github.com/potassco/guide/releases/tag/v2.2.0
%%%%%   "introduction to the Answer Set Programming (ASP) tools gringo, clasp, and clingo"

%%% ISSUE: better ways to do the same?
%%%   Clingo does not seem to have native support for string manipulation,
%%%   therefore we use external python functions to extract course number and program from course Id.

%% Guide: 3.1.10 Pooling
%% the following is equivalent to c_or_higher("A"). c_or_higher("A-"). ...
c_or_higher("A";"A-";"B+";"B";"B-";"C+";"C").

grade_to_points("A", 400).
grade_to_points("A-", 367).
grade_to_points("B+", 333).
grade_to_points("B", 300).
grade_to_points("B-", 267).
grade_to_points("C+", 233).
grade_to_points("C", 200).
grade_to_points("C-", 167).
grade_to_points("D+", 133).
grade_to_points("D", 100).
grade_to_points("F", 0).
grade_to_points("I/F", 0).
grade_to_points("Q", 0).

gpa_mul_100(TakenSubset, Gpa) :-
  courses_taken(Id, _, _, TakenSubset),
  WeightedSum = #sum { Credit*Points : courses_taken(Id_, Credit, Grade, TakenSubset), grade_to_points(Grade, Points) }, %% only consider letter grades
  SumOfWeights = #sum { Credit : courses_taken(Id_, Credit, Grade, TakenSubset), grade_to_points(Grade, _) },
  SumOfWeights > 0,   %%% fails when it's 0, not returning 0 as in python.
  Gpa = WeightedSum / SumOfWeights.

%% taken(Id, Credits, Grade, When, Where), defined later
passed(Id) :- taken(Id, Credits_, Grade, When_, Where_), c_or_higher(Grade).

%% define passed_all using distalgo semantics for "each"
passed_all(Subject) :-
  c(_, Subject),                                % c(Id, Subject): course Id in Subject
  X = #count { C : c(C, Subject), passed(C) },
  Y = #count { C : c(C, Subject) },
  X = Y.

%% it could also be defined as follows:
%% passed_all(Subject) :-
%%   c(_, Subject),
%%   0 = #count { C : c(C, Subject), not passed(C) }.

%% alternatively, we could first define the negation of passed_all
%% 	then define passed_all:
%% -passed_all(Subject) :- c(Id, Subject), not passed(Id).
%% passed_all(Subject) :- c(_, Subject), not -passed_all(Subject).

% from Annie: course C is witness for passing all courses in a subject in requirement Item
wit(Item, Id) :- s(Item, Subj), passed_all(Subj), c(Id, Subj).

% 1. Required Introductory Courses
c("CSE 114", prog). c("CSE 214", prog). c("CSE 216", prog). 
c("CSE 160", prog2). c("CSE 161", prog2). 
c("CSE 260", prog2). c("CSE 261", prog2).
c("CSE 215", dmath). 
c("CSE 150", dmath2).
c("CSE 220", sys). 
intro_courses(Id) :- c(Id, (prog; prog2; dmath; dmath2; sys)).

% from Annie %%% changed intro to intro_req
s(intro, (prog; prog2; dmath; dmath2; sys)).

intro_req :-
  passed_all(prog; prog2),
  passed_all(dmath; dmath2),
  passed_all(sys).

% 2. Required Advanced Courses
c("CSE 303", theory). c("CSE 350", theory2).
c("CSE 373", algo). c("CSE 385", algo2).
c("CSE 310", common). c("CSE 316", common). c("CSE 320", common). c("CSE 416", common).
adv_courses(Id) :- c(Id, (theory; theory2; algo; algo2; common)).

s(adv, (theory; theory2; algo; algo2; common)).

adv_req :- 
  passed_all(theory; theory2),
  passed_all(algo; algo2),
  passed_all(common).

% 3. Computer Science Electives  %% simpler than 2025
c(("CSE 475"; "CSE 495"; "CSE 300"; "CSE 301"; "CSE 312"), elect_exclude).

%% define courses_taken(Id, Credits, Grade, Subset) to represent a subset of taken courses 
%%   as in Annie's python, where Subset is a term used to identify the subset.
courses_taken(Id, Credits, Grade, elect_passed) :- 
  taken(Id, Credits, Grade, _, _), 
  Prog = @course_prog(Id), 
  Prog = "CSE", 
  @upper_division(Id) = 1,    %% is upper division
  Credits >= 3, not adv_courses(Id), not c(Id, elect_exclude).

elect_req :- 
  #count { Id: courses_taken(Id, _, _, elect_passed) } >= 4.

%% for elect, witness is the subset elect_passed used in elect_req.
wit(elect, Id) :- courses_taken(Id, _, _, elect_passed).

% 4. AMS 151, AMS 161 Applied Calculus I, II
%%% (copied from python) todo:
% Equivalency for MAT courses achieved through the Mathematics
% Placement Examination is accepted to meet MAT course requirements.
c("AMS 151", calc). c("AMS 161", calc).
c("MAT 125", calc2). c("MAT 126", calc2). c("MAT 127", calc2).
c("MAT 131", calc3). c("MAT 132", calc3).
s(calc, (calc; calc2; calc3)).

calc_req :- 
  passed_all(calc; calc2; calc3).

% 5. One of the following:
c("MAT 211", alg).
c("AMS 210", alg2).
s(alg, (alg; alg2)).

alg_req :- 
  passed_all(alg; alg2).

% 6. Both of the following:
c("AMS 301", fmath).
c("AMS 310", sta).
c("AMS 311", sta2).
s(sta, (fmath; sta; sta2)).

sta_req :-
  passed_all(fmath),
  passed_all(sta; sta2).

% 7. At least one of the following natural science lecture/laboratory combinations...
% All courses taken to satisfy Requirements 1 through 10 must be taken for a letter grade.
c("BIO 201", bio). c("BIO 204", bio).
c("BIO 202", bio2). c("BIO 204", bio2).
c("BIO 203", bio3). c("BIO 204", bio3).
c("CHE 131", che). c("CHE 133", che).
c("CHE 152", che2). c("CHE 154", che2).
c("PHY 126", phy). c("PHY 133", phy).
c("PHY 131", phy2). c("PHY 133", phy2).
c("PHY 141", phy3). c("PHY 133", phy3).

sci_combs(L) :- L = (bio;bio2;bio3;che;che2;phy;phy2;phy3).

% 8. Additional natural science courses selected from above and the following list...
% All courses taken to satisfy Requirements 1 through 10 must be taken for a letter grade.
c(("AST 203"; "AST 205"; "CHE 132"; "CHE 321"; "CHE 322"; "CHE 331"; "CHE 332"; "GEO 102"; "GEO 103"; "GEO 112"; "GEO 123"; "GEO 122"; "PHY 125"; "PHY 127"; "PHY 132"; "PHY 134"; "PHY 142"; "PHY 251"; "PHY 252"), sci_more).

%% set of all sci courses taken
courses_taken(Id, Credit, Grade, sci_courses) :- taken(Id, Credit, Grade, _, _), c(Id, sci_more).
courses_taken(Id, Credit, Grade, sci_courses) :- taken(Id, Credit, Grade, _, _), c(Id, L), sci_combs(L).

%% a subset of sci courses taken: to satisfy sci_req, sci_cred_req and sci_grade_req.
{ courses_taken(Id, Credit, Grade, sci_subset) : courses_taken(Id, Credit, Grade, sci_courses) }.

%% use the same subset to check both credit and grade requirements:
%% the subset must contain one sci_combo, use in requirement 7.
sci_req :- sci_combs(L),        %% there exists one combo L
           c(Id1, L),           %%% assume each combo has only two courses.
           c(Id2, L),
           Id1 != Id2,
           courses_taken(Id1, _, _, sci_subset), courses_taken(Id2, _, _, sci_subset).

% The courses selected in 7 and 8 must carry at least 9 credits.
%% Id is needed otherwise credit will only be counted once for courses that have the same credits.
sci_cred_req :-  #sum { Credit, Id : courses_taken(Id, Credit, _, sci_subset) } >= 9.

% The grade point average for the courses in Requirements 7 and 8 must be at least 2.00.
sci_grade_req :- gpa_mul_100(sci_subset, Gpa), Gpa >= 200.  %% scaled by 100.

%% witness for sci is the subset used to satisfy all sci requirements, as in python.
wit(sci, Id) :- courses_taken(Id, _, _, sci_subset).

% 9. Professional Ethics
c("CSE 312", ethics).
s(ethics, ethics).

ethics_req :- passed_all(ethics).

% 10. Upper-Division Writing Requirement
c("CSE 300", writing).
s(writing, writing).

writing_req :- passed_all(writing).

%%% (copied from python) todo:
% Note: All students are encouraged to discuss their program with an
% undergraduate advisor.
% In Requirement 2 above, CSE/ESE double majors may substitute ESE
% 440, ESE 441 Electrical Engineering Design I, II for CSE 416 Software
% Engineering provided that the design project contains a significant
% software component. Approval of the Department of Computer Science is
% required.
%% this is at the top of the section on the webpage:
% The major in Computer Science leads to the Bachelor of Science degree.
% Completion of the major requires approximately 80 credits.  %%% todo: count
% At least 24 credits from items 1 to 3 below, and at least 18 credits from
% items 2 and 3, must be completed at Stony Brook.
%%% assume to be not about "The courses taken to satisfy Requirements ..."

item123_course(Id) :- intro_courses(Id).
item123_course(Id) :- adv_courses(Id).
item123_course(Id) :- courses_taken(Id, _, _, elect_passed).

item23_course(Id) :- adv_courses(Id).
item23_course(Id) :- courses_taken(Id, _, _, elect_passed).

credits_at_sb_req :-
  #sum { Credit, Id : taken(Id, Credit, _, _, "SB"), item123_course(Id) } >= 24,
  #sum { Credit, Id : taken(Id, Credit, _, _, "SB"), item23_course(Id) } >= 18.

wit(credits_at_SB, Id) :- item123_course(Id), taken(Id, _, _, _, "SB").
wit(credits_at_SB, Id) :- item23_course(Id), taken(Id, _, _, _, "SB").

%% student facts
standing("U1"). standing("U2"). standing("U3"). standing("U4").
major("CSE").

#program check.
%%%%% test
%% to play around:
%%   you can comment out more of the taken_id facts.
%%   change the generate rule (in the planning part below) to set upper_bound to max number of courses to plan for, e.g. 5.
%%   upper_bound can also be removed, which means there is no limit.
%%   { plan_to_take(Id) : can_take(Id) } upper_bound
%% first line commented out to test planning
% taken_id("CSE 114"). taken_id("CSE 214"). taken_id("CSE 216").
% taken_id("CSE 160"). taken_id("CSE 161"). taken_id("CSE 260"). taken_id("CSE 261").
% taken_id("CSE 215"). taken_id("CSE 220").
% taken_id("CSE 303"). taken_id("CSE 310"). taken_id("CSE 316").
% taken_id("CSE 320"). taken_id("CSE 373"). taken_id("CSE 416").
% taken_id("MAT 131"). taken_id("MAT 132"). taken_id("AMS 210").
% taken_id("AMS 301"). taken_id("AMS 310").
% taken_id("CSE 300"). taken_id("CSE 312").
% taken_id("CSE 360"). taken_id("CSE 361"). taken_id("CSE 351").
% taken_id("CSE 352"). taken_id("CSE 353"). taken_id("CSE 355").
% taken_id("PHY 131"). taken_id("PHY 133"). taken_id("AST 203").

%% generate input, assume all courses are taken in semester 0 (before planning semesters)
% taken(Id, Credit, "A", 0, "SB") :- course(Id, Credit), taken_id(Id).

%% requirements:
%% req_name: used in the constraint to check if all requirements are satisfied.
%% req_passed: used in the constraint, also in the output.
%%% ISSUE: this feels repetitive as each requirement is written twice.
req_name(intro; adv; elect; calc; alg; sta; sci; ethics; writing; credits_at_SB).

%% req 1-6
req_passed(intro)         :- intro_req.
req_passed(adv)           :- adv_req.
req_passed(elect)         :- elect_req.
req_passed(calc)          :- calc_req.
req_passed(alg)           :- alg_req.
req_passed(sta)           :- sta_req.

%% req 7, 8
req_passed(sci)           :- sci_req, sci_cred_req, sci_grade_req.

%% req 9, 10
req_passed(ethics)        :- ethics_req.
req_passed(writing)       :- writing_req.
req_passed(credits_at_SB) :- credits_at_sb_req.

req_missing(Item) :- req_name(Item), not req_passed(Item).
deg_req :- not req_missing(_).

%% added for rules that require generating subsets
%% otherwise clingo will ground them as empty sets, causing the requirements to fail.
#maximize { 1, Item : req_passed(Item) }.

% #show deg_req/0.
% #show wit/2.
% %% when degree requirements are not satisfied, show which requirements are missing and which are passed.
% #show req_passed(Item) : req_passed(Item), not deg_req.
% #show req_missing(Item) : req_missing(Item), not deg_req.

#program plan.
%%%%% planning

%%%% constants
#const min_semester = 1.            %% min semester number, assume 1
#const max_semester = 8.            %% max number of semesters, assume 8
#const max_courses_per_semester = 4.

%% define semester to be from 1 to 8
semester(min_semester..max_semester).

%%%% rules used in KB

%% for prereq and antireq
%% course Id taken before semester Sem. used in prereq and antireq rules in the KB.
%% e.g. prereq("CSE 214", Sem) :- semester(Sem), passed_before("CSE 114", Sem).
taken_before(Id, Sem) :- semester(Sem), taken(Id, _, _, Sem1, _), Sem1 < Sem.

%% for prereq only
passed_before(Id, Sem) :- semester(Sem), taken(Id, _, Grade, Sem1, _), Sem1 < Sem, c_or_higher(Grade).

%% for coreq only
%% e.g. coreq("CSE 161", Sem) :- semester(Sem), taken_same("CSE 160", Sem).
taken_same(Id, Sem) :- semester(Sem), taken(Id, _, _, Sem, _).

%%%% generate
%% if a course is not taken, we consider it for planning.
%%   requisites (prereq, coreq, antireq) will be checked in constraints.
%%   can't use taken/5 because planning needs to add new taken facts.
can_take(Id) :- course(Id, _), not taken_id(Id).

%% choose up to max_course_planned courses to plan for
%% assume each planned course will be taken with credit, grade ...
%% for each course, only take it in one semester.
{ taken(Id, 4, "A", Sem, "SB") : Sem = min_semester..max_semester } 1 :- can_take(Id). %% #const can't be used in the head

%% planned if not in the input (taken_id) and chosen in the generate rule above.
planned(Id, Sem) :- taken(Id, _, _, Sem, _), not taken_id(Id).

%%%% constraints

%% all requirements must be satisfied.
:- req_name(X), not req_passed(X).

%% prereq: if a course is planned, then the prereq must be satisfied at the same semester.
:-  planned(Id, Sem),
    has_prereq(Id),
    not prereq(Id, Sem).

% coreq: if a course is planned, then the coreq must be satisfied at the same semester.
:-  planned(Id, Sem),
    has_coreq(Id),
    not coreq(Id, Sem).

%% antireq                     %% TODO: for antireq we can not simply assume unsupported is true or false
% :-  plan_to_take(Id, Sem),   %%        need to work on the KB on each one (there is only 3 courses with anti-req)
%     has_anti_req(Id), 
%     anti_req(Id, Sem).      %% anti-req can not be satisfied

%% do not exceed max courses per semester
:- semester(Sem), #count { Id : planned(Id, Sem) } > max_courses_per_semester.

%%%% optimization
%% minimize the number of courses to take to satisfy all requirements.
% #minimize { 1, Id : taken(Id, _, _, _, _) }.

%% minimize the number of semesters
max_sem(X) :- semester(X), X = #max { Sem : planned(_, Sem) }.
#minimize { X: max_sem(X) }.

% #show planned/2.       %% courses planned

% #script (python)
% import clingo

% def upper_division(id):
%   return clingo.Number(int(id.string[4:]) >= 300)

% def course_prog(id):
%   return clingo.String(id.string[:3])

% def on_model(model, mode: str):     ## output
%   checked = {}              ## key: requirement item, value: [status, witness list]
%   planned_courses = {}      ## course Id to semester, key: course Id, value: semester
%   schedule = {}             ## inverse of planned_courses, key: semester, value: list of course Ids
  
%   degree_passed = False

%   for sym in model.symbols(atoms=True):       ## collect status and planned courses
%     if sym.name == "deg_req":
%       degree_passed = True
%     elif sym.name == "req_passed":
%       item = str(sym.arguments[0])
%       checked[item] = [True, []]
%     elif sym.name == "req_missing":
%       item = str(sym.arguments[0])
%       checked[item] = [False, []]
%     elif sym.name == "planned":     ## planned courses, used to generate the schedule
%       cid = str(sym.arguments[0]).strip('"')
%       sem = sym.arguments[1].number
%       planned_courses[cid] = sem
%       schedule[sem] = schedule[sem] + [cid] if sem in schedule else [cid]

%   for sym in model.symbols(atoms=True):       ## adding witness
%     if sym.name == "wit":
%       item = str(sym.arguments[0])
%       cid = str(sym.arguments[1]).strip('"')
      
%       if cid in planned_courses:    ## different format for planned courses (so we know they are planned)
%         sem = planned_courses[cid]
%         course = f"{cid} (in Sem {sem})"
%       else:
%         course = cid

%       if item in checked:
%         checked[item][1].append(course)
%       else:
%         checked[item] = [True, [course]]

%   for key in checked:
%     status, wits = checked[key]
%     checked[key] = (status, sorted(wits))   ## sort the witness list, as in python
  
%   checked['degree'] = (degree_passed, [])

%   print('---- checked, from running degree_reqs:')      ## same output format as in python
%   print(checked)
%   print('----')
  
%   for item, (check, wits) in checked.items():
%     print(item + '\t ' + str(check) + ' ' + str(wits))
  
%   if mode == 'plan': # print the schedule
%     print('---- planned schedule:')
%     for sem in sorted(schedule):
%       print(f"Semester {sem}: {schedule[sem]}")

% def main(prg):
%   mode = 'check'
%   if mode == 'check':   ## check only
%     prg.ground([("base", []), ("check", [])])
%   elif mode == 'plan':  ## check + plan
%     prg.ground([("base", []), ("check", []), ("plan", [])])
%   prg.solve(on_model=lambda m: on_model(m, mode))
% #end.