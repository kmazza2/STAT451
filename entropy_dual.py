import numpy as np
from math import sqrt, log, inf, exp
from scipy import linalg
import optim


def _la(x, m):
    assert x[:m].shape[0] == 10
    return x[:m]


def _nu(x, m):
    assert x[m:].shape[0] == 3
    return x[m:]


def _g(la, nu, A, b):
    m = la.shape[0]
    p = nu.shape[0]
    n = m
    sum1 = 0.0
    sum2 = 0.0
    sum3 = 0.0
    for i in range(n):
        nu_sum = sum([nu[j, 0] * A[j, i] for j in range(p)])
        sum1 = sum1 + exp(-1 + la[i, 0] - nu_sum) * (-1 + la[i, 0] - nu_sum)
    for i in range(m):
        nu_sum = sum([nu[j, 0] * A[j, i] for j in range(p)])
        sum2 = sum2 + la[i, 0] * exp(-1 + la[i, 0] - nu_sum)
    for i in range(p):
        exp_sum = 0.0
        for k in range(n):
            nu_sum = sum([nu[j, 0] * A[j, k] for j in range(p)])
            exp_sum = exp_sum + A[i, k] * exp(-1 + la[k, 0] - nu_sum)
        sum3 = sum3 + nu[i, 0] * (exp_sum - b[i, 0])
    return sum1 - sum2 + sum3


def _x_star_i(i, la, nu, A):
    p = nu.shape[0]
    return exp(-1 + la[i, 0] - sum([nu[j, 0] * A[j, i] for j in range(p)]))


def _d_la_k_x_star_k(k, la, nu, A):
    p = nu.shape[0]
    return exp(-1 + la[k, 0] - sum([nu[j, 0] * A[j, k] for j in range(p)]))


def _d_nu_l_x_star_i(l, i, la, nu, A):
    p = nu.shape[0]
    return (
        -1.0
        * A[l, i]
        * exp(-1 + la[i, 0] - sum([nu[j, 0] * A[j, i] for j in range(p)]))
    )


def _d2_la_k_2_x_star_k(k, la, nu, A):
    p = nu.shape[0]
    return exp(-1 + la[k, 0] - sum([nu[j, 0] * A[j, k] for j in range(p)]))


def _d2_la_k_nu_l_x_star_k(k, l, la, nu, A):
    p = nu.shape[0]
    return (
        (-1.0)
        * A[l, k]
        * exp(-1 + la[k, 0] - sum([nu[j, 0] * A[j, k] for j in range(p)]))
    )


def _d2_nu_l_nu_w_x_star_i(l, w, i, la, nu, A):
    assert l < 3
    assert w < 3
    assert i < 10
    p = nu.shape[0]
    return (
        A[l, i]
        * A[w, i]
        * exp(-1 + la[i, 0] - sum([nu[j, 0] * A[j, i] for j in range(p)]))
    )


def _d_la_k_g(k, la, nu, A):
    m = la.shape[0]
    p = nu.shape[0]
    n = m
    return (
        _d_la_k_x_star_k(k, la, nu, A) * (1.0 + log(_x_star_i(k, la, nu, A)))
        - (
            (_x_star_i(k, la, nu, A) + la[k, 0] * _d_la_k_x_star_k(k, la, nu, A))
            if m >= k
            else 0.0
        )
        + sum([nu[i, 0] * A[i, k] * _d_la_k_x_star_k(k, la, nu, A) for i in range(p)])
    )


def _d_nu_l_g(l, la, nu, A, b):
    m = la.shape[0]
    p = nu.shape[0]
    n = m
    return (
        sum(
            [
                (_d_nu_l_x_star_i(l, i, la, nu, A)) * (1 + log(_x_star_i(i, la, nu, A)))
                for i in range(n)
            ]
        )
        - sum([la[i, 0] * _d_nu_l_x_star_i(l, i, la, nu, A) for i in range(m)])
        + sum(
            [
                nu[i, 0]
                * sum([A[i, q] * _d_nu_l_x_star_i(l, q, la, nu, A) for q in range(n)])
                for i in range(p)
            ]
        )
        + sum([A[l, q] * _x_star_i(q, la, nu, A) for q in range(n)])
        - b[l, 0]
    )


def _d2_la_r_la_k_g(r, k, la, nu, A, b):
    assert k < 10
    assert r < 10
    if r != k:
        return 0.0
    m = la.shape[0]
    p = nu.shape[0]
    n = m
    return (
        _d2_la_k_2_x_star_k(k, la, nu, A) * (1 + log(_x_star_i(k, la, nu, A)))
        + (1.0 / _x_star_i(k, la, nu, A)) * ((_d_la_k_x_star_k(k, la, nu, A)) ** 2.0)
        - (
            2.0 * _d_la_k_x_star_k(k, la, nu, A)
            + la[k, 0] * _d2_la_k_2_x_star_k(k, la, nu, A)
            if m >= k
            else 0.0
        )
        + sum(
            [nu[i, 0] * A[i, k] * _d2_la_k_2_x_star_k(k, la, nu, A) for i in range(p)]
        )
    )


def _d2_la_k_nu_l_g(k, l, la, nu, A):
    m = la.shape[0]
    p = nu.shape[0]
    n = m
    return (
        _d2_la_k_nu_l_x_star_k(k, l, la, nu, A) * (1 + log(_x_star_i(k, la, nu, A)))
        + (1.0 / _x_star_i(k, la, nu, A))
        * _d_la_k_x_star_k(k, la, nu, A)
        * _d_nu_l_x_star_i(l, k, la, nu, A)
        - (
            _d_nu_l_x_star_i(l, k, la, nu, A)
            + la[k, 0] * _d2_la_k_nu_l_x_star_k(k, l, la, nu, A)
            if m >= k
            else 0.0
        )
        + sum(
            [
                nu[i, 0] * A[i, k] * _d2_la_k_nu_l_x_star_k(k, l, la, nu, A)
                for i in range(p)
            ]
        )
        + A[l, k] * _d_la_k_x_star_k(k, la, nu, A)
    )


def _d2_nu_l_nu_w_g(l, w, la, nu, A):
    assert l < 3
    assert w < 3
    m = la.shape[0]
    p = nu.shape[0]
    n = m
    sum1 = sum(
        [
            _d2_nu_l_nu_w_x_star_i(l, w, i, la, nu, A)
            * (1 + log(_x_star_i(i, la, nu, A)))
            + _d_nu_l_x_star_i(l, i, la, nu, A)
            * (1.0 / _x_star_i(i, la, nu, A))
            * _d_nu_l_x_star_i(w, i, la, nu, A)
            for i in range(n)
        ]
    )
    sum2 = sum(
        [la[i, 0] * _d2_nu_l_nu_w_x_star_i(l, w, i, la, nu, A) for i in range(m)]
    )
    sum3 = sum(
        [
            nu[i, 0]
            * sum(
                [A[i, q] * _d2_nu_l_nu_w_x_star_i(l, w, q, la, nu, A) for q in range(n)]
            )
            for i in range(p)
        ]
    )
    sum4 = sum([A[w, q] * _d_nu_l_x_star_i(l, q, la, nu, A) for q in range(n)])
    sum5 = sum([A[l, q] * _d_nu_l_x_star_i(w, q, la, nu, A) for q in range(n)])
    return sum1 - sum2 + sum3 + sum4 + sum5


def _scaled_obj_w_log_barrier(t, la, nu, A, b):
    m = la.shape[0]
    if any(la <= 0.0):
        return inf
    return (-1.0) * t * _g(la, nu, A, b) - sum([log(la[i, 0]) for i in range(m)])


def _scaled_obj_w_log_barrier_grad(t, la, nu, A, b):
    m = la.shape[0]
    p = nu.shape[0]
    n = m + p
    result = np.zeros((n, 1))
    for k in range(n):
        if k <= m - 1:
            result[k, 0] = (-1.0) * t * _d_la_k_g(k, la, nu, A) - (1.0 / la[k, 0])
        else:
            result[k, 0] = (-1.0) * t * _d_nu_l_g(k - m, la, nu, A, b)
    assert result.shape[0] == 13
    return result


def _scaled_obj_w_log_barrier_hess(t, la, nu, A, b):
    m = la.shape[0]
    p = nu.shape[0]
    n = m + p
    result = np.zeros((n, n))
    for k in range(n):
        for r in range(n):
            if k <= m - 1 and r <= m - 1:
                if k != r:
                    result[k, r] = (-1.0) * t * _d2_la_r_la_k_g(k, r, la, nu, A, b)
                else:
                    result[k, r] = (-1.0) * t * _d2_la_r_la_k_g(k, k, la, nu, A, b) + (
                        1.0 / ((la[k, 0]) ** 2.0)
                    )
            elif k <= m - 1 and m <= r:
                result[k, r] = (-1.0) * t * _d2_la_k_nu_l_g(k, r - m, la, nu, A)
            elif r <= m - 1 and m <= k:
                result[k, r] = (-1.0) * t * _d2_la_k_nu_l_g(r, k - m, la, nu, A)
            elif m <= k and m <= r:
                result[k, r] = (-1.0) * t * _d2_nu_l_nu_w_g(k - m, r - m, la, nu, A)
            else:
                raise Exception("Invalid case")
    assert result.shape[0] == 13
    assert result.shape[1] == 13
    return result


def optimize(m, p, A, b, x0, eps, max_iter):
    t0 = 1.0
    mu = 15.0
    n = m + p
    A2 = np.zeros((n, n))
    b2 = np.zeros((n, 1))
    scaled_obj_w_log_barrier = lambda t, x: _scaled_obj_w_log_barrier(
        t, _la(x, m), _nu(x, m), A, b
    )
    scaled_obj_w_log_barrier_grad = lambda t, x: _scaled_obj_w_log_barrier_grad(
        t, _la(x, m), _nu(x, m), A, b
    )
    scaled_obj_w_log_barrier_hess = lambda t, x: _scaled_obj_w_log_barrier_hess(
        t, _la(x, m), _nu(x, m), A, b
    )
    assert m == 10
    assert p == 3
    assert n == 13
    return optim.barrier(
        scaled_obj_w_log_barrier,
        scaled_obj_w_log_barrier_grad,
        scaled_obj_w_log_barrier_hess,
        t0,
        mu,
        x0,
        m,
        A2,
        b2,
        eps,
        max_iter,
    )
