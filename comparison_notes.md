# Comparison Notes

## Ordered Categorical Variables (Semester Encoding)

### Implementations

**Clingo** — One-hot via grounding. `{ semester(C, 1..max_sem) } 1 :- taken(C).` creates a boolean atom per `(course, semester)` pair. Prereq ordering enumerates invalid pairs: `:- semester(Course, S1), semester(Prereq, S2), S1 <= S2.` — O(max_sem^2) ground clauses per prereq.

**OR-Tools** — Integer variable with linear constraints. `Semester(cid)` is a single IntVar with domain {0..max_sem}. Prereq ordering is one constraint: `sem[prereq] < sem[course]`. Bool-int linkage (`sem > 0 iff taken`) via `link()`.

### Key Differences

| | Clingo | OR-Tools |
|--|--------|----------|
| Variables per course | max_sem booleans | 1 IntVar |
| Prereq constraint size | O(max_sem^2) ground | 1 linear |
| Style | Declarative (state what's invalid) | Imperative (state what's required) |
| Scaling with domain | Grounding grows | Compact with lazy constraints |
