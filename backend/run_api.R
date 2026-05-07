library(plumber)
pr <- pr("plumber.R")
pr <- pr_set_serializer(pr, serializer_unboxed_json(type = "application/json; charset=utf-8"))
pr_run(pr, host = "127.0.0.1", port = 8000)
