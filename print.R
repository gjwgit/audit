library(rpart)

load("audit_rpart_model.RData")

print(model)

cat("
Press Enter to finish: ")
invisible(readChar("stdin", 1))
