library(plumber)
pr <- pr("plumber.R")
pr_run(pr, host = "127.0.0.1", port = 8000)
