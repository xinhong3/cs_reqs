from ortools.sat.python import cp_model

# predicates that don't need to be manipulated by the CP-SAT solver should inherit this class
class Attr:
    def __init__(self, *values): self.values = values
    def __eq__(self, other):     return type(self) is type(other) and self.values == other.values
    def __hash__(self):          return hash((type(self), self.values))
    def __repr__(self):          return f"{type(self).__name__}({', '.join(map(repr, self.values))})"

# predicates to be manipulated by the CP-SAT solver should inherit this class
class Plannable(Attr):
    pass

class Expr: pass

class LogicalOperator(Expr):
    def __init__(self, *operands):
        self.operands = set()
        for op in operands:
            if isinstance(op, Attr) and len(op.values) > 1:
                # flatten attributes with multiple values in them
                # e.g., And(Attr('A', 'B')) becomes And(Attr('A'), Attr('B')) making it easier to write
                self.operands.update(type(op)(v) for v in op.values)
            else:
                self.operands.add(op)
    def add_operand(self, operand): self.operands.add(operand)

class And(LogicalOperator):
    def __repr__(self): return f'And({", ".join(repr(o) for o in self.operands)})'

class Or(LogicalOperator):
    def __repr__(self): return f'Or({", ".join(repr(o) for o in self.operands)})'

# helper method to retreive all plannable attributes from an And-Or expression
def get_leaves(expr):
    if isinstance(expr, Plannable):       return set(expr.values)
    if isinstance(expr, Attr):            return set()
    if isinstance(expr, LogicalOperator):
        return set().union(*(get_leaves(op) for op in expr.operands))
    return set()

# stores, indexes and adds variables to the CP-SAT model
class Solver:
    def __init__(self, *attrs, ignore=()):
        self.model   = cp_model.CpModel()
        self._solver = None         # created on solve()
        self._vars   = {}           # Plannables converted to BoolVars
        self.attrs   = set(attrs)   # set of Attrs
        self.ignore  = tuple(ignore) # Attr types to skip in constraint creation

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

    # return the value of a predicate
    def val(self, pred):
        if isinstance(pred, Plannable):
            return self[pred]
        return int(pred in self.attrs)
    
    # store a model variable for a specific predicate making it easier to access later
    def define(self, pred, expr):
        self._vars[pred] = self.constraint(expr)
 
    # make a constraint mandatory
    def require(self, expr):
        c = self.constraint(expr)
        if c is not None: self.model.add(c == 1)

    # recursively walk an And-Or expression and set up constraints in the model
    def constraint(self, expr):

        if isinstance(expr, self.ignore):
            return None
        
        if not isinstance(expr, LogicalOperator):
            return self.val(expr)
        
        # recursively add constraints for operands
        ops = [self.constraint(op) for op in expr.operands]

        # check if operands are to be ignored
        ops = [o for o in ops if o is not None]
        if not ops: return 1        # all operands ignored makes it true
        if len(ops) == 1: return ops[0]

        # create internal variable to store the Or/And relation if there are multiple operands
        v   = self.model.new_bool_var(
            f"{'or' if isinstance(expr, Or) else 'and'}_{id(expr)}")
        if isinstance(expr, Or): self.model.add_max_equality(v, ops)
        else: self.model.add_min_equality(v, ops)
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
        return self._solver.value(self[v] if isinstance(v, Plannable) else v)