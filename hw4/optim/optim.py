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


def newton_w_equal(f, grad, hess, x0, A, b, eps, max_iter):
    if linalg.norm((A @ x) - b) > 0.0001:
        raise Exception("Invalid initial guess")
    r = 0
    b = np.zeros((A.shape[0], 1))
    for iteration in range(max_iter):
        step = min_quad_w_equal(hess(x), grad(x), r, A, b)
        dec = newton_dec(step, A)
        if (dec**2) / 2.0 < eps:
            return OptimResult(x, iteration, True)
        x = x + step
    return OptimResult(x, max_iter, False)


def newton_dec(h, A):
    return (h.T @ A @ h)[0, 0]


def min_quad_w_equal(P, q, r, A, b):
    lhs = min_quad_w_equal_lhs(P, A)
    rhs = min_quad_w_equal_rhs(q, b)
    # TODO: Make robust against singular lhs?
    sol = (
        linalg.solve(lhs, rhs)
        if lhs.shape[0] == lhs.shape[1]
        else linalg.lstsq(lhs, rhs)
    )
    return sol[0 : A.shape[1]]


def min_quad_w_equal_lhs(P, A):
    return np.block([[P, A.T], [A, np.zeros((A.shape[0], A.shape[0]))]])


def min_quad_w_equal_rhs(q, b):
    return np.block([[-1 * q], [b]])
