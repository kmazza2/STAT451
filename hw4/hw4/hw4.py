import numpy as np
from scipy.io import mmread
from scipy import linalg

p = mmread('data/p1_p.mm')
pi = mmread('data/p1_pi.mm')
x0 = mmread('data/p1_x0.mm')
print(p)
print(pi)
print(x0)
