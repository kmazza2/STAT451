import numpy as np
from math import sqrt, log, inf, exp
import warnings

warnings.simplefilter("ignore")
from scipy import linalg
from scipy.optimize import minimize
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
        term1 = x_star_i(k, x) * (log(x_star_i(k, x)) - la(k, x))
        term2 = sum([nu(i, x) * (A[i, k] * x_star_i(k, x) - b[i, 0]) for i in range(3)])
        la_grad[k, 0] = -t * (term1 + term2) - (1. / la(k, x))
    for l in range(3):
        sum1 = sum([A[l, i] * x_star_i(i, x) * (1 + log(x_star_i(i, x))) for i in range(10)])
        sum2 = sum([A[l, i] * la(i, x) * x_star_i(i, x) for i in range(10)])
        sum3 = sum([nu(i, x) * sum([A[i, q] * A[l, q] * x_star_i(q, x) for q in range(10)]) for i in range(3)])
        sum4 = sum([A[l, q] * x_star_i(q, x) for q in range(10)])
        nu_grad[l, 0] = -t * (-sum1 + sum2 - sum3 + sum4 - b[l, 0])
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
    #     t0 = 1.0
    t0 = 0.01
    mu = 15.0
    t = t0
    x = x0
    m = 10
    success = False
    for iteration in range(1, max_iter + 1):
        obj = lambda x: _obj(t, x, A, b)
        next_x = minimize(obj, x, tol=0.1)
        if next_x.success:
            x = next_x.x
        else:
            success = True
            break
        if m / t < eps:
            success = True
            break
        t = mu * t
    x_star = np.zeros((10, 1))
    for i in range(10):
        x = x.reshape(13, 1)
        x_star[i, 0] = x_star_i(i, x, A)
    return optim.OptimResult(x_star, iteration, success)
