from ortools_code.planner import plan, catalog, sci_combs
from ortools_code.course_catalog import Major, Standing
import python_code.cs_reqs_2024 as checker
from python_code.cs_reqs_2024 import Taken as CTaken, degree_reqs

# ── helpers ────────────────────────────────────────────────────

def history(ids, grade='A', loc='SB'):
    """Build planner-format history from course ids, using real catalog credits."""
    return [(cid, catalog[cid].credits, grade, loc) for cid in sorted(ids)]

def to_checker_taken(hist, schedule, grades):
    """Merge planner history + planned schedule into checker's Taken namedtuple set."""
    taken = set()
    for cid, cr, grade, loc in hist:
        taken.add(CTaken(cid, cr, grade, (2024, 2), loc))
    for cid in schedule:
        taken.add(CTaken(cid, catalog[cid].credits, grades.get(cid, 'C'),
                         (2025, 1), 'SB'))
    return taken

def sci_credits(courses):
    return sum(catalog[c].credits for c in courses)

def has_combo(courses):
    return any(comb <= set(courses) for comb in sci_combs)


# ════════════════════════════════════════════════════════════════
#  Complete course set (real catalog credits)
#
#  PHY 132 added vs checker test_0 so science reaches 9 credits:
#    PHY 131(3) + PHY 133(1) + PHY 132(3) + AST 203(3) = 10
# ════════════════════════════════════════════════════════════════

FULL = {
    'CSE 114', 'CSE 214', 'CSE 216', 'CSE 215', 'CSE 220',           # intro
    'CSE 303', 'CSE 310', 'CSE 316', 'CSE 320', 'CSE 373', 'CSE 416', # adv
    'CSE 360', 'CSE 361', 'CSE 351', 'CSE 352', 'CSE 353', 'CSE 355', # elect
    'MAT 131', 'MAT 132', 'AMS 210', 'AMS 301', 'AMS 310',           # math
    'PHY 131', 'PHY 132', 'PHY 133', 'AST 203',                       # science
    'CSE 300', 'CSE 312',                                              # ethics+writing
}

ATTRS = (Major("CSE"), Standing("U4"))

EXPECTED = {
    'intro':   (True, ['CSE 114', 'CSE 214', 'CSE 215', 'CSE 216', 'CSE 220']),
    'adv':     (True, ['CSE 303', 'CSE 310', 'CSE 316', 'CSE 320', 'CSE 373', 'CSE 416']),
    'elect':   (True, ['CSE 351', 'CSE 352', 'CSE 353', 'CSE 355', 'CSE 360', 'CSE 361']),
    'calc':    (True, ['MAT 131', 'MAT 132']),
    'alg':     (True, ['AMS 210']),
    'sta':     (True, ['AMS 301', 'AMS 310']),
    'sci':     (True, ['AST 203', 'PHY 131', 'PHY 132', 'PHY 133']),
    'ethics':  (True, ['CSE 312']),
    'writing': (True, ['CSE 300']),
    'credits_at_SB': (True, ['items123 = 56', 'items23 = 36']),
    'degree':  (True, []),
}


# ════════════════════════════════════════════════════════════════
#  TYPE 1: planner as checker — complete history, 0 new courses
# ════════════════════════════════════════════════════════════════

def test_check_full():
    """Standard full course set — should plan nothing new."""
    checked, schedule, _ = plan(history(FULL), *ATTRS)
    assert schedule == {}, f"expected 0 new, got {len(schedule)}"
    assert checked == EXPECTED


def test_check_alt_calc_ams():
    """AMS calculus sequence instead of MAT."""
    ids = (FULL - {'MAT 131', 'MAT 132'}) | {'AMS 151', 'AMS 161'}
    checked, schedule, _ = plan(history(ids), *ATTRS)
    assert schedule == {}
    assert checked['calc'] == (True, ['AMS 151', 'AMS 161'])
    assert checked['degree'] == (True, [])


def test_check_alt_calc_mat3():
    """MAT 125/126/127 three-course calculus sequence."""
    ids = (FULL - {'MAT 131', 'MAT 132'}) | {'MAT 125', 'MAT 126', 'MAT 127'}
    checked, schedule, _ = plan(history(ids), *ATTRS)
    assert schedule == {}
    assert checked['calc'] == (True, ['MAT 125', 'MAT 126', 'MAT 127'])
    assert checked['degree'] == (True, [])


def test_check_alt_alg():
    """MAT 211 instead of AMS 210."""
    ids = (FULL - {'AMS 210'}) | {'MAT 211'}
    checked, schedule, _ = plan(history(ids), *ATTRS)
    assert schedule == {}
    assert checked['alg'] == (True, ['MAT 211'])


def test_check_alt_sta():
    """AMS 311 instead of AMS 310."""
    ids = (FULL - {'AMS 310'}) | {'AMS 311'}
    checked, schedule, _ = plan(history(ids), *ATTRS)
    assert schedule == {}
    assert checked['sta'] == (True, ['AMS 301', 'AMS 311'])


def test_check_sci_bio():
    """BIO lecture/lab combo instead of PHY combo."""
    # BIO 201(3)+BIO 204(1)+PHY 132(3)+AST 203(3) = 10 >= 9
    ids = (FULL - {'PHY 131', 'PHY 133'}) | {'BIO 201', 'BIO 204'}
    checked, schedule, _ = plan(history(ids), *ATTRS)
    assert schedule == {}
    sci = checked['sci'][1]
    assert has_combo(sci) and sci_credits(sci) >= 9


def test_check_sci_che():
    """CHE combo.  CHE 131(3)+CHE 133(1)+CHE 132(3)+AST 203(3)=10."""
    ids = (FULL - {'PHY 131', 'PHY 132', 'PHY 133'}) | {'CHE 131', 'CHE 133', 'CHE 132'}
    checked, schedule, _ = plan(history(ids), *ATTRS)
    assert schedule == {}
    sci = checked['sci'][1]
    assert has_combo(sci) and sci_credits(sci) >= 9


def test_check_honors_intro():
    """Honors programming track + honors discrete math."""
    ids = (FULL - {'CSE 114', 'CSE 214', 'CSE 216', 'CSE 215'}
               | {'CSE 160', 'CSE 161', 'CSE 260', 'CSE 261', 'CSE 150'})
    checked, schedule, _ = plan(history(ids), *ATTRS)
    assert schedule == {}
    assert 'CSE 160' in checked['intro'][1]
    assert 'CSE 150' in checked['intro'][1]


# ════════════════════════════════════════════════════════════════
#  TYPE 2: planner fills gaps → checker validates combined result
# ════════════════════════════════════════════════════════════════

def plan_and_check(ids):
    """Run planner, then validate combined output with checker.degree_reqs."""
    hist = history(ids)
    checked, schedule, grades = plan(hist, *ATTRS)

    assert checked is not None, "planner found no solution"
    assert len(schedule) > 0, "expected planner to add courses"

    checker.w = {}
    combined = to_checker_taken(hist, schedule, grades)
    result = degree_reqs(combined)

    failed = [k for k, v in result.items() if not v[0]]
    assert result['degree'][0], f"checker rejected planner output on: {failed}"
    return checked, schedule


def test_plan_no_electives():
    """Remove all 6 electives — planner must pick >= 4."""
    elects = {'CSE 360', 'CSE 361', 'CSE 351', 'CSE 352', 'CSE 353', 'CSE 355'}
    checked, _ = plan_and_check(FULL - elects)
    assert len(checked['elect'][1]) >= 4


def test_plan_no_science():
    """Remove all science — planner picks combo + extras for >= 9 credits."""
    checked, _ = plan_and_check(FULL - {'PHY 131', 'PHY 132', 'PHY 133', 'AST 203'})
    assert has_combo(checked['sci'][1])
    assert sci_credits(checked['sci'][1]) >= 9


def test_plan_no_calc():
    """Remove calculus — planner picks a calc sequence."""
    checked, _ = plan_and_check(FULL - {'MAT 131', 'MAT 132'})
    assert len(checked['calc'][1]) >= 2


def test_plan_no_sta():
    """Remove AMS 301 + AMS 310 — planner restores them."""
    checked, _ = plan_and_check(FULL - {'AMS 301', 'AMS 310'})
    assert 'AMS 301' in checked['sta'][1]
    assert 'AMS 310' in checked['sta'][1] or 'AMS 311' in checked['sta'][1]


def test_plan_no_alg():
    """Remove linear algebra — planner picks AMS 210 or MAT 211."""
    checked, _ = plan_and_check(FULL - {'AMS 210'})
    assert 'AMS 210' in checked['alg'][1] or 'MAT 211' in checked['alg'][1]


def test_plan_from_intro():
    """Only intro courses taken — planner fills everything else."""
    intro = {'CSE 114', 'CSE 214', 'CSE 216', 'CSE 215', 'CSE 220'}
    checked, schedule = plan_and_check(intro)
    assert checked['intro'] == (True, sorted(intro))
    assert len(schedule) >= 15


# ════════════════════════════════════════════════════════════════

import inspect, sys

def run_tests():
    mod = sys.modules[__name__]
    tests = sorted((n, f) for n, f in inspect.getmembers(mod, inspect.isfunction)
                   if n.startswith('test_'))
    passed = failed = 0
    for name, func in tests:
        checker.w = {}
        try:
            print(f"\n{'='*60}\n{name}")
            func()
            print(f"  PASSED")
            passed += 1
        except Exception as e:
            print(f"  FAILED: {e}")
            failed += 1
    print(f"\n{'='*60}\n{passed} passed, {failed} failed out of {passed+failed}")

if __name__ == '__main__':
    run_tests()