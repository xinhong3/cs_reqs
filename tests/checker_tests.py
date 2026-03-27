import inspect
from pprint import pprint
import tests.test_data as tests
import python_code.cs_reqs_2024 as checker
from python_code.cs_reqs_2024 import degree_reqs


def testing(test_func):
    taken, checked = test_func()
    print('---- taken_ids: ', sorted({c.id for c in taken}))
    print('---- checked: ')
    pprint(checked)
    checker.w = {}
    assert degree_reqs(taken) == checked


def run_tests():
    for name, func in inspect.getmembers(tests, inspect.isfunction):
        if name.startswith('test_'):
            checker.w = {}
            print('--------', name, 'started:')
            testing(func)
            print('--------', name, 'passed !!!')


if __name__ == '__main__':
    run_tests()
