# The display command aims to provide a visualisation of the model in
# some form. This will differ from model to model.

cat("=============
Decision Tree
=============

A visual representation of a model can often be more insightful
than the textual representation. For a decision tree
model, representing the discovered knowledge as a decision tree, we
read the tree from top to bottom, traversing the path corresponding
to the answer to the question presented at each node. The leaf node
has the final decision together with the class probabilities.
")

suppressMessages(
{
library(rattle)      # Support: normVarNames(), weatherAUS. 
})

load("audit_rpart_model.RData")

if (Sys.getenv("DISPLAY") != "")
{
  cat("
Press Enter to display the decision tree: ")
  invisible(readChar("stdin", 1))

  fname <- "rpart_model.pdf"
  pdf(fname)
  fancyRpartPlot(model, sub="")
  invisible(dev.off())
  system(paste("atril --preview", fname), ignore.stderr=TRUE, wait=FALSE)

  cat("
Close the graphic window using Ctrl-w.

Press Enter to display the vairable importance plot: ")
  invisible(readChar("stdin", 1))

cat("
===================
Variable Importance
===================

An understanding of the relative importance of each of the variables
adds further insight into the data. The actual numeric values mean little
but the relativities are significant.

Press Enter to display the plot: ")
invisible(readChar("stdin", 1))
  
  fname <- "varimp.pdf"
  pdf(fname)
  print(ggVarImp(model))
  invisible(dev.off())
  system(paste("atril --preview", fname), ignore.stderr=TRUE, wait=FALSE)
}

cat("
Close the graphic window using Ctrl-W.

Press Enter to finish: ")
invisible(readChar("stdin", 1))
