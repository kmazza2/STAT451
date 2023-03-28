This directory contains a Python package implementing solutions to the HW 4 problems. Install Docker, then pull the container with:
```
docker pull kmazza2/stat451
```
Start the container with
```
docker run -it kmazza2/stat451
```
Once the container is running, the following commands will execute the homework programs and tests:
```
git clone https://github.com/kmazza2/STAT451
cd STAT451
git checkout HW4
python3 hw4.py
python3 -m unittest
```
It is that easy 😎

If you don't want to use Docker, the code should run uncontainerized using Python 3.9.2 with NumPy 1.24.2 and SciPy 1.10.1. The container packages these dependencies for you though.
