########################################################################
#
# Makefile for audit pre-built ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 				\
	train.R				\
	configure.R			\
	demo.R 				\
	print.R				\
	display.R 			\
	score.R				\
	README.txt			\
	DESCRIPTION.yaml		\
	$(MODEL).csv			\
	data.csv 			\
	$(MODEL)_rpart_model.RData	\

# Include standard Makefile templates.

include ../git.mk
include ../pandoc.mk
include ../mlhub.mk

$(MODEL)_rpart_model.RData: train.R $(MODEL).csv
	Rscript $<

data.csv: train.R audit.csv
	Rscript $<

clean::
	rm -rf README.txt output

realclean:: clean
	rm -f 	$(MODEL)_*.mlm
	rm -f 	$(MODEL)_rpart_riskchart.pdf 	\
		rpart_model.pdf			\
		varimp.pdf			\
