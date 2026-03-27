%% comments in this file:
%%    %: english text from the degree requirements, comments in python, or commented out code
%%   %%: my own comments explaining the logic
%%  %%%: issues, some are copied from python

%% clingo version for checking and planning for BS degree requirements in CSE at Stony Brook University (Fall 2024).
%% python version: https://github.com/unicomputing/cs_reqs/blob/main/cs_reqs_2024.da (checking only)

grade_higher_than(Grade, ExpectedGrade) :- grade_to_points(Grade, Points), grade_to_points(ExpectedGrade, ExpectedPoints), Points >= ExpectedPoints.
c_or_higher(Grade) :- grade_higher_than(Grade, "C").

%% mapping letter grade to points for GPA calculation
%% scaled by 100 to make each integer
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

%% courses_taken(Id, Credits, Grade, Subset): a subset of courses taken, identified by Subset.

%% gpa calculation, takes a subset (courses_taken, indicated by the subset name) and calculates the GPA = floor(weighted sum / sum of weights).
%% only consider letter grades in grade_to_points
%%% If the same course is taken multiple times, it will only be counted once here. Add 'When' to the Id to distinguish different attempts if we want to count them separately.
gpa_mul_100(TakenSubset, Gpa) :-
  courses_taken(_, _, _, TakenSubset),
  WeightedSum = #sum { Credit*Points, Id : courses_taken(Id, Credit, Grade, TakenSubset), grade_to_points(Grade, Points) },
  SumOfWeights = #sum { Credit, Id : courses_taken(Id, Credit, Grade, TakenSubset), grade_to_points(Grade, _) },
  SumOfWeights > 0,
  Gpa = WeightedSum / SumOfWeights. %%% integer floor division. 

%% gpa is 0 when sum of weights is 0. same as in python
gpa_mul_100(TakenSubset, 0) :-
  courses_taken(_, _, _, TakenSubset),
  SumOfWeights = #sum { Credit, Id : courses_taken(Id, Credit, Grade, TakenSubset), grade_to_points(Grade, _) },
  SumOfWeights = 0.

% taken(Id, Credits, Grade, When, Where): taken course Id with Credits, etc.

passed(Id) :- taken(Id, Credits_, Grade, When_, Where_), c_or_higher(Grade).

% passed all courses with course Id in Subject
passed_all(Subject) :-
  c(_, Subject),                 % c(Id, Subject): course Id in Subject
  passed(Id) : c(Id, Subject).   %% for each course Id in Subject, passed(Id) is true

% course C is witness for passing all courses in a subject in requirement Item
wit(Item, Id) :- s(Item, Subj), passed_all(Subj), c(Id, Subj).

% return set of courses in subjects in requirement item.
courses(Id, Item) :- s(Item, Subj), c(Id, Subj).

% 1. Required Introductory Courses
c("CSE 114", prog). c("CSE 214", prog). c("CSE 216", prog). 
c("CSE 160", prog2). c("CSE 161", prog2). 
c("CSE 260", prog2). c("CSE 261", prog2).
c("CSE 215", dmath). 
c("CSE 150", dmath2).
c("CSE 220", sys). 
s(intro, (prog; prog2; dmath; dmath2; sys)).

intro_req :-
  passed_all(prog; prog2),
  passed_all(dmath; dmath2),
  passed_all(sys).

% 2. Required Advanced Courses
c("CSE 303", theory). c("CSE 350", theory2).
c("CSE 373", algo). c("CSE 385", algo2).
c("CSE 310", other). c("CSE 316", other). c("CSE 320", other). c("CSE 416", other).
s(adv, (theory; theory2; algo; algo2; other)).

adv_req :- 
  passed_all(theory; theory2),
  passed_all(algo; algo2),
  passed_all(other).

% 3. Computer Science Electives  %% simpler than 2025
c(("CSE 475"; "CSE 495"; "CSE 300"; "CSE 301"; "CSE 312"), elect_exclude).

courses_taken(Id, Credits, Grade, elect_passed) :- 
  taken(Id, Credits, Grade, _, _), c_or_higher(Grade),
  Prog = @course_prog(Id), 
  Prog = "CSE", 
  @upper_division(Id) = 1,    %% is upper division
  Credits >= 3, not courses(Id, adv), not c(Id, elect_exclude).

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
% combinations:
c("BIO 201", bio). c("BIO 204", bio).
c("BIO 202", bio2). c("BIO 204", bio2).
c("BIO 203", bio3). c("BIO 204", bio3).
c("CHE 131", che). c("CHE 133", che).
c("CHE 152", che2). c("CHE 154", che2).
c("PHY 126", phy). c("PHY 133", phy).
c("PHY 131", phy2). c("PHY 133", phy2).
c("PHY 141", phy3). c("PHY 133", phy3).
sci_combs(bio; bio2; bio3; che; che2; phy; phy2; phy3).

% 8. Additional natural science courses selected from above and following list:
% Note: The courses selected in 7 and 8 must carry at least 9 credits.
c(("AST 203"; "AST 205"; "CHE 132"; "CHE 321"; "CHE 322"; "CHE 331"; "CHE 332"; "GEO 102"; "GEO 103"; "GEO 112"; "GEO 123"; "GEO 122"; "PHY 125"; "PHY 127"; "PHY 132"; "PHY 134"; "PHY 142"; "PHY 251"; "PHY 252"), sci_more).

%% sci_courses(taken) in python: set of all sci courses taken
courses_taken(Id, Credit, Grade, sci_courses) :- taken(Id, Credit, Grade, _, _), c(Id, sci_more).
courses_taken(Id, Credit, Grade, sci_courses) :- taken(Id, Credit, Grade, _, _), c(Id, L), sci_combs(L).

%% generate a subset of sci_courses taken: use the same subset to satisfy sci_req, sci_cred_req and sci_grade_req.
{ courses_taken(Id, Credit, Grade, sci_subset) : courses_taken(Id, Credit, Grade, sci_courses) }.

%% the subset must contain one sci_combo, use in requirement 7.
sci_req :- sci_combs(L), courses_taken(Id, _, _, sci_subset) : c(Id, L).

% The courses selected in 7 and 8 must carry at least 9 credits.
%% Id is needed otherwise credit will only be counted once for courses that have the same credits.
sci_cred_req :-  #sum { Credit, Id : courses_taken(Id, Credit, _, sci_subset) } >= 9.

% The grade point average for the courses in Requirements 7 and 8 must be at least 2.00.
sci_grade_req :- gpa_mul_100(sci_subset, Gpa), Gpa >= 200.

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

%% courses in items 1,2,3
items123_course(Id) :- courses(Id, intro).
items123_course(Id) :- courses(Id, adv).
items123_course(Id) :- courses_taken(Id, _, _, elect_passed).

%% courses in items 2,3
items23_course(Id) :- courses(Id, adv).
items23_course(Id) :- courses_taken(Id, _, _, elect_passed).

credits_at_sb_req :-
  #sum { Credit, Id : taken(Id, Credit, _, _, "SB"), items123_course(Id) } >= 24,
  #sum { Credit, Id : taken(Id, Credit, _, _, "SB"), items23_course(Id) } >= 18.

wit(credits_at_SB, Id) :- items123_course(Id), taken(Id, _, _, _, "SB").
wit(credits_at_SB, Id) :- items23_course(Id), taken(Id, _, _, _, "SB").

% Grading (%%% comments are copied from python)
%
% All courses taken to satisfy Requirements 1 through 10 must be taken for
% a letter grade.  %%% always true if the two below are true
% The courses in Requirements 1-6, 9, and 10 must be passed with a letter
% grade of C or higher.  %%% assume to be: The courses *taken to satisfy* Req...
% The grade point average for the courses in Requirements 7 and 8 must be
% at least 2.00.  %%% assume to be: The courses *taken to satisfy* Req...
%% merged with 7 and 8; otherwise, not correct if as assumed.

#show c/1.

#program check.

%% whether the taken courses satisfy all requirements for BS major in CSE

%%% there are no constraints used in checking, as when the degree requirements are not satisfied we want a model to show which reqs are (are not) satisfied and their witnesses.

%% req_name: used in the constraint to check if all requirements are satisfied.
req_name(intro; adv; elect; calc; alg; sta; sci; ethics; writing; credits_at_SB).

%%% could've used req_passed directly in each requirement, but keep them same as in prolog.
req_passed(intro)         :- intro_req.
req_passed(adv)           :- adv_req.
req_passed(elect)         :- elect_req.
req_passed(calc)          :- calc_req.
req_passed(alg)           :- alg_req.
req_passed(sta)           :- sta_req.
req_passed(sci)           :- sci_req, sci_cred_req, sci_grade_req.
req_passed(ethics)        :- ethics_req.
req_passed(writing)       :- writing_req.
req_passed(credits_at_SB) :- credits_at_sb_req.

deg_req :- req_passed(Item) : req_name(Item).   %% all requirements passed

#maximize { 1@3, Item : req_passed(Item) }.     %% prioritize satisfying more requirements

#program plan.

%% constants
#const min_semester = 1.            %% min semester number
#const max_semester = 8.            %% max number of semesters
#const max_courses_per_semester = 4.%% max courses to take in one semester

semester(min_semester..max_semester).

%% The KB uses temporal relations (*_before, *_same) to evaluate requisites.
%% e.g. prereq("CSE 214", Sem) :- semester(Sem), passed_before("CSE 114", Sem).
%% e.g. coreq("CSE 161", Sem) :- semester(Sem), taken_same("CSE 160", Sem).

%% course Id is taken before semester Sem. %% for prereq and antireq
taken_before(Id, Sem) :- semester(Sem), taken(Id, _, _, Sem1, _), Sem1 < Sem.

%% course Id is passed before semester Sem. %% for prereq only
passed_before((Id, ExpectedGrade), Sem) :- semester(Sem), taken(Id, _, Grade, Sem1, _), Sem1 < Sem, grade_higher_than(Grade, ExpectedGrade).

%% course Id is taken at semester Sem. %% for coreq only   %%% todo: rename to taken_at?
taken_same(Id, Sem) :- semester(Sem), taken(Id, _, _, Sem, _).

%%%% generate
%% any untaken course can be planned for at most one semester.
{ planned(Id, Sem) : Sem = min_semester..max_semester } 1 :- course(Id, _), not taken_id(Id). %% #const can't be used in the head

%% assume course planned has grade A and taken in SB
taken(Id, Credit, "A", Sem, "SB") :- course(Id, Credit), planned(Id, Sem). 

%%%% constraints
%% all requirements must be satisfied.
:- req_name(X), not req_passed(X).

%% prereq: if a course is planned, then the prereq must be satisfied at the same semester.
:- planned(Id, Sem),
   has_prereq(Id),
   not prereq(Id, Sem).

% coreq: if a course is planned, then the coreq must be satisfied at the same semester.
:- planned(Id, Sem),
   has_coreq(Id),
   not coreq(Id, Sem).

% antireq
:- planned(Id, Sem),  %% todo: need to work on the KB on each one (there is only 3 courses with anti-req)
   has_anti_req(Id), 
   anti_req(Id, Sem).      %% anti-req can not be satisfied

%% do not exceed max courses per semester
:- semester(Sem), #count { Id : planned(Id, Sem) } > max_courses_per_semester.

%%%% optimization (in inverse order of significance)
%% minimize the number of semesters
max_sem(X) :- semester(X), X = #max { Sem : planned(_, Sem) }.
#minimize { X@1: max_sem(X) }.

%% minimize the number of courses to take to satisfy all requirements.
#minimize { 1@2, Id : planned(Id, _) }.

#program input.

%% student facts
standing("U1"). standing("U2"). standing("U3"). standing("U4").
major("CSE"). permission.

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
taken(Id, Credit, "A", 0, "SB") :- course(Id, Credit), taken_id(Id).

%%% ISSUE: better ways to do the same?
%%%   Clingo does not seem to have native support for string manipulation,
%%%   therefore we use external python functions to extract course number and program from course Id.

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