import numpy as np
from math import sqrt, log, inf
from scipy import linalg
import optim


def scaled_obj_w_log_barrier(t, x):
    n = x.shape[0]
    weighted_sum_log = 0.0
    sum_log = 0.0
    for i in range(n):
        weighted_sum_log = weighted_sum_log + x[i, 0] * log(x[i, 0])
        sum_log = sum_log + log(x[i, 0])
    return t * weighted_sum_log - sum_log


def scaled_obj_w_log_barrier_grad(t, x):
    n = x.shape[0]
    result = np.zeros((n, 1))
    for i in range(n):
        result[i, 0] = t * (log(x[i, 0]) + 1) - (1.0 / x[i, 0])
    return result


def scaled_obj_w_log_barrier_hess(t, x):
    n = x.shape[0]
    result = np.zeros((n, n))
    for i in range(n):
        for j in range(n):
            if i != j:
                result[i, j] = 0.0
            else:
                result[i, i] = (1.0 / x[i, 0]) * (t + (1.0 / x[i, 0]))
    return result


def optimize(A, b, x0, eps, max_iter):
    if (
        x0.shape[0] != A.shape[1]
        or b.shape[0] != A.shape[0]
        or b.shape[1] != 1
        or x0.shape[1] != 1
    ):
        raise Exception("Uncomformable arguments")
    t0 = 1.0
    mu = 15.0
    n = x0.shape[0]
    p = A.shape[0]
    A = np.block([[A], [np.zeros((n - p, n))]])
    b = np.block([[b], [np.zeros((n - p, 1))]])
    return optim.barrier(
        scaled_obj_w_log_barrier,
        scaled_obj_w_log_barrier_grad,
        scaled_obj_w_log_barrier_hess,
        t0,
        mu,
        x0,
        n,
        A,
        b,
        eps,
        max_iter,
    )
