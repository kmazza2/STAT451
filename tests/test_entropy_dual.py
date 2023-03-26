import entropy_dual as dual
from math import sqrt, log, inf
import numpy as np
from scipy.linalg import norm
from scipy.io import mmread
import unittest


class TestPortfolio(unittest.TestCase):
    def setUp(self):
        self.x = np.array([[1,2,3,4,5,6,7,8,9,10,11,12,13]]).T
        self.m = 10
        self.p = 3
        self.la = dual._la(self.x, self.m)
        self.nu = dual._nu(self.x, self.m)
    def test_la(self):
        self.assertTrue(self.la.shape[0] == 10)

    def test_nu(self):
        self.assertTrue(self.nu.shape[0] == 3)

#     def test_g(la, nu, A, b):
#         raise NotImplementedError()
# 
#     def test_x_star_i(i, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_d_la_k_x_star_k(k, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_d_nu_l_x_star_i(l, i, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_d2_la_k_2_x_star_k(k, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_d2_la_k_nu_l_x_star_k(k, l, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_d2_nu_l_nu_w_x_star_i(l, w, i, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_d_la_k_g(k, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_d_nu_l_g(l, la, nu, A, b):
#         raise NotImplementedError()
# 
#     def test_d2_la_r_la_k_g(r, k, la, nu, A, b):
#         raise NotImplementedError()
# 
#     def test_d2_la_k_nu_l_g(k, l, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_d2_nu_l_nu_w_g(l, w, la, nu, A):
#         raise NotImplementedError()
# 
#     def test_scaled_obj_w_log_barrier(t, la, nu, A, b):
#         raise NotImplementedError()
# 
#     def test_scaled_obj_w_log_barrier_grad(t, la, nu, A, b):
#         raise NotImplementedError()
# 
#     def test_scaled_obj_w_log_barrier_hess(t, la, nu, A, b):
#         raise NotImplementedError()


#     def test_null_portfolio(self):
#         p = mmread("tests/data/null_p.mm")
#         pi = mmread("tests/data/null_pi.mm")
#         x0 = mmread("tests/data/null_x0.mm")
#         expected = np.array([[1.0]])
#         result = portfolio.optimize(p, pi, x0, 1e-4, 100)
#         self.assertTrue(norm(expected - result.x) < 1e-4)
#
#     def test_less_null_portfolio(self):
#         p = mmread("tests/data/less_null_p.mm")
#         pi = mmread("tests/data/less_null_pi.mm")
#         x0 = mmread("tests/data/less_null_x0.mm")
#         expected = np.array([[1.0]])
#         result = portfolio.optimize(p, pi, x0, 1e-4, 100)
#         self.assertTrue(norm(expected - result.x) < 1e-4)
#
#     def test_equally_less_null_portfolio(self):
#         p = mmread("tests/data/equally_less_null_p.mm")
#         pi = mmread("tests/data/equally_less_null_pi.mm")
#         x0 = mmread("tests/data/equally_less_null_x0.mm")
#         expected = np.array([[0.0, 1.0]]).T
#         result = portfolio.optimize(p, pi, x0, 1e-4, 100)
#         self.assertTrue(norm(expected - result.x) < 1e-4)
#
#     def test_zero_return(self):
#         p = mmread("tests/data/zero_return_p.mm")
#         pi = mmread("tests/data/zero_return_pi.mm")
#         x0 = mmread("tests/data/zero_return_x0.mm")
#         expected = np.array([[1.0, 0.0]]).T
#         result = portfolio.optimize(p, pi, x0, 1e-4, 100)
#         self.assertTrue(norm(expected - result.x) < 1e-4)
