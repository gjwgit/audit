########################################################################
# Introduce the concept of decision tree model through MLHub
#
# Copyright 2018 Graham.Williams@togaware.com

cat("=================================
Textual Presentation of the Model
=================================

the textual presentation of the model is the default output from the R package
for decision trees. It begins with a record of the number of observations
used to build the model (n=). The following two lines of text are a legend
to assist ithe interpretation of the textual representation.

Press Enter to list the textual representation of the model: ")
invisible(readChar("stdin", 1))

# Load required packages.

suppressMessages(
{
library(rpart)
})

load("audit_rpart_model.RData")

print(model)

cat("
Press Enter to finish: ")
invisible(readChar("stdin", 1))
