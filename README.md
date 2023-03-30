This directory contains Python code implementing solutions to the HW 4 problems. The code is split among:
```
entropy.py
entropy_dual.py
hw4.py
optim.py
portfolio.py
```
optim.py contains implementations of Newton's method for problems with inequality and equality constraints (barrier), problems with equality constraints only (newton_w_equal), quadratic problems with equality constraints only (min_quad_w_equal), and fully unconstrained problems (unconstrained_newton). (Boyd suggests implementing each of these, then reducing each problem to a sequence of problems of a simpler class. That is the approach I took here.) portfolio.py sets up the objective, gradient, and Hessian for Problem 1. entropy.py and entropy_dual.py contain implementations of the objectives, gradients, and Hessians for the primal and dual problems (respectively) in Problem 2. hw4.py runs the algorithms on the given inputs and presents the result.

octave_entropy_dual.m is a GNU Octave script confirming the result for the dual problem in Problem 2.

The code should run using Python 3.9.2 with NumPy 1.24.2 and SciPy 1.10.1. I also have a Docker container which packages these dependencies for you:
```
docker pull kmazza2/stat451
docker run -it kmazza2/stat451
git clone https://github.com/kmazza2/STAT451
cd STAT451
git checkout HW4
python3 hw4.py
python3 -m unittest
```
