import numpy as np
from math import sqrt, log, inf
from scipy import linalg
import optim


def _scaled_obj_w_log_barrier(t, p, pi, x):
    n = x.shape[0]
    m = p.shape[1]
    # Calculate weighted log sum
    weighted_log_sum = 0.0
    for j in range(m):
        log_sum = 0.0
        for i in range(n):
            log_sum = log_sum + p[i, j] * x[i, 0]
        log_sum = log(log_sum) if log_sum > 0 else -inf
        weighted_log_sum = weighted_log_sum + pi[j, 0] * log_sum
    # Calculate sum_log
    sum_log = 0.0
    for i in range(n):
        sum_log = sum_log + (log(x[i, 0]) if x[i, 0] > 0 else -inf)
    return -t * weighted_log_sum - sum_log


def _scaled_obj_w_log_barrier_grad(t, p, pi, x):
    n = x.shape[0]
    m = p.shape[1]
    result = np.zeros((n, 1))
    for k in range(n):
        weighted_sum = 0.0
        for j in range(m):
            denom = 0.0
            for i in range(n):
                denom = denom + p[i, j] * x[i, 0]
            weighted_sum = weighted_sum + (pi[j, 0] * (1.0 / denom) * p[k, j])
        result[k, 0] = -t * weighted_sum - (1.0 / x[k, 0])
    return result


def _scaled_obj_w_log_barrier_hess(t, p, pi, x):
    n = x.shape[0]
    m = p.shape[1]
    result = np.zeros((n, n))
    for k in range(n):
        for l in range(n):
            if k != l:
                weighted_sum = 0.0
                for j in range(m):
                    denom = 0.0
                    for i in range(n):
                        denom = denom + p[i, j] * x[i, 0]
                    weighted_sum = weighted_sum + (
                        pi[j, 0] * p[k, j] * (1.0 / (denom**2.0)) * p[l, j]
                    )
                result[k, l] = t * weighted_sum
            else:
                weighted_sum = 0.0
                for j in range(m):
                    denom = 0.0
                    for i in range(n):
                        denom = denom + p[i, j] * x[i, 0]
                    weighted_sum = weighted_sum + (
                        pi[j, 0] * (p[k, j] ** 2.0) * (1.0 / (denom**2.0))
                    )
                result[k, k] = t * weighted_sum + (1.0 / (x[k, 0] ** 2.0))
    return result


def optimize(p, pi, x0, eps, max_iter):
    if (
        x0.shape[0] != p.shape[0]
        or pi.shape[0] != p.shape[1]
        or pi.shape[1] != 1
        or x0.shape[1] != 1
    ):
        raise Exception("Uncomformable arguments")
    t0 = 1.0
    mu = 15.0
    n = x0.shape[0]
    A = np.block([[np.ones((1, n))], [np.zeros((n - 1, n))]])
    b = np.block([[np.array([[1.0]])], [np.zeros((n - 1, 1))]])
    scaled_obj_w_log_barrier = lambda t, x: _scaled_obj_w_log_barrier(t, p, pi, x)
    scaled_obj_w_log_barrier_grad = lambda t, x: _scaled_obj_w_log_barrier_grad(
        t, p, pi, x
    )
    scaled_obj_w_log_barrier_hess = lambda t, x: _scaled_obj_w_log_barrier_hess(
        t, p, pi, x
    )
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
