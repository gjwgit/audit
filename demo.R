cat("===================================================================",
    "\nAudit Model Applied to a Dataset to Predict Financial Audit Outcome",
    "\n===================================================================\n\n")

suppressMessages(
{
library(rpart)        # Model: decision tree rpart().
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().
library(dplyr)        # Wrangling: tbl_df(), group_by(), print().
library(rattle)       # Support: normVarNames(), riskchart(), errorMatrix().
library(ggplot2)      # Visualise data.
library(tibble)
})

# Load the pre-built model.

load("audit_rpart_model.RData")

# Load a sample dataset, predict, and display a sample of predictions.

read.csv("data.csv") %T>%
  assign('ds', ., envir=.GlobalEnv) %>%
  predict(model, newdata=., type="class") %>%
  as.data.frame() %>%
  cbind(Actual=ds$adjusted) %>%
  set_names(c("Predicted", "Actual")) %>%
  select(Actual, Predicted) %>%
  mutate(Error=ifelse(Predicted==Actual, "", "<----")) %T>%
  {sample_n(., 20) %>% print()} ->
ev
  
# Produce confusion matrix using Rattle.

cat("\n================",
    "\nConfusion Matrix",
    "\n================\n\n")

per <- errorMatrix(ev$Actual, ev$Predicted) %T>% print()

# Calculate the overall error percentage.

cat(sprintf("\nOverall error: %.0f%%\n", 100-sum(diag(per), na.rm=TRUE)))

# Calculate the averaged class error percentage.

cat(sprintf("Average class error: %.0f%%\n", mean(per[,"Error"], na.rm=TRUE)))

# Calculate data for the risk chart. The classes are no and yes, which
# as integers are 1 and 2, so map to 0 and 1 to work with
# probabilities.

cat("\n==========",
    "\nRisk Chart",
    "\n==========\n\n")

ev$Actual %>%
  as.integer() %>%
  subtract(1) ->
ac

ad <- ds$adjustment

ds %>%
  predict(model, newdata=., type="prob") %>%
  as.data.frame() %>%
  '['(,2) ->
pr

evaluateRisk(pr, ac) %>%
  rownames_to_column("Complexity") %>%
  mutate(Complexity=as.numeric(Complexity)) %>%
  round(2) %>%
  print()

# Display the risk chart.

if (Sys.getenv("DISPLAY") != "")
{
  fname <- "audit_rpart_riskchart.pdf"
  pdf(file=fname, width=5, height=5)
  riskchart(pr, ac, ad,
            title="Risk Chart for Decision Tree Model",
            risk.name="adjustment",
            recall.name="adjusted",
            show.lift=TRUE,
            show.precision=TRUE,
            legend.horiz=FALSE) %>% print()
  invisible(dev.off())
  system(paste("xdg-open", fname), ignore.stderr=TRUE, wait=FALSE)

  cat("
The risk chart presents a cummulative performance view of the model.

The x-axis represents the percentage of the caseload as we progress
(left to right) through cases from the highest probability of an
adjustment being made to the financial data to the lowest probability
of an adjustment.

The y-axis is a measure of expected performance when using the model
to select customers to audit. It reports the percentage of the known
positive outcomes that are predicted by the model for the given
caseload (the recall).

The decision maker (company executive) in deploying the model will trade
the recall against the caseload depending on auditting resources available
and risk tolerance.
")
}
