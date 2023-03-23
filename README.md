[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

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
