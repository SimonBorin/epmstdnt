import os
import unittest

import sys

PACKAGE_PARENT = '../..'
SCRIPT_DIR = os.path.dirname(os.path.realpath(os.path.join(os.getcwd(), os.path.expanduser(__file__))))
sys.path.append(os.path.normpath(os.path.join(SCRIPT_DIR, PACKAGE_PARENT)))

from python.module3.dict_swap import dict_swap


class TestDictSwap(unittest.TestCase):

    def test_dict_swap(self):
        self.assertEqual(dict_swap({'Name': 'John', 'Age': 44, 'JobTitle': "DevOps"}),
                         {'John': 'Name', 44: 'Age', 'DevOps': "JobTitle"})

    def test_dict_swap_mirrored(self):
        self.assertEqual(dict_swap({'John': 'Name', 44: 'Age', 'DevOps': "JobTitle"}),
                         {'Name': 'John', 'Age': 44, 'JobTitle': "DevOps"})

    def test_dict_swap_negative_type_1(self):
        with self.assertRaises(TypeError,
                               msg="dict_swap({'Name': 'John', 'Age': 44, 'JobTitle': {'title': 'devOPs'}})"):
            dict_swap({'Name': 'John', 'Age': 44, 'JobTitle': {'title': 'devOPs'}})

    def test_dict_swap_negative_type_2(self):
        with self.assertRaises(TypeError,
                               msg="dict_swap({'Name': 'John', 'Age': 44, 'JobTitle': ['Engineer', 'devOPs']})"):
            dict_swap({'Name': 'John', 'Age': 44, 'JobTitle': ['Engineer', 'devOPs']})

    def test_dict_swap_negative_type_3(self):
        with self.assertRaises(TypeError,
                               msg="dict_swap({'Name': 'John', 'Age': 44, 'JobTitle': {77.2, }})"):
            dict_swap({'Name': 'John', 'Age': 44, 'JobTitle': {77.2, }})


if __name__ == "__main__":
    unittest.main()
