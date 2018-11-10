cat("=============
Decision Tree
=============

A visual representation of a model can often be more insightful
than the printed textual representation. For a decision tree
model, representing the discovered knowledge as a decision tree, we
read the tree from top to bottom, traversing the path corresponding
to the answer to the question presented at each node. The leaf node
has the final decision together with the class probabilities.
")

suppressMessages(
{
library(rattle)
})

load("audit_rpart_model.RData")

if (Sys.getenv("DISPLAY") != "")
{
  fname <- "rpart_model.pdf"
  pdf(fname)
  fancyRpartPlot(model, sub="")
  invisible(dev.off())
  system(paste("atril --preview", fname), ignore.stderr=TRUE, wait=FALSE)
}

cat("
Close the graphic window using Ctrl-W.
Press Enter to finish: ")
invisible(readChar("stdin", 1))
