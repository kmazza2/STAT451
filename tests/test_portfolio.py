import src.hw4.portfolio as portfolio
from math import sqrt, log, inf
import numpy as np
from scipy.linalg import norm
from scipy.io import mmread
import unittest


class TestPortfolio(unittest.TestCase):
    def test_null_portfolio(self):
        p = mmread("tests/data/null_p.mm")
        pi = mmread("tests/data/null_pi.mm")
        x0 = mmread("tests/data/null_x0.mm")
        expected = np.array([[1.0]])
        result = portfolio.optimize(p, pi, x0, 1e-4, 100)
        self.assertTrue(norm(expected - result.x) < 1e-4)

    def test_less_null_portfolio(self):
        p = mmread("tests/data/less_null_p.mm")
        pi = mmread("tests/data/less_null_pi.mm")
        x0 = mmread("tests/data/less_null_x0.mm")
        expected = np.array([[1.0]])
        result = portfolio.optimize(p, pi, x0, 1e-4, 100)
        self.assertTrue(norm(expected - result.x) < 1e-4)

    def test_equally_less_null_portfolio(self):
        p = mmread("tests/data/equally_less_null_p.mm")
        pi = mmread("tests/data/equally_less_null_pi.mm")
        x0 = mmread("tests/data/equally_less_null_x0.mm")
        expected = np.array([[0.0, 1.0]]).T
        result = portfolio.optimize(p, pi, x0, 1e-4, 100)
        self.assertTrue(norm(expected - result.x) < 1e-4)

    def test_zero_return(self):
        p = mmread("tests/data/zero_return_p.mm")
        pi = mmread("tests/data/zero_return_pi.mm")
        x0 = mmread("tests/data/zero_return_x0.mm")
        expected = np.array([[1.0, 0.0]]).T
        result = portfolio.optimize(p, pi, x0, 1e-4, 100)
        self.assertTrue(norm(expected - result.x) < 1e-4)
