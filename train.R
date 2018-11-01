# A sample model build using the financial audit dataset. We
# illustrate the model build and then save the model to file so that
# we can later load the model and use it to score new datasets.

library(tidyverse)    # ggplot2, tibble, tidyr, readr, purr, dplyr
library(rpart)
library(magrittr)     # Pipe operator %>% %<>% %T>% equals().
library(stringi)      # String concat operator %s+%.
library(rattle)
library(stringr)
library(randomForest) # Impute missing values with na.roughfix()

# Name of the dataset.

dsname <- "audit"

# Identify the source location of the dataset.

dsloc <- "https://rattle.togaware.com"

# Construct the path to the dataset and display some if it.

dsname %s+% ".csv" %>%
  file.path(dsloc, .) %T>%
  cat("Dataset:", ., "\n") ->
dspath

# Ingest the dataset.

dspath %>%
  read_csv() %T>%
  glimpse() %>%
  assign(dsname, ., .GlobalEnv)

# Prepare the dataset for usage with our template.

ds <- get(dsname)

# Review the variables to optionally normalise their names.

names(ds)

# Capture the original variable names for use later on.

onames <- names(ds)

# Normalise the variable names.

names(ds) %<>% normVarNames() %T>% print()

# Tune specific variable names: remove prefix.

if (TRUE)
{
  names(ds) %>% str_detect("_") -> uvars
  names(ds)[uvars] %<>% str_replace("^[^_]*_", '') %T>% print()
}

# Index the original variable names by the new names.

names(onames) <- names(ds)

# Confirm the results are as expected.

glimpse(ds)

# Review the first few observations.

head(ds) %>% print.data.frame()

# Review the last few observations.

tail(ds) %>% print.data.frame()

# Review a random sample of observations.

sample_n(ds, size=6) %>% print.data.frame()

# Note the available variables.

ds %>%
  names() %T>%
  print() ->
vars

# Note the target variable.

target <- "adjusted"

# Place the target variable at the beginning of the vars.

c(target, vars) %>%
  unique() %T>%
  print() ->
vars

# Note the risk variable - measures the severity of the outcome.

risk <- "adjustment"

# Note any identifiers.

id <- c("id")

# Initialise ignored variables: identifiers and risk.

ignore <- union(id, if (exists("risk")) risk) %T>% print()

# Check the number of variables currently.

length(vars)

# Remove the variables to ignore.

vars <- setdiff(vars, ignore) %T>% print()

# Confirm they are now ignored.

length(vars)

# Convert all character to factor.

ds %>%
  sapply(class) %>%
  '=='("character") %>%
  which() %>%
  names() %T>%
  print() ->
cvars

ds[cvars] %<>% 
  lapply(factor) %>% 
  data.frame() %>% 
  tbl_df()

# Count the number of missing values.

ds[vars] %>%  is.na() %>% sum() %>% comcat()

# Impute missing values.

ds[vars] %<>% na.roughfix()

# Confirm that no missing values remain.

ds[vars] %>%  is.na() %>% sum() %>% comcat()

# Record the number of observations.

nobs <- nrow(ds) %T>% comcat()

# Formula for modelling.

ds[vars] %>% 
  formula() %>% 
  print() ->
form

# Ensure the target is categoric.

class(ds[[target]])

ds[[target]] %<>% as.factor()
levels(ds[[target]]) <- c("no", "yes")

# Confirm the distribution.

ds[target] %>% table()

# Initialise random numbers for repeatable results.

seed <- 123
set.seed(seed)

# Partition the full dataset into three: train, validate, test.

nobs %>%
  sample(0.70*nobs) %T>% 
  {length(.) %>% comcat()} %T>%
  {head(.) %>% print()} ->
train

nobs %>%
  seq_len() %>% 
  setdiff(train) %>% 
  sample(0.15*nobs) %T>%
  {length(.) %>% comcat()} %T>%
  {head(.) %>% print()} ->
validate

nobs %>%
  seq_len() %>%
  setdiff(union(train, validate)) %T>%
  {length(.) %>% print()} %T>%
  {head(.) %>% print()} ->
test

# Create a sample data.csv file for the demo from the test and
# validate datasets.

obs <- union(validate, test)
ds[obs,] %>% write_csv("data.csv")

# Note the class of the dataset.

class(ds)

# Build the model.

rp_control <- rpart.control(maxdepth=5)
m_rp <- rpart(form, data=ds, control=rp_control) %T>% print()

# Store model as generic variable.

model <- m_rp

# Save the model to file.

save(model, file="audit_rpart_model.RData")
