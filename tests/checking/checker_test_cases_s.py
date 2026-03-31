from collections import namedtuple

Taken = namedtuple('Taken', ['id', 'credits', 'grade', 'when', 'where'])


def _course(cid, credits, grade, when, where='SB'):
    return Taken(cid, credits, grade, when, where)


# CSE_AMS Two transcript from users2.yaml (through Spring 2024)
# plus an automated planned scenario based on the request notes.

def _cse_ams_two_history():
    return {
        _course('WRT 102', 3, 'A', (2022, 4)),
        _course('AMS 151', 3, 'A', (2022, 4)),
        _course('POL 101', 3, 'A', (2022, 4)),
        _course('AMS 103', 3, 'A', (2022, 4)),

        _course('AMS 161', 3, 'A', (2023, 2)),
        _course('CSE 114', 4, 'A', (2023, 2)),
        _course('POL 102', 3, 'A', (2023, 2)),
        _course('POL 103', 3, 'A', (2023, 2)),

        _course('AMS 210', 3, 'A', (2023, 4)),
        _course('AMS 261', 3, 'A', (2023, 4)),
        _course('POL 201', 3, 'A', (2023, 4)),
        _course('POL 270', 3, 'A', (2023, 4)),
        _course('CSE 214', 4, 'A', (2023, 4)),

        _course('AMS 301', 3, 'A', (2024, 2)),
        _course('AMS 310', 3, 'A', (2024, 2)),
        _course('POL 323', 3, 'A', (2024, 2)),
        _course('POL 353', 3, 'A', (2024, 2)),
        _course('CSE 220', 4, 'A', (2024, 2)),
    }


def _cse_ams_two_planned_to_spring_2028():
    # Requested workload windows:
    # Spring 2026: 0
    # Fall 2026: 13
    # Spring 2027: 13
    # Fall 2027: 13
    # Spring 2028: 15
    # Replacement/avoid notes applied:
    # - include AMS 333 and CSE 353
    # - replace POL 102 with HIS 104 (SBS/USA example course)
    # - avoid AMS 351 and CSE 337
    return {
        # Fall 2026 (13)
        _course('CSE 216', 3, 'A', (2026, 4)),
        _course('CSE 215', 3, 'A', (2026, 4)),
        _course('CSE 303', 3, 'A', (2026, 4)),
        _course('CSE 300', 3, 'A', (2026, 4)),
        _course('PHY 131', 3, 'A', (2026, 4)),
        _course('PHY 133', 1, 'A', (2026, 4)),

        # Spring 2027 (13)
        _course('CSE 310', 3, 'A', (2027, 2)),
        _course('CSE 316', 3, 'A', (2027, 2)),
        _course('CSE 320', 3, 'A', (2027, 2)),
        _course('CSE 312', 3, 'A', (2027, 2)),
        _course('AST 203', 3, 'A', (2027, 2)),

        # Fall 2027 (13)
        _course('CSE 373', 3, 'A', (2027, 4)),
        _course('CSE 416', 3, 'A', (2027, 4)),
        _course('CSE 353', 3, 'A', (2027, 4)),  # replacement for unavailable CSE 354
        _course('AMS 333', 3, 'A', (2027, 4)),  # replacement for unavailable AMS 332
        _course('HIS 104', 3, 'A', (2027, 4)),  # replacement for POL 102 (SBS/USA example)

        # Spring 2028 (15)
        _course('CSE 360', 4, 'A', (2028, 2)),  # custom workload estimate from prompt
        _course('CSE 361', 4, 'A', (2028, 2)),  # custom workload estimate from prompt
        _course('CSE 352', 3, 'A', (2028, 2)),
        _course('CHE 131', 3, 'A', (2028, 2)),
        _course('CHE 133', 1, 'A', (2028, 2)),
        _course('AMS 311', 3, 'A', (2028, 2)),
    }


def test_s_cse_ams_two_current_snapshot():
    taken = _cse_ams_two_history()
    checked = {
        'degree': (False, []),
    }
    return taken, checked


def test_s_cse_ams_two_planned_spring_2028():
    taken = _cse_ams_two_history() | _cse_ams_two_planned_to_spring_2028()
    checked = {
        'intro': (True, []),
        'adv': (True, []),
        'elect': (True, []),
        'calc': (True, []),
        'alg': (True, []),
        'sta': (True, []),
        'sci': (True, []),
        'ethics': (True, []),
        'writing': (True, []),
        'credits_at_SB': (True, []),
        'degree': (True, []),
    }
    return taken, checked
