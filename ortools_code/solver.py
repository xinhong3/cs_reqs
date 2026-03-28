from ortools.sat.python import cp_model
from course_kb.course_kb import Requirement, LogicalExpr, Or

# stores, indexes and adds variables to the CP-SAT model
class Solver:
    def __init__(self, ignore=()):
        self.model   = cp_model.CpModel()
        self._solver = None         # created on solve()
        self._vars   = {}           # Requirements converted to BoolVars
        self._encoders = {}         # pred_class → encode_dict (cached from class domain)
        self.ignore  = tuple(ignore)

    # lazily build and cache the encode dict from a Requirement class's domain
    def _encoder(self, cls):
        if cls not in self._encoders and isinstance(cls.domain, list):
            self._encoders[cls] = {v: i for i, v in enumerate(cls.domain)}
        return self._encoders.get(cls)

    def encode(self, pred_class, value):
        return self._encoder(pred_class)[value]

    # allows Python's default indexing -> solver[key]
    # domain=None → BoolVar; domain=list → categorical (len 1: pin, len 2: BoolVar, len 3+: IntVar)
    def __getitem__(self, pred):
        if pred not in self._vars:
            domain = getattr(pred, 'domain', None)
            if isinstance(domain, list):
                n = len(domain) - 1   # max index
                if n <= 1:
                    self._vars[pred] = self.model.new_bool_var(str(pred))
                    if n == 0: self.model.add(self._vars[pred] == 0)
                else:
                    self._vars[pred] = self.model.new_int_var(0, n, str(pred))
            else:
                lo, hi = domain or (0, 1)
                if (lo, hi) == (0, 1):
                    self._vars[pred] = self.model.new_bool_var(str(pred))
                else:
                    self._vars[pred] = self.model.new_int_var(lo, hi, str(pred))
        return self._vars[pred]

    # allows the in operator to work naturally
    def __contains__(self, pred):
        return pred in self._vars

    # hardcode a variable value; auto-encodes if pred's class has a registered domain
    def pin(self, pred, value):
        iv, value = self._resolve(pred, value)
        self.model.add(iv == value)

    # bidirectional linkage: iv > 0 ↔ bv true, iv == 0 ↔ bv false
    def link(self, pred, to):
        iv, bv = self[pred], self[to]
        self.model.add(iv > 0).only_enforce_if(bv)
        self.model.add(iv == 0).only_enforce_if(bv.negated())

    # return the value of a predicate as a BoolVar
    def val(self, pred):
        return self[pred]

    # allows solver[pred] = expr to store a constraint result
    def __setitem__(self, pred, expr):
        self._vars[pred] = self.constraint(expr) if isinstance(expr, (LogicalExpr, Requirement)) else expr

    def implies(self, a, b):
        a = self[a] if isinstance(a, Requirement) else a
        b = self[b] if isinstance(b, Requirement) else b
        self.model.add_implication(a, b)

    # auto-resolves Requirements and encodes domain values for n
    # 0 passes through unchanged (reserved as "unassigned" sentinel)
    def _resolve(self, expr, n):
        if isinstance(expr, Requirement):
            cls = type(expr)
            expr = self[expr]
            enc = self._encoder(cls)
            if n and enc: n = enc[n]
        return expr, n

    def exactly(self, expr, n):
        expr, n = self._resolve(expr, n)
        v = self.model.new_bool_var(f"eq_{n}_{id(expr)}")
        self.model.add(expr == n).only_enforce_if(v)
        self.model.add(expr != n).only_enforce_if(v.negated())
        return v

    def at_least(self, expr, n):
        expr, n = self._resolve(expr, n)
        v = self.model.new_bool_var(f"geq_{n}_{id(expr)}")
        self.model.add(expr >= n).only_enforce_if(v)
        self.model.add(expr <  n).only_enforce_if(v.negated())
        return v

    def at_most(self, expr, n):
        expr, n = self._resolve(expr, n)
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

        # create model variable to store the Or/And relation if there are multiple operands
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

    # helper to read solution variable values; auto-decodes categorical domains
    def value(self, v):
        assert self._solver, "call solve() first"
        raw = self._solver.value(self[v] if isinstance(v, Requirement) else v)
        domain = getattr(v, 'domain', None)
        if isinstance(domain, list):
            return domain[raw]
        return raw
