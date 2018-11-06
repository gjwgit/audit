cat("=====================
Predict Audit Outcome
=====================

Below we show the predictions after applying the pre-built model to a
dataset of previously unseen audit case outcomes. This provides an insight
to how the pre-built model will perform when used on previously unseen cases.

")

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

set.seed(4237)

# Load a sample dataset, predict, and display a sample of predictions.

read.csv("data.csv") %T>%
  assign('ds', ., envir=.GlobalEnv) %>%
  predict(model, newdata=., type="class") %>%
  as.data.frame() %>%
  cbind(Actual=ds$adjusted) %>%
  set_names(c("Predicted", "Actual")) %>%
  select(Actual, Predicted) %>%
  mutate(Error=ifelse(Predicted==Actual, "", "<----")) %T>%
  {sample_n(., 13) %>% print()} ->
ev

# Produce confusion matrix using Rattle.

cat("\nPress Enter to continue on to the Confusion Matrix: ")
invisible(readChar("stdin", 1))

cat("
================
Confusion Matrix
================

A confusion matrix summarises the performance of the model on this
dataset. The figures here are percentages, aggregating the actual versus
predicted outcomes. The Error column represents the class error.

")

per <- errorMatrix(ev$Actual, ev$Predicted) %T>% print()

# Calculate the overall error percentage.

cat(sprintf("\nOverall error: %.0f%%\n", 100-sum(diag(per), na.rm=TRUE)))

# Calculate the averaged class error percentage.

cat(sprintf("Average class error: %.0f%%\n", mean(per[,"Error"], na.rm=TRUE)))

# Calculate data for the risk chart. The classes are no and yes, which
# as integers are 1 and 2, so map to 0 and 1 to work with
# probabilities.

cat("\nPress Enter to continue on to the Risk Chart: ")
invisible(readChar("stdin", 1))

cat("
==========
Risk Chart
==========

A risk chart will now be generated and displayed in a separate window.

The risk chart presents a cumulative performance view of the model.

The x-axis represents the percentage of the caseload as we progress
(left to right) through cases from the highest probability of an
adjustment being made to the financial data to the lowest probability
of an adjustment.

The y-axis is a measure of expected performance when using the model
to select customers to audit. It reports the percentage of the known
positive outcomes that are predicted by the model for the given
caseload (the recall).

To deploy the model the decision maker (chief auditor) will trade the
recall against the caseload depending on auditing resources available
and risk tolerance.
")

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

## evaluateRisk(pr, ac) %>%
##   rownames_to_column("Complexity") %>%
##   mutate(Complexity=as.numeric(Complexity)) %>%
##   round(2) %>%
##   print()

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
  system(paste("atril --preview", fname), ignore.stderr=TRUE, wait=FALSE)
}

cat("\nPress Enter to finish the demonstration: ")
invisible(readChar("stdin", 1))
