from scipy.io import mmread
import portfolio

p = mmread("data/p1_p.mm")
pi = mmread("data/p1_pi.mm")
x0 = mmread("data/p1_x0.mm")

result = portfolio.optimize(p, pi, x0, 1e-4, 100)
print(
    f"converged: {result.converged}\niterations: {result.iterations}\nvalue:\n{result.x[0]}"
)
