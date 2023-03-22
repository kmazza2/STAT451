import numpy as np
from scipy.io import mmread
from scipy import linalg
import optim.optim as optim

p = mmread("data/p1_p.mm")
pi = mmread("data/p1_pi.mm")
x0 = mmread("data/p1_x0.mm")
print(f"p:\n{p}")
print(f"pi:\n{pi}")
print(f"x0:\n{x0}")

# Everything below here can be safely deleted
