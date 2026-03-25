from collections import defaultdict

import clingo
import argparse
from pprint import pprint

class ClingoContext:
  ## can't have python code in the clingo file if using python api.
  ## the #script (python) in the clingo file is commented out, and we move the functions here.
  def upper_division(self, course_id):
    return clingo.Number(int(course_id.string[4:]) >= 300)

  def course_prog(self, course_id):
    return clingo.String(course_id.string[:3])

def print_clingo_stats(stats: clingo.Control.statistics):
  total_time = stats['summary']['times']['total']
  solve_time = stats['summary']['times']['solve']
  ground_time = total_time - solve_time
  
  print(f"\nTotal time: {total_time:.4f} seconds\n"
        f"Grounding time: {ground_time:.4f} seconds\n"
        f"Solving time: {solve_time:.4f} seconds\n")

def run_clingo(mode, main_lp, kb_lp, taken_set = set()):
  ## runs Clingo, injects the taken courses, and returns the checked dict and schedule.
  
  ## find optimal solution and supress warnings about undefined atoms
  ctrl = clingo.Control(["0", "-Wno-atom-undefined"])
  
  ctrl.load(main_lp)
  ctrl.load(kb_lp)
  
  items = ('intro', 'adv', 'elect', 'calc', 'alg', 'sta', 
          'sci', 'ethics', 'writing', 'credits_at_SB')

  test_facts = ""
  for c in taken_set:
    ## get taken facts from test, except we change the when to semester (1).
    test_facts += f'taken("{c.id}", {c.credits}, "{c.grade}", 1, "{c.where}").\n'
    if mode == 'plan':
      test_facts += f'taken_id("{c.id}").\n'  ## taken_id is only for planning, not needed in checking

  ctrl.add("base", [], test_facts)
  
  to_ground = [("base", []), ("input", []), ("check", [])]
  if mode == 'plan': to_ground.append(("plan", []))

  ctrl.ground(to_ground, context=ClingoContext())
  
  checked = {}  ## initialize all items to not passed
  degree_passed = False
  schedule = {}
  
  def on_model(model):    ## invoked for every model found
    nonlocal checked, schedule, degree_passed

    ## reset checked when there are multiple models (in planning mode)
    checked = {item: [False, []] for item in items}  ## initialize all items to not passed
    planned_courses = {}
    schedule = defaultdict(list)
    degree_passed = False
    
    for sym in model.symbols(atoms=True):     ## collect check for each requirement
      if sym.name == "deg_req":
        degree_passed = True
      elif sym.name == "req_passed":
        item = str(sym.arguments[0])
        checked[item][0] = True
      elif sym.name == "planned":             ## planning mode
        cid = str(sym.arguments[0]).strip('"')
        sem = sym.arguments[1].number
        planned_courses[cid] = sem            ## record planned semester
        schedule[sem].append(cid)             ## add course to schedule

    for sym in model.symbols(atoms=True):     ## collect witness
      if sym.name == "wit":
        item = str(sym.arguments[0])
        course = str(sym.arguments[1]).strip('"')
        if course in planned_courses:         ## for planned courses, indicate the semester
          course += f' (sem {planned_courses[course]})'
        checked[item][1].append(course)

  ctrl.solve(on_model=on_model)

  ## sort witness, same as test in python
  checked = {item: (check, sorted(wits)) for item, (check, wits) in checked.items()}          

  checked['degree'] = (degree_passed, [])
  
  for sem in schedule:
    schedule[sem].sort()
      
  return checked, schedule, ctrl.statistics

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Run the Degree Checker and Planner.")
  parser.add_argument('-m', '--mode', choices=['check', 'plan'], default='check', help="Run mode.")
  # parser.add_argument('-t', '--taken', nargs='+', default=[], help="List of taken courses (e.g. 'CSE 114' 'CSE 214').")
  parser.add_argument('-f', '--file', default='cse_req_clingo.lp', help="Path to the main .lp file that encodes the logic.")
  parser.add_argument('-k', '--kb', default='./kb/kb_complete.lp', help="Path to the KB .lp file.")
  
  args = parser.parse_args()
  
  print(f"--- Running in {args.mode.upper()} mode ---")
  checked, schedule, stats = run_clingo(mode=args.mode, main_lp=args.file, kb_lp=args.kb)
  
  if args.mode == 'check':
    pprint(checked)
  elif args.mode == 'plan':
    print(f"Degree Passed: {checked['degree'][0]}")
    print("\n---- planned schedule:")
    for sem in sorted(schedule):
      print(f"  Semester {sem}: {schedule[sem]}")
          
  print_clingo_stats(stats)