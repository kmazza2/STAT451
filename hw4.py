from scipy.io import mmread
import numpy as np
import portfolio
import entropy
import entropy_dual

p = mmread("data/p1_p.mm")
pi = mmread("data/p1_pi.mm")
x0 = mmread("data/p1_x0.mm")

result = portfolio.optimize(p, pi, x0, 1e-4, 100)
print(
    f"Problem 1(c)\nconverged: {result.converged}\niterations: {result.iterations}\nvalue:\n{result.x[0]}"
)

A = mmread("data/p2_A.mm")
b = mmread("data/p2_b.mm")
x0 = mmread("data/p2_x0.mm")


result = entropy.optimize(A, b, x0, 1e-4, 100)
print(
    f"Problem 2(a)\nconverged: {result.converged}\niterations: {result.iterations}\nvalue:\n{result.x[0]}"
)

m = 10
p = 3

x0 = np.array(
    [
        [0.0002],
        [0.0002],
        [0.0002],
        [0.0002],
        [0.0002],
        [0.0002],
        [0.0002],
        [0.0002],
        [0.0002],
        [0.0002],
        [-0.6],
        [0.3],
        [-0.4]
    ]
)

result = entropy_dual.optimize(A, b, x0, 1e-4, 100)
print(
    f"Problem 2(c)\nconverged: {result.converged}\niterations: {result.iterations}\nvalue:\n{result.x[0]}"
)
