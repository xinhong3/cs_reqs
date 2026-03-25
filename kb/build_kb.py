from pprint import pprint
import requests
import re
import argparse
import pickle
from bs4 import BeautifulSoup, Tag
from course_kb import Course, And, Expr, LogicalExpr, Major, Or, Passed, Permission, Requirement, Standing, Taken, UnsupportedRequirement
from parse_course import course_div_cleanup, parse_course_div, parse_req_text

## all the courses in CSE that can't be handled by the current parsing logic.
## we add them manually as overrides.
OVERRIDES = {
  # CSE 364: Advanced Multimedia Techniques
  # Prerequisites: CSE/ISE 334
  # 3 credits
  "CSE 364": Course(
    id="CSE 364", title="Advanced Multimedia Techniques",
    desc="SKIPPED",
    prereq=Or([Taken("CSE 334"), Taken("ISE 334")]),
    coreq=None, anti_req=None, pre_or_coreq=None, advisory_prereq=None, advisory_coreq=None, advisory_pre_or_coreq=None,
    credits="3",
    category=None, ### ignore for now
    grading=None
  ),
  # CSE 488: Internship in Computer Science
  # Prerequisites: CSE major, U3 or U4 standing; permission of department
  # SBC:     EXP+
  # 3 credits, S/U grading
  "CSE 488": Course(
    id="CSE 488", title="Internship in Computer Science",
    desc="SKIPPED",
    prereq=And([Major("CSE"), Or([Standing("U3"), Standing("U4")]), Permission("permission of department")]),
    coreq=None, anti_req=None, pre_or_coreq=None, advisory_prereq=None, advisory_coreq=None, advisory_pre_or_coreq=None,
    credits="3",
    category=None, ### ignore for now
    grading="S/U"
  ),
}

REQ_TYPES = ['prereq', 'coreq', 'pre_or_coreq', 'anti_req', 'advisory_prereq', 'advisory_coreq', 'advisory_pre_or_coreq']

def create_course_namedtuple(raw_course_dict : dict) -> Course:
  ## from course dictionary (returned by parse_course_div) to course namedtuple
  ## input: dictionary with keys like 'id', 'desc', 'Prerequisite', ..

  ## helper function to check multiple possible string keys for requisites
  ## e.g., "Prerequisite" vs "Prerequisites"
  print("parsing course:", raw_course_dict.get('id'))
  def get_parsed_req(possible_keys):
    for key in possible_keys:
      if key in raw_course_dict:
        return parse_req_text(raw_course_dict[key])
    return None

  return Course(
    id=raw_course_dict.get('id'),
    title=raw_course_dict.get('title'),
    desc=raw_course_dict.get('desc'),
    prereq=get_parsed_req(['Prerequisite', 'Prerequisites']),
    coreq=get_parsed_req(['Corequisite', 'Corequisites']),
    pre_or_coreq=get_parsed_req(['Pre- or Co-requisite', 'Pre- or Co-requisites']),
    anti_req=get_parsed_req(['Anti-requisite', 'Anti-requisites']),
    advisory_prereq=get_parsed_req(['Advisory Prerequisite', 'Advisory Prerequisites']),
    advisory_coreq=get_parsed_req(['Advisory Corequisite', 'Advisory Corequisites']),
    advisory_pre_or_coreq=get_parsed_req(['Advisory pre-or corequisite', 'Advisory pre-or corequisites', 'Advisory Pre-or corequisite']),
    category=raw_course_dict.get('category'),
    credits=raw_course_dict.get('credits'),
    grading=raw_course_dict.get('grading')
  )

def build_course_kb_from_html(html_input: str) -> list[Course]:
  ## input: raw html string
  ## output: a list of course namedtuples
  soup = BeautifulSoup(html_input, "html.parser")
  course_divs = soup.find_all("div", class_="course")   ## find all course divs in html
  
  kb = []
  
  for div in course_divs:
    clean_div = course_div_cleanup(div)                 ## div clean up
    raw_dict = parse_course_div(clean_div)              ## parse the cleaned div into a dictionary of course fields
    course = create_course_namedtuple(raw_dict)     ## convert dict to namedtuple
    if course.id in OVERRIDES:                      ## apply overrides if exists
      print(f"Applying override for course {course.id}")
      course = OVERRIDES[course.id]
    kb.append(course)

  return kb

def get_kb_from_program(prog: str):
  base_url = 'https://www.stonybrook.edu/sb/bulletin/current-fall24/academicprograms/{prog}/courses.php'
  url = base_url.format(prog=prog)
  resp = requests.get(url)
  if resp.status_code == 200:
    html_input = resp.text
    kb = build_course_kb_from_html(html_input)
    return kb
  else:
    print("Failed to retrieve course data. Status code:", resp.status_code)
    return []

def serialize_kb_to_pickle(kb: list[Course], filepath):
  with open(filepath, 'wb') as f:
    pickle.dump(kb, f)
    print(f'Pickled KB saved to {filepath}')

def deserialize_kb_from_pickle(filepath) -> list[Course]:
  with open(filepath, 'rb') as f:
    kb = pickle.load(f)
    print(f'KB loaded from {filepath}')
  return kb

class PrologGenerator:
  ## generates rules from the AST in prolog and clingo format.
  def __init__(self, kb: list[Course]):
    self.kb = kb

  def semester_suffix(self, req_type: str) -> str:
    return "same" if req_type == "coreq" else "before"

  def join_args(self, args: list[str]) -> str:
    return ",".join(f'"{a}"' for a in args)

  def format_req_with_semester(self, name: str, args: list[str], req_type: str) -> str:
    suffix = self.semester_suffix(req_type)
    if len(args) == 1:
      return f'{name}_{suffix}("{args[0]}", Sem)'
    return f'{name}_{suffix}(({self.join_args(args)}), Sem)'

  def generate_kb(self) -> list[str]:
    output_lines = []    ## l is a list of strings representing the kb
    output_lines.extend([
      r"%%%%% for unsupported requirements, we put 'unsupported' and assume they are satisfied.",
      r"unsupported_prereq.     %%% assume unsupported prereqs are satisfied",
      r"unsupported_coreq.      %%% assume unsupported coreqs are satisfied",
    ])

    for course in self.kb:
      output_lines.extend(self.generate_course(course))
    return output_lines

  def generate_course(self, course) -> list[str]:
    l = []    ## l is a list of strings representing the kb

    ## generate course facts (course/2)
    pat_credits = r'(?P<min_credit>\d+)(?P<max_credit>-(\d+))?'
    m = re.match(pat_credits, course.credits)
    if m:
      min_credit = int(m.group('min_credit'))
      max_credit = int(m.group('max_credit')) if m.group('max_credit') else min_credit
    
    for credit in range(min_credit, max_credit + 1):
      l.append(f'course("{course.id}", {credit}).')

    for req_type in REQ_TYPES:
      req_value = getattr(course, req_type)
      if req_value is not None:
        l.append(f'has_{req_type}("{course.id}").')       ## add has_requisite fact for each course with that type of requisite
        l.append(f'{req_type}("{course.id}", Sem) :- semester(Sem),{self.generate_expr(req_value, req_type)}.')    ## add Sem in the head
    return l

  def generate_expr(self, expr: Expr, req_type: str) -> str:
    if isinstance(expr, Requirement): return self.generate_requirement(expr, req_type)
    elif isinstance(expr, And): return self.generate_and(expr, req_type)
    elif isinstance(expr, Or): return self.generate_or(expr, req_type)
    else:
      print("unsupported expr type:", type(expr))
      return "unsupported: " + str(expr)

  ## same requirement output for both prolog and clingo
  def generate_requirement(self, req: Requirement, req_type) -> str:
    ## for passed and taken, add semester
    if isinstance(req, (Passed, Taken)):
      return self.format_req_with_semester(req.name, req.arguments, req_type)
    elif isinstance(req, UnsupportedRequirement):
      ## ignore unsupported. we assert unsupported as a fact in clingo.
      ## for prereq and coreq, we assume unsupported requirements are satisfied. 
      ## for anti-req, unsupported requirements are assumed to be not satisfied.
      return f'unsupported_{req_type}'
    elif isinstance(req, Permission):
      return f'permission'
    
    arg_str = self.join_args(req.arguments)
    return f'{req.name}({arg_str})'

  def generate_and(self, expr: And, req_type) -> str:
    if len(expr.subexprs) == 1:
      return self.generate_expr(expr.subexprs[0], req_type)
    parts = []
    for op in expr.subexprs:
      s = self.generate_expr(op, req_type)
      if isinstance(op, LogicalExpr) and len(op.subexprs) > 1: ## add parentheses around Or
        s = f'({s})'
      parts.append(s)
    return ','.join(parts)

  def generate_or(self, expr: Or, req_type) -> str:
    parts = []
    for op in expr.subexprs:
      s = self.generate_expr(op, req_type)
      if isinstance(op, And) and len(op.subexprs) > 1:
        s = f'({s})'
      parts.append(s)
    return ';'.join(parts)

class ClingoGenerator(PrologGenerator):
  ## same as PrologGenerator, only overridding conjunction and disjunction for pooling
  def generate_and(self, expr: And, req_type) -> str:
    if len(expr.subexprs) == 1:
      return self.generate_expr(expr.subexprs[0], req_type)
    parts = []
    for op in expr.subexprs:                ## don't add parentheses for subexprs in And
      s = self.generate_expr(op, req_type)
      parts.append(s)
    return ','.join(parts)

  def pool_requirement_arguments(self, reqs: list[Requirement]) -> str:
    return "; ".join(self.join_args(op.arguments) for op in reqs if op)

  def format_pooled_sem_requirement(self, name: str, pooled: str, req_type: str) -> str:
    suffix = self.semester_suffix(req_type)
    return f'{name}_{suffix}(({pooled}), Sem)' if pooled.count(";") >= 1 else f'{name}_{suffix}({pooled}, Sem)'

  def generate_or(self, expr: Or, req_type) -> str:
    ## if all are with the same requirement type -> pool arguments
    if all(isinstance(op, Requirement) for op in expr.subexprs) and len(set(type(op) for op in expr.subexprs)) == 1:
      pooled = self.pool_requirement_arguments(expr.subexprs)
      node_type, node_name = type(expr.subexprs[0]), expr.subexprs[0].name

      if node_type is Taken:   ## taken takes semester argument
        return self.format_pooled_sem_requirement(node_name, pooled, req_type)

      if node_type is Passed:  ## passed takes semester argument
        if req_type == "coreq": print("coreq shouldn't have passed requirements, but found:", expr)
        return self.format_pooled_sem_requirement(node_name, pooled, req_type)

      return f'{node_name}({pooled})'
    
    raise ValueError(f'clingo: mixed disjunction, cannot pool: {expr}')
    ## TODO: fallback: not all same type, expand into separate rules
    # print("clingo: mixed disjunction, cannot pool:", expr)
    # return '; '.join(self.generate_expr(op, req_type) for op in expr.subexprs) ### not correct as is


def main():
  parser = argparse.ArgumentParser(
    description='Generate course KB for specified programs in Stony Brook. \n'
                'The generated KB can be serialized into a pickle file or exported in prolog/clingo format.\n'
                'To generate KB for specific programs, use -p or --prog followed by program codes (e.g., -p cse phy). To generate for all programs (relevant to the CSE degree program), use -a or --all.\n'
                'For output, use either -s/--show to print the KB to console, or -f/--file to save it to a file. If language is specified with -l/--language, the KB will be exported in that format; otherwise, it will be saved as a pickle file.\n')

  group_input = parser.add_mutually_exclusive_group(required=True)  ## input: generate KB or load from file
  group_input.add_argument('-p', '--prog', nargs='+', help="Generate KB for one or more specific programs (e.g., -p cse phy).")
  group_input.add_argument('-a', '--all', action='store_true', help="Generate KB for all programs relevant in evaluating CSE degree requirement.")
  group_input.add_argument('-i', '--input', metavar='FILEPATH', help="Load KB from a previously saved pickle file.")
  
  group_output = parser.add_mutually_exclusive_group()  ## output: either print or save to file
  group_output.add_argument('-f', '--file', metavar='FILEPATH', help="Save KB to path. If language is specified then the KB will be export to the specific language. Otherwise, it will be saved to a pickle file.")
  group_output.add_argument('-s', '--show', action='store_true', help="Print the KB in the console.")

  parser.add_argument('-l', '--language', choices=['prolog', 'clingo'], help="Export format: prolog or clingo (default: prolog)")

  args = parser.parse_args()
  
  ## generate KB
  if args.input:    ## load KB from pickle
    print(f"Loading KB from {args.input}...")
    kb = deserialize_kb_from_pickle(args.input)
  else:             ## generate KB from programs
    programs_to_generate = args.prog if args.prog else ['cse', 'ams', 'mat', 'bio', 'che', 'phy', 'geo', 'ast', 'wrt']
    kb = [course for prog in programs_to_generate for course in get_kb_from_program(prog)]

  ## output KB
  if args.language: ## to prolog or clingo
    generator = PrologGenerator(kb) if args.language == 'prolog' else ClingoGenerator(kb)
    output_text = "\n".join(generator.generate_kb())
    if args.show: print(output_text)
    else:
      ext = "pl" if args.language == "prolog" else "lp"
      filepath = args.file if args.file else f'./course_kb_{args.language}.{ext}'
      with open(filepath, 'w') as f:
        f.write(output_text)
      print(f'{args.language} KB saved to {filepath}.')
  else:             ## to pickle
    if args.show: pprint(kb)
    else:
      filepath = args.file if args.file else './course_kb.pkl'
      serialize_kb_to_pickle(kb, filepath)

if __name__ == "__main__":
  main()