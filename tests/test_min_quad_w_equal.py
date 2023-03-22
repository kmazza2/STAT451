import hw4.optim.optim as optim
import numpy as np
import unittest

class TestOptim(unittest.TestCase):
    def test_min_univar_quad_w_equal(self):
        P = np.array([[2.0]])
        q = np.array([[-8.0]])
        r = np.array([[16.0]])
        A = np.array([[3.0]])
        b = np.array([[5.0]])
        result = optim.min_quad_w_equal(P, q, r, A, b)[0,0]
        expected = 5.0 / 3.0
        self.assertEqual(expected, result)
