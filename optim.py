import numpy as np
from math import sqrt
from scipy import linalg


class OptimResult:
    def __init__(self, x, iterations, converged):
        self.x = (x,)
        self.iterations = (iterations,)
        self.converged = converged

    def __str__(self):
        return "\n".join(
            [
                f"x: {self.x}",
                f"iterations: {self.iterations}",
                f"converged: {self.converged}",
            ]
        )


def barrier(
    scaled_obj_w_log_barrier,
    scaled_obj_w_log_barrier_grad,
    scaled_obj_w_log_barrier_hess,
    t,
    mu,
    x,
    m,
    A,
    b,
    eps,
    max_iter,
):
    for iteration in range(max_iter):
        f = lambda x: scaled_obj_w_log_barrier(t, x)
        grad = lambda x: scaled_obj_w_log_barrier_grad(t, x)
        hess = lambda x: scaled_obj_w_log_barrier_hess(t, x)
        newton_result = newton_w_equal(f, grad, hess, x, A, b, eps, max_iter)
        if newton_result.converged:
            x = newton_result.x[0]
        else:
            return OptimResult(x, iteration, False)
        if m / t < eps:
            return OptimResult(x, iteration, True)
        t = mu * t
    return OptimResult(x, max_iter, False)


def newton_w_equal(
    f,
    grad,
    hess,
    x,
    A,
    b,
    eps,
    max_iter,
    backtrack=True,
    hessian_cutoff=True,
    cutoff=1e10,
):
    if A.shape[0] != A.shape[1]:
        raise Exception("A must be square")
    if linalg.norm((A @ x) - b) > 0.0001:
        raise Exception("Invalid initial guess")
    r = 0
    b = np.zeros((A.shape[0], 1))
    for iteration in range(max_iter):
        H = hess(x)
        if hessian_cutoff and linalg.norm(H) > cutoff:
            return OptimResult(x, iteration, True)
        G = grad(x)
        step = min_quad_w_equal(H, G, r, A, b)
        t = 1
        if backtrack:
            while f(x + t * step) >= f(x) and t > 0:
                t = 0.5 * t
        step = t * step
        dec = newton_dec(step, H)
        if (dec**2) / 2.0 < eps:
            return OptimResult(x, iteration, True)
        x = x + step
    return OptimResult(x, max_iter, False)


def newton_dec(h, H):
    return sqrt((h.T @ H @ h)[0, 0])


def min_quad_w_equal(P, q, r, A, b):
    lhs = min_quad_w_equal_lhs(P, A)
    rhs = min_quad_w_equal_rhs(q, b)
    try:
        sol = linalg.solve(lhs, rhs)
    except:
        sol = linalg.lstsq(lhs, rhs)[0]
    return sol[0 : A.shape[1]]


def min_quad_w_equal_lhs(P, A):
    return np.block([[P, A.T], [A, np.zeros((A.shape[0], A.shape[0]))]])


def min_quad_w_equal_rhs(q, b):
    return np.block([[-1 * q], [b]])


def unconstrained_newton(f, J, hess, x0, eps, max_iter):
    x = x0
    for iteration in range(max_iter):
        try:
            h = linalg.solve(hess(x), -1.0 * J(x))
        except ValueError:
            return OptimResult(x, iteration, True)
        x = x + h
        if linalg.norm(h) < eps:
            return OptimResult(x, iteration, True)
    return OptimResult(x, max_iter, False)
