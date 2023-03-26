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
    return exp(-1 + la(i, x) - sum([nu(j, x) * A[j, i] for j in range(3)]))

def _obj(t, x, A, b):
    x = x.reshape(13,1)
    sum1 = sum([x_star_i(i, x, A) * log(x_star_i(i, x, A)) for i in range(10)])
    sum2 = sum([la(i, x) * x_star_i(i, x, A) for i in range(10)])
    sum3 = sum([nu(i, x) * ((sum([A[i, q] * x_star_i(q, x, A) for q in range(10)])) - b[i, 0]) for i in range(3)])
    result = (-1.) * t * (sum1 - sum2 + sum3) - sum(
            [
                (
                    log(la(i, x))
                    if la(i, x) > 0
                    else -inf
                ) for i in range(10)
            ]
    )
    return result.squeeze()
def g(x):
    sum1 = sum([x_star_i(i, x, A) * log(x_star_i(i, x, A)) for i in range(10)])
    sum2 = sum([la(i, x) * x_star_i(i, x, A) for i in range(10)])
    sum3 = sum([nu(i, x) * ((sum([A[i, q] * x_star_i(q, x, A) for q in range(10)])) - b[i, 0]) for i in range(3)])
    return sum1 - sum2 + sum3

def optimize(A, b, x0, eps, max_iter):
    t0 = 1.0
    mu = 15.0
    t = t0
    x = x0
    m = 10
    success = False
    for iteration in range(1, max_iter + 1):
        obj = lambda x: _obj(t, x, A, b)
        next_x = minimize(obj, x)
        if next_x.success:
            x = next_x.x
        else:
            break
        if m/t < eps:
            success = True
            break
        t = mu * t
    x_star = np.zeros((10,1))
    for i in range(10):
        x = x.reshape(13,1)
        x_star[i, 0] = x_star_i(i, x, A)
    return optim.OptimResult(x_star, iteration, success)
