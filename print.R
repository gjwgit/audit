library(rpart)

load("audit_rpart_model.RData")

print(model)

cat("\nPress Enter to continue: ")
invisible(readChar("stdin", 1))
