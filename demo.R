########################################################################
# Introduce the concept of decision tree model through MLHub
#
# Copyright 2018 Graham.Williams@togaware.com

cat("=====================
Predict Audit Outcome
=====================

Below we show the predictions after applying the pre-built decision tree
model to a random subset of a dataset of previously unseen audit case
outcomes. This provides an insight into the expected future performance
of the model.

")

# Load required packages.

suppressMessages(
{
library(rpart)        # Model: decision tree rpart().
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().
library(dplyr)        # Wrangling: tbl_df(), group_by(), print().
library(rattle)       # Support: normVarNames(), riskchart(), errorMatrix().
library(ggplot2)      # Visualise data.
library(tibble)
})

#-----------------------------------------------------------------------
# Load the pre-built model.
#-----------------------------------------------------------------------

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
  {sample_n(., 12) %>% print()} ->
ev

#-----------------------------------------------------------------------
# Produce confusion matrix using Rattle.
#-----------------------------------------------------------------------

cat("\nPress Enter to continue on to a Confusion Matrix: ")
invisible(readChar("stdin", 1))

cat("
================
Confusion Matrix
================

A confusion matrix summarises the performance of the model on this evluation
dataset. All figures in the table are percentages and are calculated across
the predicitions made by the model for each observation and compared to the
actual or known values of the target variable. The first column reports the
true negative and false negative rates whilst the second column reports the
false positive and true positive rates.

The Error column calculates the error across each class. We also report the
overall error which is calculated as the number of errors over the number of
observations. The average of the class errors is also reported. 

")

per <- errorMatrix(ev$Actual, ev$Predicted) %T>% print()

# Calculate the overall error percentage.

cat(sprintf("\nOverall error: %.0f%%\n", 100-sum(diag(per), na.rm=TRUE)))

# Calculate the averaged class error percentage.

cat(sprintf("Average class error: %.0f%%\n", mean(per[,"Error"], na.rm=TRUE)))

# Calculate data for the risk chart. The classes are no and yes, which
# as integers are 1 and 2, so map to 0 and 1 to work with
# probabilities.

cat("\nPress Enter to continue on to a Risk Chart: ")
invisible(readChar("stdin", 1))

cat("
==========
Risk Chart
==========

A risk chart presents a cumulative performance view of the model.

The x-axis is the percentage of caseload as we progress (left to right)
through cases from the highest probability of an adjustment being made to
the financial data to the lowest probability of an adjustment.

The y-axis is the expected performance of the model in selecting customers
to audit. It is the percentage of the known positive outcomes that are
predicted by the model for the given caseload (the recall).

To deploy the model the decision maker will trade recall against caseload
in accordance with availalbe auditing resources and risk tolerance.

The more area under the curve (both adjusted and adjustment) the better
the model performance. A perfect model would follow the grey line (for
adjusted) and the pink line (for adjustment). The Precision line represents
the lift offered by the model, with the lift values on the right hand axis.
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

if (Sys.getenv("DISPLAY") != "")
{
  system(paste("atril --preview", fname), ignore.stderr=TRUE, wait=FALSE)
}

cat("
Close the graphic window using Ctrl-w.
Press Enter to finish the demonstration: ")
invisible(readChar("stdin", 1))
