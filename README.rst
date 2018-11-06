==================================
Predicting Financial Audit Outcome
==================================

This model comes from the Rattle package for R and is used in the
Rattle book to demonstrate a classification model use-case in
financial audit. A sample dataset of audit outcomes is used to train a
model to predict the outcome of the audit. Typically we want to focus
on successful audits, which identify missing or incorrectly reported
financial data. The financial impact of the audit is also recorded as
a dollar impact.

This `MLHub <https://mlhub.ai>`_ pre-built model package uses the R
language to build the classification (decision) tree model to
represent the knowledge discovered.  A so-called recursive
partitioning algorithm is utilised. The knowledge representation
language (decision tree) is recognised as an easily understandable
language which is why such a representation is quite popular in
situations where explanations are important.

-----
Usage
-----

To install and run the pre-built model::

  $ pip install mlhub
  $ ml install audit
  $ ml configure audit
  $ ml demo audit
