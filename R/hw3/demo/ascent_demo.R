source("poiss.R")

data_path <- "../C/data/oilspills.dat"
param_path <- "../C/test/data/fakeoilspillsparam.dat"
max_iter <- 10000
epsabs <- 0.01

results <- ascent(data_path, param_path, max_iter, epsabs)
print(results)
