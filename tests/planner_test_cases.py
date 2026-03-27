from ortools_code.planner import catalog


FULL = {
    'CSE 114', 'CSE 214', 'CSE 216', 'CSE 215', 'CSE 220',
    'CSE 303', 'CSE 310', 'CSE 316', 'CSE 320', 'CSE 373', 'CSE 416',
    'CSE 360', 'CSE 361', 'CSE 351', 'CSE 352', 'CSE 353', 'CSE 355',
    'MAT 131', 'MAT 132', 'AMS 210', 'AMS 301', 'AMS 310',
    'PHY 131', 'PHY 132', 'PHY 133', 'AST 203',
    'CSE 300', 'CSE 312',
}


def history(ids, grade='A', loc='SB'):
    return [(cid, catalog[cid].credits, grade, loc) for cid in sorted(ids)]


def test_plan_no_electives():
    """Remove all 6 electives — planner must pick >= 4."""
    elects = {'CSE 360', 'CSE 361', 'CSE 351', 'CSE 352', 'CSE 353', 'CSE 355'}
    taken = history(FULL - elects)

    def validate(checked, schedule_courses):
        assert len(schedule_courses) >= 1
        assert len(checked['elect'][1]) >= 4

    return taken, validate


def test_plan_no_calc():
    """Remove all science — planner picks combo + extras for >= 9 credits."""
    ids = FULL - {'MAT 131', 'MAT 132'}
    taken = history(ids)

    def validate(checked, schedule_courses):
        assert len(schedule_courses) >= 1
        assert len(checked['calc'][1]) >= 2

    return taken, validate


def test_plan_no_sta():
    """Remove calculus — planner picks a calc sequence."""
    ids = FULL - {'AMS 301', 'AMS 310'}
    taken = history(ids)

    def validate(checked, schedule_courses):
        assert len(schedule_courses) >= 1
        sta = set(checked['sta'][1])
        assert 'AMS 301' in sta
        assert 'AMS 310' in sta or 'AMS 311' in sta

    return taken, validate


def test_plan_no_alg():
    """Remove AMS 301 + AMS 310 — planner restores them."""
    ids = FULL - {'AMS 210'}
    taken = history(ids)

    def validate(checked, schedule_courses):
        assert len(schedule_courses) >= 1
        alg = set(checked['alg'][1])
        assert 'AMS 210' in alg or 'MAT 211' in alg

    return taken, validate


