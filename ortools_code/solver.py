from ortools.sat.python import cp_model
from course_kb.course_kb import Requirement, LogicalExpr, Or

# stores, indexes and adds variables to the CP-SAT model
class Solver:
    def __init__(self, ignore=()):
        self.model   = cp_model.CpModel()
        self._solver = None         # created on solve()
        self._vars   = {}           # Requirements converted to BoolVars
        self.ignore  = tuple(ignore)

    # allows Python's default indexing -> solver[key]
    def __getitem__(self, pred):
        if pred not in self._vars:
            self._vars[pred] = self.model.new_bool_var(str(pred))
        return self._vars[pred]

    # allows the in operator to work naturally
    def __contains__(self, pred):
        return pred in self._vars

    # hardcode a variable value
    def pin(self, pred, value):
        self.model.add(self[pred] == value)

    # return the value of a predicate as a BoolVar
    def val(self, pred):
        return self[pred]

    # store a model variable for a specific predicate making it easier to access later
    def define(self, pred, expr):
        self._vars[pred] = self.constraint(expr)

    def at_least(self, expr, n):
        v = self.model.new_bool_var(f"geq_{n}_{id(expr)}")
        self.model.add(expr >= n).only_enforce_if(v)
        self.model.add(expr <  n).only_enforce_if(v.negated())
        return v

    def at_most(self, expr, n):
        v = self.model.new_bool_var(f"leq_{n}_{id(expr)}")
        self.model.add(expr <= n).only_enforce_if(v)
        self.model.add(expr >  n).only_enforce_if(v.negated())
        return v

    # make a constraint mandatory
    def require(self, expr):
        c = self.constraint(expr)
        if c is not None: self.model.add(c == 1)

    # recursively walk an And-Or expression and set up constraints in the model
    def constraint(self, expr):
        if isinstance(expr, self.ignore):
            return None

        if isinstance(expr, Requirement):
            return self.val(expr)
        if not isinstance(expr, LogicalExpr):
            return expr  # raw BoolVar

        # recursively add constraints for operands
        ops = [self.constraint(op) for op in expr.operands]

        # check if operands are to be ignored
        ops = [o for o in ops if o is not None]
        if not ops: return 1        # all operands ignored makes it true
        if len(ops) == 1: return ops[0]

        # create internal variable to store the Or/And relation if there are multiple operands
        v = self.model.new_bool_var(f"{'or' if isinstance(expr, Or) else 'and'}_{id(expr)}")
        if isinstance(expr, Or): self.model.add_max_equality(v, ops)
        else:                    self.model.add_min_equality(v, ops)
        return v

    # find a solution for given constraints using the CP-SAT solver
    def solve(self):
        self._solver = cp_model.CpSolver()
        status = self._solver.solve(self.model)
        name   = self._solver.status_name(status)
        obj    = (int(self._solver.objective_value)
                  if status in (cp_model.OPTIMAL, cp_model.FEASIBLE) else None)
        return name, obj

    # helper to read solution variable values
    def value(self, v):
        assert self._solver, "call solve() first"
        return self._solver.value(self[v] if isinstance(v, Requirement) else v)
