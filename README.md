Predicting Financial Audit Outcome
==================================

This [MLHub](https://mlhub.ai) package contains a decision tree model
from the [Rattle](https://rattle.togaware.com) package for
[R](https://r-project.org). It is used in the
[Rattle](https://bit.ly/rattle_data_mining) book to demonstrate a
classification model use-case in financial audit.  A sample dataset of
audit outcomes is used to train the model to predict the outcome of
audits. A successful audit identifies missing or incorrectly reported
financial data.

A classification (decision) tree model to represent the discovered
knowledge is built using a recursive partitioning algorithm. Decision
trees are recognised as an easily understandable representation of the
discovered knowledge. They are widely popular in situations where
insight and explanations are important.

Visit the github repository for more details:
<https://github.com/gjwgit/audit>

Usage
-----

To install and run the pre-built model:

    $ pip3 install mlhub
    $ ml install   audit
    $ ml configure audit
    $ ml demo      audit
    $ ml print     audit
    $ ml display   audit
