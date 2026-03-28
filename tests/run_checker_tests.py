import inspect
from pprint import pformat
import python_code.cs_reqs_2024 as checker
from python_code.cs_reqs_2024 import degree_reqs
from ortools_code.planner import plan
from ortools_code.course_catalog import Major, Standing
from course_kb.course_kb import History
from clingo_code.run_clingo import run_clingo
import tests.checker_test_cases as test_cases

# ── adapters ─────────────────────────────────────────────────────────────────

def check_python(taken):
    checker.w = {}  # reset module-level witness state between calls
    return degree_reqs(taken)

def check_ortools(taken):
    history = [History(t.id, t.credits, t.grade, t.when, t.where) for t in taken]
    checked, _, _ = plan(history, Major("CSE"), Standing("U4"), check=True)
    return checked

def check_clingo(taken):
    checked, _, _ = run_clingo(
        taken_set=taken,
        mode='check',
        main_lp='clingo_code/cse_req_clingo.lp',
        kb_lp='course_kb/kb_complete.lp',
    )
    return checked

# ── runner ───────────────────────────────────────────────────────────────────

ALL_TESTS = sorted(
    (name, func)
    for name, func in inspect.getmembers(test_cases, inspect.isfunction)
    if name.startswith('test_')
)

APPROACHES = [
    ('python_code',  check_python),
    ('ortools_code', check_ortools),
    ('clingo_code',  check_clingo),
]

def run_one(label, check_fn):
    passed, failed = [], []
    errors = []

    for name, test_fn in ALL_TESTS:
        taken, expected = test_fn()
        try:
            result = check_fn(taken)
        except Exception as e:
            errors.append((name, e))
            failed.append((name, {}))
            continue

        diff = {
            req: {'expected': (exp_bool, exp_wits), 'got': result.get(req)}
            for req, (exp_bool, exp_wits) in expected.items()
            if req not in result
            or result[req][0] != exp_bool
            or (exp_bool and not set(exp_wits) <= set(result[req][1]))
        }
        if diff:
            failed.append((name, diff))
        else:
            passed.append(name)

    print(f"\n-> {label} : passed {len(passed)} test cases, failed {len(failed)} test cases")
    for name, diff in failed:
        err = next((e for n, e in errors if n == name), None)
        print(f"   FAIL: {name}" + (f" ({err})" if err else ""))
        if diff:
            print(pformat(diff, indent=6, sort_dicts=True))

def run_all():
    for label, check_fn in APPROACHES:
        run_one(label, check_fn)

if __name__ == '__main__':
    run_all()
    # run_one('ortools_code', check_ortools)
