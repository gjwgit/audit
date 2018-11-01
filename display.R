suppressMessages(
{
library(rattle)
})

load("audit_rpart_model.RData")

if (Sys.getenv("DISPLAY") != "")
{
  fname <- "audit_rpart_model.pdf"
  pdf(fname)
  fancyRpartPlot(model, sub="")
  invisible(dev.off())
  system(paste("xdg-open", fname))
}
