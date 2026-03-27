import inspect
import io
import re
from contextlib import redirect_stdout
from pathlib import Path

import python_code.cs_reqs_2024 as checker
from clingo_code.run_clingo import run_clingo
from ortools_code.course_catalog import Major, Standing
from ortools_code.planner import catalog, plan
from python_code.cs_reqs_2024 import Taken, degree_reqs

import tests.planner_test_cases as test_cases


ROOT = Path(__file__).resolve().parents[1]


def normalize_witness(value):
    return re.sub(r" \(sem \d+\)$", "", value)


def normalize_checked(checked):
    out = {}
    for req, (ok, witness) in checked.items():
        out[req] = (ok, sorted({normalize_witness(w) for w in witness}))
    return out

def to_checker_taken(history, planned_courses):
    taken = set()
    for cid, cr, grade, where in history:
        taken.add(Taken(cid, cr, grade, (2024, 2), where))
    for cid, when in planned_courses.items():
        taken.add(Taken(cid, catalog[cid].credits, 'C', when, 'SB'))
    return taken


def clingo_sem_to_when(sem):
    return 2024 + (sem - 1) // 4, ((sem - 1) % 4) + 1


def validate_with_checker(history, planned_courses):
    checker.w = {}
    with redirect_stdout(io.StringIO()):
        result = degree_reqs(to_checker_taken(history, planned_courses))
    return result, result['degree'][0]


def run_ortools(case):
    history, _ = case
    with redirect_stdout(io.StringIO()):
        checked, schedule, _ = plan(history, Major('CSE'), Standing('U4'))
    checker_result, checker_ok = validate_with_checker(history, schedule)
    failed = [k for k, v in checker_result.items() if not v[0]]
    return normalize_checked(checked), set(schedule), checker_ok, failed


def run_clingo_backend(case):
    history, _ = case
    taken = {
        Taken(cid, cr, grade, (2024, 2), where)
        for cid, cr, grade, where in history
    }
    with redirect_stdout(io.StringIO()):
        checked, schedule, _ = run_clingo(
            taken_set=taken,
            mode='plan',
            main_lp=str(ROOT / 'clingo_code' / 'cse_req_clingo.lp'),
            kb_lp=str(ROOT / 'course_kb' / 'kb_complete.lp'),
        )

    planned_courses = {}
    for sem, courses in schedule.items():
        when = clingo_sem_to_when(sem)
        for cid in courses:
            planned_courses[cid] = when

    checker_result, checker_ok = validate_with_checker(history, planned_courses)
    failed = [k for k, v in checker_result.items() if not v[0]]
    schedule_courses = {cid for courses in schedule.values() for cid in courses}
    return normalize_checked(checked), schedule_courses, checker_ok, failed


def run_one(label, backend):
    tests = sorted(
        (name, func)
        for name, func in inspect.getmembers(test_cases, inspect.isfunction)
        if name.startswith('test_plan_')
    )

    passed = []
    failed = []

    for name, func in tests:
        try:
            case = func()
            checked, schedule_courses, checker_ok, checker_failed = backend(case)
            if not checker_ok:
                failed.append((name, f"python checker rejected combined plan on: {checker_failed}"))
                continue

            _, validate = case
            validate(checked, schedule_courses)
            passed.append(name)
        except Exception as e:
            failed.append((name, str(e)))

    print(f"\n-> {label}: passed {len(passed)} test cases, failed {len(failed)} test cases")
    for name, error in failed:
        print(f"   FAIL: {name}")
        print(f"      - {error}")


def run_all():
    run_one('ortools_code', run_ortools)
    run_one('clingo_code', run_clingo_backend)


if __name__ == '__main__':
    run_all()
