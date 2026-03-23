from build_kb import ClingoGenerator, generate_kb_from_program
import argparse

def main():
  parser = argparse.ArgumentParser(description='Generate course KB for specified programs.')
  parser.add_argument('--dryrun', action='store_true', help='Run without generating KB files, just print the courses and their requirements.', default=True)
  args = parser.parse_args()
  if args.dryrun:
    ## print cse courses and their requirements
    prog = 'cse'
    kb = generate_kb_from_program(prog)
    for course in kb:
      clingo_rules = ClingoGenerator(course).generate()
      for rule in clingo_rules:
        print(rule)
    return

  ## list of programs we need for cse degree requirements:
  ## cse, ams, mat, bio, che, phy, geo, ast
  progs = ['cse', 'ams', 'mat', 'bio', 'che', 'phy', 'geo', 'ast', 'wrt']
  with open(f'kb_clingo/kb_complete.lp', 'w') as f:
    f.write(r'''%%%%% KB for programs: cse, ams, mat, bio, che, phy, geo, ast, wrt''' + "\n")
    f.write(r'''%%%%% for unsupported requirements, we put 'unsupported' and assume they are satisfied.''' + "\n")
    f.write(r'''unsupported_prereq.     %%% assume unsupported prereqs are satisfied''' + "\n")
    f.write(r'''unsupported_coreq.      %%% assume unsupported coreqs are satisfied''' + "\n")

  for prog in progs:
    kb = generate_kb_from_program(prog)
    
    with open(f'kb_clingo/kb_complete.lp', 'a') as f:
      for course in kb:
        clingo_facts = export_kb(course, format_expr_clingo)
        f.write("\n".join(clingo_facts) + "\n")

if __name__ == "__main__":
  main()