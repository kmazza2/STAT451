import numpy as np
from scipy.io import mmread
from scipy import linalg
import optim.optim as optim

p = mmread("data/p1_p.mm")
pi = mmread("data/p1_pi.mm")
x0 = mmread("data/p1_x0.mm")
print(p)
print(pi)
print(x0)

# Everything below here can be safely deleted


def f(x):
    return x[0, 0] ** 2 + x[1, 0] ** 2 + x[2, 0] ** 2


def grad(x):
    return np.array([[2.0 * x[0, 0], 2.0 * x[1, 0], 2.0 * x[2, 0]]]).T


def hess(x):
    return np.array([[2.0, 0.0, 0.0], [0.0, 2.0, 0.0], [0.0, 0.0, 2.0]])


x0 = np.array([[1.3, 1.3, -1.3]]).T
A = np.array([[-1.0, 1.0, 0.0], [1.0, 0.0, 1.0], [0.0, 0.0, 0.0]])
b = np.array([[0.0, 0.0, 0.0]]).T
expected = np.array([[0.0, 0.0, 0.0]]).T
result = optim.newton_w_equal(f, grad, hess, x0, A, b, 0.00001, 100)
print(expected)
print(result)
