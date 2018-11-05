########################################################################
#
# Makefile for audit r pre-build ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 			\
	audit_rpart_model.RData	\
	configure.R 		\
	demo.R 			\
	score.R 		\
	print.R 		\
	display.R 		\
	train.R			\
	audit.csv		\
	data.csv 		\
	README.txt		\
	DESCRIPTION.yaml

# Include standard Makefile templates.

include ../git.mk
include ../pandoc.mk
include ../mlhub.mk

$(MODEL)_rpart_model.RData: train.R audit.csv
	Rscript $<

clean::
	rm -rf README.txt output

realclean:: clean
	rm -rf *.mlm
	rm -f *~
	rm -f  	audit_rpart_riskchart.pdf 	\
	        audit_rpart_model.RData 	\
		audit_rpart_model.pdf		\
		data.csv	
