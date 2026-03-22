# cs_reqs

Fork of https://github.com/unicomputing/cs_reqs/.
  - Added complete clingo code for checking and planning.

See [cse_req_clingo.lp](/cse_req_clingo.lp) for the clingo code.
  - comment styles are explained in the code at the top.
  - python script in the clingo code is commented at the bottom out since it conflicts with clingo python api (in test_clingo.py).
  - the file has the following parts: 
    1. rules for checking requirements.
    2. checking logic (#program check.). 
    3. rules for planning (#program plan.). 
    4. student facts for input (#program input.).

## Install dependencies

Versions: Python 3.13.3, Clingo 5.8.0

Create a virtual environment and install dependencies:
```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## To Run the clingo code
### Running the same test as in python

A test file test_clingo.py is provided and it can be run directly. It uses test cases from python (in tests.py) and compares the results. Note that only passed/not passed is checked, not the witness courses.

After activating the virtual environment, run:
```
python test_clingo.py
```