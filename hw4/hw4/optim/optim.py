class OptimResult:
    def __init__(self, x, iterations, converged):
        self.x = x,
        self.iterations = iterations,
        self.converged = converged
    def __str__(self):
        return '\n'.join(
                [
                    f'x: {self.x}',
                    f'iterations: {self.iterations}',
                    f'converged: {self.converged}'
                ]
        )

def min_quad_w_equal_lhs(P, A):
    return np.block(
        [
            [P, A.T                             ],
            [A, np.zeros((A.size[0], A.size[0]))]
        ]
    )

def min_quad_w_equal_rhs(q, b):
    return np.block(
            [
                [-1*q],
                [b]
            ]
    )
