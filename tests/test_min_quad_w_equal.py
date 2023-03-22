import hw4.optim.optim as optim
import numpy as np
from scipy.linalg import norm
import unittest


class TestOptim(unittest.TestCase):
    def test_min_univar_quad_w_equal(self):
        P = np.array([[2.0]])
        q = np.array([[-8.0]])
        r = np.array([[16.0]])
        A = np.array([[3.0]])
        b = np.array([[5.0]])
        expected = 5.0 / 3.0
        result = optim.min_quad_w_equal(P, q, r, A, b)[0, 0]
        self.assertEqual(expected, result)

    def test_min_multivar_quad_w_equal(self):
        P = np.array([[2.0, 0.0], [0.0, 2.0]])
        q = np.array([[0.0], [0.0]])
        r = np.array([[0.0]])
        A = np.array([[-1.0, 1.0]])
        b = np.array([[1.0]])
        expected = np.array([[-0.5], [0.5]])
        result = optim.min_quad_w_equal(P, q, r, A, b)
        self.assertTrue(norm(expected - result) < 0.0001)
