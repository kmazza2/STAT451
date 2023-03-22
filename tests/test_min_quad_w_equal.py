import hw4.optim.optim as optim
import numpy as np
from scipy.linalg import norm
import unittest


def f(x):
    return x[0, 0] ** 2 + x[1, 0] ** 2 + x[2, 0] ** 2


def grad(x):
    return np.array([[2.0 * x[0, 0], 2.0 * x[1, 0], 2.0 * x[2, 0]]]).T


def hess(x):
    return np.array([[2.0, 0.0, 0.0], [0.0, 2.0, 0.0], [0.0, 0.0, 2.0]])


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

    def test_f(self):
        x = np.array([[2, 3, 5]]).T
        self.assertEqual(f(x), 38.0)

    def test_grad(self):
        x = np.array([[3, 5, 7]]).T
        expected = np.array([[2.0 * 3.0, 2.0 * 5.0, 2.0 * 7.0]]).T
        result = grad(x)
        self.assertTrue(norm(expected - result) < 0.0001)

    def test_hess(self):
        x = np.array([[3, 5, 7]]).T
        expected = np.array([[2.0, 0.0, 0.0], [0.0, 2.0, 0.0], [0.0, 0.0, 2.0]]).T
        result = hess(x)
        self.assertTrue(norm(expected - result) < 0.0001)

    def test_simple_newton_w_equal(self):
        x0 = np.array([[1.3, 1.3, -1.3]]).T
        A = np.array([[-1.0, 1.0, 0.0], [1.0, 0.0, 1.0], [0.0, 0.0, 0.0]])
        b = np.array([[0.0, 0.0, 0.0]]).T
        expected = np.array([[0.0, 0.0, 0.0]]).T
        result = optim.newton_w_equal(f, grad, hess, x0, A, b, 0.00001, 100)
        self.assertTrue(norm(expected - result.x) < 0.0001)
