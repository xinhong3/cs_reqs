import clingo
import inspect
from pprint import pprint
import tests                ## tests.py in cs_reqs

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
  
  print(f"Total time: {total_time:.4f} seconds\n"
        f"Grounding time: {ground_time:.4f} seconds\n"
        f"Solving time: {solve_time:.4f} seconds\n")

def run_clingo_tests(taken_set):
  ## runs Clingo, injects the taken courses, and returns the checked dict.
  ctrl = clingo.Control()
  
  ctrl.load("cse_req_clingo.lp") 
  
  items = ('intro', 'adv', 'elect', 'calc', 'alg', 'sta', 
           'sci', 'ethics', 'writing', 'credits_at_SB')

  test_facts = ""
  for c in taken_set:
    ## get taken facts from test, except we change the when to semester (1).
    test_facts += f'taken("{c.id}", {c.credits}, "{c.grade}", 1, "{c.where}").\n'
  
  ctrl.add("base", [], test_facts)
  ctrl.ground([("base", []), ("check", [])], context=ClingoContext())
  
  checked = {}
  degree_passed = False
  
  def on_model(model):
    nonlocal degree_passed
    for sym in model.symbols(atoms=True):     ## collect check for each requirement
      if sym.name == "deg_req":
        degree_passed = True
      elif sym.name == "req_passed":
        name = str(sym.arguments[0])
        checked[name] = [True, []]
      elif sym.name == "req_missing":
        name = str(sym.arguments[0])
        checked[name] = [False, []]

    for sym in model.symbols(atoms=True):     ## collect witness
      if sym.name == "wit":
        name = str(sym.arguments[0])
        course = str(sym.arguments[1]).strip('"')
        if name in checked:
          checked[name][1].append(course)
        else:
          checked[name] = [True, [course]]

  ctrl.solve(on_model=on_model)

  for item in items:
    if item in checked:
      status, wits = checked[item]
      checked[item] = (status, sorted(wits))
      
  checked['degree'] = (degree_passed, [])
  return checked, ctrl.statistics

def testing(test_func):
  taken, expected_checked = test_func()
  print('---- taken_ids: ', sorted({c.id for c in taken}))
  clingo_checked, stats = run_clingo_tests(taken)
  
  for req, (expected_check, expecteed_wits_) in expected_checked.items():
    if req not in clingo_checked:
      assert False, f"Clingo is missing requirement: {req}"
    clingo_check = clingo_checked[req][0]
    assert expected_check == clingo_check, f"Expected {expected_check} for {req}, but got {clingo_check}"

  pprint(clingo_checked)
  print_clingo_stats(stats)

def run_tests():
  for (name, func) in inspect.getmembers(tests, inspect.isfunction):
    if name.startswith('test_'):
      print('--------', name, 'started:')
      testing(func)
      print('--------', name, 'passed !!!')

if __name__ == "__main__":
  run_tests()