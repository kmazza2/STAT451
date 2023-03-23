# Assignments for UIC STAT 451

Each homework assignment has its own branch. This is so that for each assignment Gradescope only downloads the source files corresponding to that assignment.

The Dockerfile contains build details for a minimal, reproducible environment in which my Python code can be run. You don't need to build it yourself; a prebuilt version can be installed and run with
```
docker pull kmazza2/stat451
docker run -it kmazza2/stat451
cd STAT451
```
Check out your favorite branch with
```
git checkout HW4
```
See individual branch README.md files for details.
