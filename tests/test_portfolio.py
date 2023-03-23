import hw4.portfolio.portfolio as portfolio
from math import sqrt, log, inf
import numpy as np
from scipy.linalg import norm
from scipy.io import mmread
import unittest


class TestOptim(unittest.TestCase):
    def test_null_portfolio(self):
        p = mmread("tests/data/null_p.mm")
        pi = mmread("tests/data/null_pi.mm")
        x0 = mmread("tests/data/null_x0.mm")
        expected = np.array([[1.]])
        result = portfolio.optimize(p, pi, x0, 1e-4, 100)
        self.assertTrue(norm(expected - result.x) < 1e-4)
