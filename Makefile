########################################################################
#
# Makefile for audit pre-built ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 			\
	train.R			\
	configure.R 		\
	demo.R 			\
	print.R 		\
	display.R 		\
	score.R 		\
	README.txt		\
	DESCRIPTION.yaml	\
	audit.csv		\
	data.csv 		\
	audit_rpart_model.RData	\

# Include standard Makefile templates.

include ../git.mk
include ../pandoc.mk
include ../mlhub.mk

$(MODEL)_rpart_model.RData: train.R audit.csv
	Rscript $<

data.csv: train.R audit.csv
	Rscript $<

clean::
	rm -rf README.txt output

realclean:: clean
	rm -rf $(MODEL)_*.mlm $(MODEL)_rpart_model.RData
	rm -f  	audit_rpart_riskchart.pdf 	\
	        audit_rpart_model.RData 	\
		audit_rpart_model.pdf		\
		data.csv	
