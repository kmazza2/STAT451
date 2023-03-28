This directory contains Python code implementing solutions to the HW 4 problems. The code is split among:
```
entropy.py
entropy_dual.py
hw4.py
optim.py
portfolio.py
```
optim.py contains functions used in both problems. portfolio.py contains code used for Problem 1. entropy.py and entropy_dual.py contain code for solving the primal and dual problems (respectively) in Problem 2. hw4.py runs the algorithms on the given inputs and presents the result.

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

