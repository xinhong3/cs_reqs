# need to load course kb from what Ethan created instead of hardcoding like this

from collections import namedtuple
from .solver import Attr, Plannable, And, Or

class Major(Attr): pass
class Standing(Attr): pass
class Unsupported(Attr): pass
class Permission(Attr): pass

class CourseAttr(Plannable): pass        # solver decides these
class Passed(CourseAttr): pass           # C or higher
class Taken(CourseAttr): pass            # any grade recorded

# ── Course record & catalog ────────────────────────────────────

Course = namedtuple('Course', ['id', 'credits', 'prereq'], defaults=[None])

catalog = {}   # course_id → Course

def course(id, credits, prereq=None):
    """Register a course in the catalog and return it."""
    c = Course(id, credits, prereq)
    catalog[id] = c
    return c

def upper_division(cid): return int(cid[4:]) >= 300


# ════════════════════════════════════════════════════════════════
#  CATALOG — one line per course, prereqs read like the bulletin
# ════════════════════════════════════════════════════════════════

# ── CSE 1xx: Introductory ──────────────────────────────────────

course('CSE 101', 4,
    prereq=Unsupported("Level 3+ on math placement exam"))

course('CSE 102', 3)    # advisory: CSE 101 or basic computer skills

course('CSE 110', 3,
    prereq=Unsupported("Level 3+ on math placement exam"))

course('CSE 113', 4,
    prereq=Unsupported("AMS 151 or MAT 125 or MAT 131 or level 6 on math placement exam"))

course('CSE 114', 4,
    prereq=Unsupported("Level 5+ on math placement exam"))
    # advisory: Or(Taken('CSE 101'), Taken('ISE 108'))

course('CSE 130', 3,
    prereq=Unsupported("Level 3+ on math placement exam"))

course('CSE 150', 4,
    prereq=And(
        Unsupported("one MAT course that satisfies D.E.C. C or QPS or level 4 on math placement exam"),
        Unsupported("admission to Honors/WISE/Scholars")))

course('CSE 160', 3,
    prereq=Unsupported("Honors/WISE/Scholars admission"))
    # coreq: CSE 161

course('CSE 161', 1)    # coreq: CSE 160

course('CSE 190', 3)
course('CSE 191', 3)
course('CSE 192', 3)

# ── CSE 2xx ────────────────────────────────────────────────────

course('CSE 214', 4,
    prereq=Passed('CSE 114'))

course('CSE 215', 4,
    prereq=Or(Taken('AMS 151'), Taken('MAT 125'), Taken('MAT 131')))

course('CSE 216', 4,
    prereq=And(Passed('CSE 214'), Major('CSE')))

course('CSE 220', 4,
    prereq=Unsupported("C or higher in CSE 214 or coreq CSE 260, and CSE major"))

course('CSE 230', 3,
    prereq=Or(Taken('CSE 130'), Taken('CSE 220'), Taken('ESE 124'),
              Taken('ESG 111'), Taken('BME 120'), Taken('MEC 102')))

course('CSE 260', 3,
    prereq=Taken('CSE 160'))
    # coreq: CSE 261

course('CSE 261', 1)    # coreq: CSE 260

# ── CSE 3xx: Upper division ────────────────────────────────────

course('CSE 300', 3,
    prereq=And(Taken('WRT 102'),
               Or(Major('CSE'), Major('ISE'), Major('DAS')),
               Or(Standing('U3'), Standing('U4'))))

course('CSE 301', 3,
    prereq=Or(Standing('U2'), Standing('U3'), Standing('U4')))

course('CSE 303', 3,
    prereq=And(Or(Passed('CSE 160'), Passed('CSE 214')),
               Or(Passed('CSE 150'), Passed('CSE 215')),
               Major('CSE')))

course('CSE 304', 3,
    prereq=And(Or(Passed('CSE 216'), Passed('CSE 260')),
               Passed('CSE 220')))
    # advisory: Or(Taken('CSE 303'), Taken('CSE 350'))

course('CSE 305', 3,
    prereq=And(Passed('CSE 214'),
               Or(Passed('CSE 216'), Passed('CSE 260')),
               Or(Major('CSE'), Major('DAS'))))

course('CSE 306', 3,
    prereq=And(Or(Passed('CSE 320'), Passed('ESE 280')),
               Or(Major('CSE'), Major('ECE'))))

course('CSE 307', 3,
    prereq=And(Passed('CSE 214'),
               Or(Passed('CSE 216'), Passed('CSE 260')),
               Or(Major('CSE'), Major('DAS'))))

course('CSE 310', 3,
    prereq=And(Or(Passed('CSE 214'), Passed('CSE 260')),
               Or(Passed('CSE 220'), Passed('ISE 218')),
               Or(Major('CSE'), Major('ISE'))))

course('CSE 311', 3,
    prereq=And(Or(Taken('CSE 214'), Taken('CSE 230'),
                  Taken('CSE 260'), Taken('ISE 208')),
               Or(Major('ISE'), Major('CSE'))))

course('CSE 312', 3,
    prereq=And(Or(Major('CSE'), Major('ISE'), Major('DAS')),
               Or(Standing('U3'), Standing('U4')),
               Unsupported("one D.E.C. E or SNW course")))

course('CSE 316', 3,
    prereq=And(Or(Passed('CSE 214'), Passed('CSE 260')),
               Or(Passed('CSE 216'), Passed('CSE 307')),
               Major('CSE')))

course('CSE 320', 3,
    prereq=Unsupported("C or higher in CSE 220 and CSE major"))

course('CSE 323', 3,
    prereq=Or(Taken('CSE 214'), Taken('CSE 230'),
              Taken('CSE 260'), Taken('ISE 208')))

course('CSE 325', 3,
    prereq=Or(Taken('CSE 110'), Taken('CSE 101'), Taken('CSE 114')))

course('CSE 327', 3,
    prereq=And(Or(Taken('CSE 214'), Taken('CSE 230'), Taken('CSE 260')),
               Or(Taken('AMS 210'), Taken('MAT 211')),
               Or(Major('CSE'), Major('ISE'), Major('DAS'))))

course('CSE 328', 3,
    prereq=And(Passed('CSE 220'),
               Or(Major('CSE'), Major('DAS'))))

course('CSE 331', 3,
    prereq=And(Taken('CSE 220'), Major('CSE')))
    # advisory pre/coreq: CSE 320

course('CSE 332', 3,
    prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')),
               Or(Taken('MAT 211'), Taken('AMS 210')),
               Or(Taken('AMS 110'), Taken('AMS 310')),
               Or(Major('CSE'), Major('ISE'), Major('DAS'))))

course('CSE 333', 3,
    prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')),
               Or(Major('CSE'), Major('ISE'))))

course('CSE 334', 3,
    prereq=And(Or(Standing('U2'), Standing('U3'), Standing('U4')),
               Or(Major('CSE'), Major('ISE'))))

course('CSE 336', 3,
    prereq=And(Or(Passed('CSE 214'), Passed('CSE 260')),
               Major('CSE')))

course('CSE 337', 3,
    prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')),
               Or(Major('CSE'), Major('ISE'), Major('DAS')),
               Or(Standing('U3'), Standing('U4'))))

course('CSE 350', 4,
    prereq=And(Or(Taken('CSE 113'), Taken('CSE 150'), Taken('CSE 215')),
               Or(Taken('AMS 210'), Taken('MAT 211')),
               Unsupported("Honors/WISE/Scholars admission")))

course('CSE 351', 3,
    prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')),
               Taken('AMS 310'),
               Or(Major('CSE'), Major('DAS'))))

course('CSE 352', 3,
    prereq=And(Or(Taken('CSE 316'), Taken('CSE 351')),
               Or(Major('CSE'), Major('DAS'))))

course('CSE 353', 3,
    prereq=And(Or(Taken('CSE 316'), Taken('CSE 351')),
               Or(Major('CSE'), Major('DAS'))))
    # pre/coreq: Or(Taken('AMS 310'), Taken('AMS 311'), Taken('AMS 412'))

course('CSE 354', 3,
    prereq=And(Or(Taken('CSE 316'), Taken('CSE 351')),
               Or(Major('CSE'), Major('DAS'))))

course('CSE 355', 3,
    prereq=And(Taken('AMS 301'),
               Unsupported("programming knowledge of C/C++/Java")))

course('CSE 356', 3,
    prereq=And(Passed('CSE 316'), Passed('CSE 320'), Major('CSE')))

course('CSE 357', 3,
    prereq=And(Or(Passed('CSE 316'), Passed('CSE 351')),
               Passed('AMS 310'),
               Or(Major('CSE'), Major('DAS'))))

course('CSE 360', 3,
    prereq=And(Taken('CSE 220'), Major('CSE')))
    # advisory pre/coreq: CSE 320

course('CSE 361', 3,
    prereq=And(Taken('CSE 220'), Major('CSE')))

course('CSE 362', 3,
    prereq=And(Taken('CSE 220'), Major('CSE')))

course('CSE 363', 3,
    prereq=And(Taken('CSE 220'), Major('CSE')))

course('CSE 364', 3,
    prereq=Unsupported("CSE/ISE 334"))

course('CSE 366', 3,
    prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')),
               Or(Taken('MAT 211'), Taken('AMS 210')),
               Or(Major('CSE'), Major('ISE'))))

course('CSE 370', 3,
    prereq=And(Taken('CSE 310'), Major('CSE')))

course('CSE 371', 3,
    prereq=Or(Taken('CSE 113'), Taken('CSE 150'), Taken('CSE 215'),
              Taken('MAT 200'), Taken('MAT 250')))

course('CSE 373', 3,
    prereq=And(Or(Passed('CSE 113'), Passed('CSE 150'), Passed('CSE 215'),
                  Passed('MAT 200'), Passed('MAT 250')),
               Or(Passed('MAT 211'), Passed('AMS 210')),
               Or(Passed('CSE 214'), Passed('CSE 260')),
               Or(Major('CSE'), Major('MAT'), Major('DAS'))))

course('CSE 376', 3,
    prereq=And(Passed('CSE 320'), Major('CSE')))

course('CSE 377', 3,
    prereq=And(Or(Taken('AMS 161'), Taken('MAT 127'), Taken('MAT 132')),
               Or(Taken('AMS 210'), Taken('MAT 211'))))

course('CSE 378', 3,
    prereq=And(Or(Taken('AMS 161'), Taken('MAT 127'), Taken('MAT 132')),
               Or(Taken('AMS 210'), Taken('MAT 211'), Taken('MEC 262'))))

course('CSE 380', 3,
    prereq=And(Taken('CSE 220'), Major('CSE')))

course('CSE 381', 3,
    prereq=And(Taken('CSE 220'), Major('CSE')))

course('CSE 385', 4,
    prereq=And(Or(Taken('CSE 113'), Taken('CSE 150'), Taken('CSE 215'),
                  Taken('MAT 200'), Taken('MAT 250')),
               Or(Taken('AMS 210'), Taken('MAT 211')),
               Or(Taken('CSE 214'), Taken('CSE 260')),
               Unsupported("Honors/WISE/Scholars admission")))

course('CSE 390', 3, prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')), Or(Major('CSE'), Major('ISE'))))
course('CSE 391', 3, prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')), Or(Major('CSE'), Major('ISE'))))
course('CSE 392', 3, prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')), Or(Major('CSE'), Major('ISE'))))
course('CSE 393', 3, prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')), Or(Major('CSE'), Major('ISE'))))
course('CSE 394', 3, prereq=And(Or(Taken('CSE 214'), Taken('CSE 260')), Or(Major('CSE'), Major('ISE'))))

# ── CSE 4xx ────────────────────────────────────────────────────

course('CSE 416', 3,
    prereq=And(Passed('CSE 316'), Standing('U4'), Major('CSE')))

course('CSE 475', 3,
    prereq=And(Unsupported("U3/U4 CEAS major, GPA ≥ 3.00, grade B+ in assisted course"),
               Permission("permission of department")))

course('CSE 487', 3,    # 0-3 variable credits; using 3 as upper bound
    prereq=Permission("permission of instructor and department"))

course('CSE 488', 3,
    prereq=And(Unsupported("CSE major, U3 or U4 standing"),
               Permission("permission of department")))

course('CSE 495', 3,
    prereq=And(Unsupported("Admission to Honors in CS"),
               Permission("permission of instructor and department")))

course('CSE 496', 3,
    prereq=And(Taken('CSE 495'),
               Permission("permission of instructor and department")))

# ── Non-CSE courses used in degree requirements ────────────────

course('AMS 151', 3)
course('AMS 161', 3)
course('AMS 210', 3)
course('AMS 301', 3)
course('AMS 310', 3)
course('AMS 311', 3)

course('MAT 125', 3)
course('MAT 126', 3)
course('MAT 127', 3)
course('MAT 131', 3)
course('MAT 132', 3)
course('MAT 211', 3)

course('BIO 201', 3)
course('BIO 202', 3)
course('BIO 203', 3)
course('BIO 204', 1)    # lab

course('CHE 131', 3)
course('CHE 132', 3)
course('CHE 133', 1)    # lab
course('CHE 152', 3)
course('CHE 154', 1)    # lab
course('CHE 321', 3)
course('CHE 322', 3)
course('CHE 331', 3)
course('CHE 332', 3)

course('PHY 125', 3)
course('PHY 126', 3)
course('PHY 127', 3)
course('PHY 131', 3)
course('PHY 132', 3)
course('PHY 133', 1)    # lab
course('PHY 134', 1)    # lab
course('PHY 141', 3)
course('PHY 142', 3)
course('PHY 251', 3)
course('PHY 252', 3)

course('AST 203', 3)
course('AST 205', 3)

course('GEO 102', 3)
course('GEO 103', 3)
course('GEO 112', 3)
course('GEO 122', 3)
course('GEO 123', 3)

# referenced in prereqs but not degree requirements
course('ESE 440', 3)
course('ESE 441', 3)

# ── External courses referenced in prereqs (stubs) ────────────

course('WRT 102', 3)
course('ISE 108', 3)
course('ISE 208', 3)
course('ISE 218', 3)
course('ESE 124', 3)
course('ESE 280', 3)
course('ESG 111', 3)
course('BME 120', 3)
course('MEC 102', 3)
course('MEC 262', 3)
course('AMS 110', 3)
course('MAT 200', 3)
course('MAT 250', 3)