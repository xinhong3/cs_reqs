from collections import namedtuple

## Representation for course
## Each course: id, desc, prereqs, antireqs, coreqs, SBC, credits, ...
##   Fields are written in the order they appear in the input. Optional fields are None by default.
##   For requisites, we keep the original string as is. All requisites are optional.
Course = namedtuple('Course', 
                    ['id',                  ## string: e.g. 'CSE 101'
                     'title',               ## string: e.g. 'Intro to Computer Science'
                    'desc',                 ## string: course description
                    'prereq',               ## optional, And/Or structure (see below)
                    'coreq',
                    'anti_req',
                    'pre_or_coreq',
                    'advisory_prereq',
                    'advisory_coreq',       ## same as prereq
                    'advisory_pre_or_coreq',
                    'category',             ## optional: set of tuples where the first element is the category name e.g. SBC,
                                            ##   second element is a list of category values, e.g. ('TECH', ...)
                    'credits',              ## string: (e.g. '3', '4', '0-3')
                    'grading',              ## optional, string: special grading, such as S/U
                    ])

class Expr:
  def __eq__(self, other):
    return type(self) == type(other) and self.__dict__ == other.__dict__

## Represent each requirement in requisites.
class Requirement(Expr):
  name: str = ""     ## "taken", "passed", ...

  def __init__(self, *arguments):
    self.arguments = list(arguments)

  def __repr__(self):
    arg_str = ",".join(repr(arg) for arg in self.arguments)
    return f'{self.name}({arg_str})'

class Taken(Requirement):     ## e.g. taken_id("CSE 303"), taken_id("CSE 350")
                                ###    named taken_id to avoid clash with taken/5 in prolog and clingo.
  name = "taken"                ###    TODO: better name?

class Passed(Requirement):    ## e.g. passed("CSE 101"), passed("AMS 210", "B")
  ## by default, we assume passing means C or higher because that's the only case in cse courses.
  ## other programs may have 'passed with B or higher'.
  name = "passed"

class Major(Requirement):     ## e.g. cse_major
  name = "major"

class Standing(Requirement):   ## e.g. u3_standing
  name = "standing"

class Permission(Requirement):
  name = "permission"

class UnsupportedRequirement(Requirement):    ## to wrap all unsupported formats
  name = "unsupported"
  
  def __init__(self, text):
    super().__init__(text)
  
  def __repr__(self):
    return f'unsupported("{self.arguments[0]}")'

class LogicalExpr(Expr):
  def __init__(self, op_str, subexprs: list[Expr]):
    self.op_str = op_str
    self.subexprs = subexprs

  def __repr__(self):
    # return f'{self.op_str}({self.subexprs.__repr__()})'
    return f'{self.op_str}({", ".join(repr(e) for e in self.subexprs)})'
  
  # def __eq__(self, other): pass ### todo: order shouldn't matter in And and Or

## Represent a list of conjuncts in requisites.
class And(LogicalExpr):
  def __init__(self, subexprs):
    super().__init__('And', subexprs)

## Represent a list of disjuncts in requisites.
class Or(LogicalExpr):  
  def __init__(self, subexprs):
    super().__init__('Or', subexprs)

if __name__ == "__main__":
  ## course with only prereq
  cse316 = Course(
    id='CSE 316', 
    desc='Introduction to systematic design, development and testing of software systems, including event-driven programming, information management, databases, principles and practices for secure computing, and version control. Students apply these skills in the construction of large, robust programs.', 
    prereq=And([Or([Passed("CSE 214"), Passed("CSE 260")]), Or([Passed("CSE 216"), Passed("CSE 307")]), Major("CSE")]),
    coreq=None,
    anti_req=None,
    advisory_prereq=None,
    advisory_coreq=None,
    category=None,
    credits='3',
    grading=None
  )

  ## course with prereq and advisory prereq
  cse304 = Course(
    id='CSE 304',
    desc='Topics studied include formal description of programming languages, lexical analysis, syntax analysis, symbol tables and memory allocation, code generation, and interpreters. Students undertake a semester project that includes the design and implementation of a compiler for a language chosen by the instructor.',
    prereq=And([Or([Passed("CSE 216"), Passed("CSE 260")]), Passed("CSE 220")]),
    coreq=None,
    anti_req=None,
    advisory_prereq=Or([Taken("CSE 303"), Taken("CSE 350")]),
    advisory_coreq=None,
    category=None,
    credits='3',
    grading=None
  )