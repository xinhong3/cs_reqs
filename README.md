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

## Generate KB
To run with KB, first generate the KB with build_kb.py.

After activating the virtual environment, run:
```
cd kb
python build_kb.py -h
```

Options:
  - input source (choose one):
    - `-p, --prog`: build KB for one or more programs (example: `-p cse ams`).
    - `-a, --all`: build KB for all configured programs.
    - `-i, --input FILEPATH`: load KB from an existing pickle file.
  - output mode (choose one):
    - `-s, --show`: print output to console.
    - `-f, --file FILEPATH`: save output to a file.
  - export language:
    - `-l, --language {prolog,clingo}`: export as prolog/clingo rules.
    - if `-l` is omitted, output is in pickle format.

Examples:
```bash
# Generate KB for CSE and print to console
python build_kb.py -p cse -s

# Same as above but save to file
python build_kb.py -p cse -f kb_cse.pkl

# Generate pickle KB for all programs and save to file
python build_kb.py -a -f kb_complete.pkl

# Generate clingo KB for all programs
python build_kb.py -a -l clingo -f kb_all_clingo.lp

# Load an existing pickle KB and print
python build_kb.py -i kb_complete.pkl -s
```


## To Run the clingo code
### Running the same test as in python

A test file test_clingo.py is provided and it can be run directly. It uses test cases from python (in tests.py) and compares the results. Note that only passed/not passed is checked, not the witness courses.

After activating the virtual environment, run:
```
python test_clingo.py
```

### Running with the KB

Once the KB is generated, run the python script for clingo to do planning/checking with the KB.
```
python run_clingo.py -h
```

For checking/planning:
```
python run_clingo.py -m [check | plan] -f <MAIN_CLINGO_FILE> -k <KB_FILE>
```

For example (checking):
```
python run_clingo.py -m check -f cse_req_clingo.lp -k kb_complete.lp
```

Planning might take a while depending on the taken_id set, especially when science courses are not included. To change the taken_id set, either modify `#program input` in the main clingo file or add test cases in test_clingo.py and run the tests.