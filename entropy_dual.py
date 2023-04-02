import numpy as np
from math import sqrt, log, inf, exp
import warnings
import sys
warnings.simplefilter("ignore")
from scipy import linalg
import optim


def la(i, x):
    return x[i, 0]


def nu(i, x):
    return x[i + 10, 0]


def x_star_i(i, x, A):
    assert i < 10
    return exp(-1 + la(i, x) - sum([nu(j, x) * A[j, i] for j in range(3)]))


def _obj(t, x, A, b):
    x = x.reshape(13, 1)
    sum1 = sum([x_star_i(i, x, A) * log(x_star_i(i, x, A)) for i in range(10)])
    sum2 = sum([la(i, x) * x_star_i(i, x, A) for i in range(10)])
    sum3 = sum(
        [
            nu(i, x)
            * ((sum([A[i, q] * x_star_i(q, x, A) for q in range(10)])) - b[i, 0])
            for i in range(3)
        ]
    )
    result = (-1.0) * t * (sum1 - sum2 + sum3) - sum(
        [(log(la(i, x)) if la(i, x) > 0 else -inf) for i in range(10)]
    )
    return result

def _grad(t, x, A, b):
    x = x.reshape(13, 1)
    la_grad = np.zeros((10, 1))
    nu_grad = np.zeros((3, 1))
    for k in range(10):
        term1 = (
            x_star_i(k, x, A) *
            (
                log(x_star_i(k, x, A)) - la(k, x)
            )
        )
        term2 = sum(
            [
                nu(i, x) *
                A[i, k] *
                x_star_i(k, x, A)
                for i in range(3)
            ]
        )
        la_grad[k, 0] = -t * (term1 + term2) - (1. / la(k, x))
    for l in range(3):
        sum1 = sum(
            [
                A[l, i] *
                x_star_i(i, x, A) *
                (1 + log(x_star_i(i, x, A)))
                for i in range(10)
            ]
        )
        sum2 = sum(
            [
                A[l, i] *
                la(i, x) *
                x_star_i(i, x, A)
                for i in range(10)
            ]
        )
        sum3 = sum(
            [
                nu(i, x) *
                sum(
                    [
                        A[i, q] *
                        A[l, q] *
                        x_star_i(q, x, A)
                        for q in range(10)
                    ]
                )
                for i in range(3)
            ]
        )
        sum4 = sum(
            [
                A[l, q] *
                x_star_i(q, x, A)
                for q in range(10)
            ]
        )
        nu_grad[l, 0] = -t * (-sum1 + sum2 - sum3 + sum4 - b[l, 0])
    return np.block([[la_grad],[nu_grad]])

def _hess(t, x, A, b):
    x = x.reshape(13, 1)
    result = np.zeros((13, 13))
    for r in range(13):
        for k in range(r + 1):
            if r < 10:
                if r != k:
                    result[r, k] = 0.
                else:
                    result[r, k] = (
                        -t * (
                            x_star_i(k, x, A) * (
                                -la(k, x) + log(x_star_i(k, x, A))
                            ) +
                            sum(
                                [
                                    nu(i, x) *
                                    A[i, k] *
                                    x_star_i(k, x, A)
                                    for i in range(3)
                                ]
                            )
                        ) + (1. / la(k, x))**2.
                    )
            else:
                l = r - 10
                if k < 10:
                    result[r, k] = (
                        -t * (
                            -A[l, k] * x_star_i(k, x, A) * (
                                -la(k, x) + log(x_star_i(k, x, A))
                            ) -
                            sum(
                                [
                                    nu(i, x) *
                                    A[i, k] *
                                    A[l, k] *
                                    x_star_i(k, x, A)
                                    for i in range(3)
                                ]
                            )
                        )
                    )
                else:
                    w = k - 10
                    result[r, k] = (
                        -t * (
                            sum(
                                [
                                    A[l, i] *
                                    A[w, i] *
                                    x_star_i(i, x, A) *
                                    (2 + log(x_star_i(i, x, A)))
                                    for i in range(10)
                                ]
                            ) +
                            sum(
                                [
                                    nu(i, x) *
                                    sum(
                                        [
                                            A[i, q] *
                                            A[l, q] *
                                            A[w, q] *
                                            x_star_i(q, x, A)
                                            for q in range(10)
                                        ]
                                    )
                                    for i in range(3)
                                ]
                            ) -
                            2. * sum(
                                [
                                    A[l, q] *
                                    A[w, q] *
                                    x_star_i(q, x, A)
                                    for q in range(10)
                                ]
                            )
                        )
                    )
    for r in range(13):
        for k in range(r):
            result[k, r] = result[r, k]
    return result


def g(x):
    sum1 = sum([x_star_i(i, x, A) * log(x_star_i(i, x, A)) for i in range(10)])
    sum2 = sum([la(i, x) * x_star_i(i, x, A) for i in range(10)])
    sum3 = sum(
        [
            nu(i, x)
            * ((sum([A[i, q] * x_star_i(q, x, A) for q in range(10)])) - b[i, 0])
            for i in range(3)
        ]
    )
    return sum1 - sum2 + sum3


def optimize(A, b, x0, eps, max_iter):
    t0 = 2000
    mu = 1.1
    t = t0
    x = x0
    m = 1e8
    success = False
    for iteration in range(1, max_iter + 1):
        obj = lambda x: _obj(t, x, A, b)
        grad = lambda x: _grad(t, x, A, b)
        hess = lambda x: _hess(t, x, A, b)
        next_x = optim.unconstrained_newton(obj, grad, hess, x, eps, max_iter)
        if next_x.converged:
            x = next_x.x[0]
        else:
            success = False
            break
        if m / t < eps:
            success = True
            break
        t = mu * t
    return optim.OptimResult(x, iteration, success)
