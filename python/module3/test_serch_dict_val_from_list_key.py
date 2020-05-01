import os
import sys
import unittest

PACKAGE_PARENT = '../..'
SCRIPT_DIR = os.path.dirname(os.path.realpath(os.path.join(os.getcwd(), os.path.expanduser(__file__))))
sys.path.append(os.path.normpath(os.path.join(SCRIPT_DIR, PACKAGE_PARENT)))

from python.module3.serch_dict_val_from_list_key import serch_dict_val_from_list_key


class TestBetween(unittest.TestCase):
    haystack = {str(x): x * 2 for x in reversed(range(1000000))}

    def test_search(self):
        self.assertEqual(serch_dict_val_from_list_key(["1", "2", "1000", "testStr"], self.__class__.haystack), [2, 4, 2000])

    def test_search_key_err(self):
        with self.assertRaises(TypeError):
            serch_dict_val_from_list_key({"1", "2", "1000", {}}, self.__class__.haystack)


if __name__ == "__main__":
    unittest.main()
