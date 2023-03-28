import optim
from math import sqrt, log, inf
import numpy as np
from scipy.linalg import norm
import unittest


def f1(x):
    return x[0, 0] ** 2 + x[1, 0] ** 2 + x[2, 0] ** 2


def grad1(x):
    return np.array([[2.0 * x[0, 0], 2.0 * x[1, 0], 2.0 * x[2, 0]]]).T


def hess1(x):
    return np.array([[2.0, 0.0, 0.0], [0.0, 2.0, 0.0], [0.0, 0.0, 2.0]])


def f2(x):
    return (x[0, 0] ** 3.0) * x[1, 0] - x[2, 0] ** 2.0


def grad2(x):
    return np.array(
        [[3.0 * (x[0, 0] ** 2.0) * x[1, 0], x[0, 0] ** 3.0, -2.0 * x[2, 0]]]
    ).T


def hess2(x):
    return np.array(
        [
            [6.0 * x[0, 0] * x[1, 0], 3.0 * x[0, 0] ** 2.0, 0.0],
            [3.0 * x[0, 0] ** 2.0, 0.0, 0.0],
            [0.0, 0.0, -2.0],
        ]
    )


def scaled_obj_w_log_barrier1(t, x):
    return t * ((x[0, 0] + 1.0) ** 2.0 + (x[1, 0] + 2) ** 2.0) - (
        (log(x[0, 0]) if x[0, 0] > 0 else -inf)
        + (log(x[1, 0]) if x[1, 0] > 0 else -inf)
    )


def scaled_obj_w_log_barrier_grad1(t, x):
    return np.array(
        [
            [
                2.0 * t * (x[0, 0] + 1.0) - x[0, 0] ** (-1.0),
                2.0 * t * (x[1, 0] + 2) - x[1, 0] ** (-1.0),
            ]
        ]
    ).T


def scaled_obj_w_log_barrier_hess1(t, x):
    return np.array(
        [
            [2.0 * t + x[0, 0] ** (-2.0), 0.0],
            [0.0, 2.0 * t + x[1, 0] ** (-2.0)],
        ]
    )


def scaled_obj_w_log_barrier2(t, x):
    return t * ((x[0, 0] + 1.0) ** 2.0 + (x[1, 0] + 2) ** 2.0) - (
        (log(x[0, 0]) if x[0, 0] > 0 else -inf)
    )


def scaled_obj_w_log_barrier_grad2(t, x):
    return np.array(
        [
            [
                2.0 * t * (x[0, 0] + 1.0) - x[0, 0] ** (-1.0),
                2.0 * t * (x[1, 0] + 2),
            ]
        ]
    ).T


def scaled_obj_w_log_barrier_hess2(t, x):
    return np.array(
        [
            [2.0 * t + x[0, 0] ** (-2.0), 0.0],
            [0.0, 2.0 * t],
        ]
    )


def f3(x):
    result = np.zeros((2, 1))
    result[0, 0] = (
        3.0 * x[0, 0] ** 3.0
        - (1.0 / 2.0) * x[0, 0] ** 2.0
        - (13.0 / 2.0) * x[0, 0]
        + (2.0 / 3.0)
    )
    result[1, 0] = 2.0 * x[1, 0]
    return result


def J3(x):
    result = np.zeros((2, 2))
    result[0, 0] = 9.0 * x[0, 0] ** 2.0 - x[0, 0] - (13.0 / 2.0)
    result[0, 1] = 0.0
    result[1, 0] = 0.0
    result[1, 1] = 2.0
    return result


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
        self.assertTrue(norm(expected - result) < 1e-4)

    def test_f1(self):
        x = np.array([[2, 3, 5]]).T
        self.assertEqual(f1(x), 38.0)

    def test_grad1(self):
        x = np.array([[3, 5, 7]]).T
        expected = np.array([[2.0 * 3.0, 2.0 * 5.0, 2.0 * 7.0]]).T
        result = grad1(x)
        self.assertTrue(norm(expected - result) < 1e-4)

    def test_hess1(self):
        x = np.array([[3, 5, 7]]).T
        expected = np.array([[2.0, 0.0, 0.0], [0.0, 2.0, 0.0], [0.0, 0.0, 2.0]]).T
        result = hess1(x)
        self.assertTrue(norm(expected - result) < 1e-4)

    def test_simple_newton_w_equal_no_backtrack(self):
        x0 = np.array([[1.3, 1.3, -1.3]]).T
        A = np.array([[-1.0, 1.0, 0.0], [1.0, 0.0, 1.0], [0.0, 0.0, 0.0]])
        b = np.array([[0.0, 0.0, 0.0]]).T
        expected = np.array([[0.0, 0.0, 0.0]]).T
        result = optim.newton_w_equal(f1, grad1, hess1, x0, A, b, 1e-5, 100, False)
        self.assertTrue(norm(expected - result.x) < 1e-4)

    def test_simple_newton_w_equal_backtrack(self):
        x0 = np.array([[1.3, 1.3, -1.3]]).T
        A = np.array([[-1.0, 1.0, 0.0], [1.0, 0.0, 1.0], [0.0, 0.0, 0.0]])
        b = np.array([[0.0, 0.0, 0.0]]).T
        expected = np.array([[0.0, 0.0, 0.0]]).T
        result = optim.newton_w_equal(f1, grad1, hess1, x0, A, b, 1e-5, 100, True)
        self.assertTrue(norm(expected - result.x) < 1e-4)

    def test_complex_newton_w_equal_backtrack(self):
        x0 = np.array([[-1.0, 0.0, 1.0]]).T
        A = np.array([[1.0, 0.0, 1.0], [-1.0, 1.0, 0.0], [0.0, 0.0, 0.0]])
        b = np.array([[0.0, 1.0, 0.0]]).T
        expected = np.array(
            [
                [
                    (-3.0 - sqrt(41.0)) / 8.0,
                    (5.0 - sqrt(41.0)) / 8.0,
                    (3.0 + sqrt(41.0)) / 8.0,
                ]
            ]
        ).T
        result = optim.newton_w_equal(f2, grad2, hess2, x0, A, b, 1e-14, 100, True)
        self.assertTrue(norm(expected - result.x) < 1e-4)

    def test_simple_barrier(self):
        t0 = 1.0
        mu = 15.0
        x0 = np.array([[2.0, 3.0]]).T
        m = 2
        A = np.zeros((2, 2))
        b = np.zeros((2, 1))
        expected = np.array([[0.0, 0.0]]).T
        result = optim.barrier(
            scaled_obj_w_log_barrier1,
            scaled_obj_w_log_barrier_grad1,
            scaled_obj_w_log_barrier_hess1,
            t0,
            mu,
            x0,
            m,
            A,
            b,
            1e-5,
            100,
        )
        self.assertTrue(norm(expected - result.x) < 1e-4)

    def test_complex_barrier(self):
        t0 = 1.0
        mu = 15.0
        x0 = np.array([[2.0, -2]]).T
        m = 2
        A = np.array([[1.0, 1.0], [0.0, 0.0]])
        b = np.zeros((2, 1))
        expected = np.array([[0.5, -0.5]]).T
        result = optim.barrier(
            scaled_obj_w_log_barrier2,
            scaled_obj_w_log_barrier_grad2,
            scaled_obj_w_log_barrier_hess2,
            t0,
            mu,
            x0,
            m,
            A,
            b,
            1e-5,
            100,
        )
        self.assertTrue(norm(expected - result.x) < 1e-4)

    def test_unconstrained_newton(self):
        x0 = np.array([[-1.2, 1.0]]).T
        expected = np.array([[-1.442340828, 0.0]]).T
        result = optim.unconstrained_newton(None, f3, J3, x0, 0.001, 100)
        self.assertTrue(norm(expected - result.x) < 1e-2)
