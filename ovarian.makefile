ROOTDIR=$(PWD)
SCRIPTSPATH=$(ROOTDIR)/Code
ATROPOSCMD=$(ANTSPATH)/Atropos
WORKDIR=workdir
DATADIR=ImageDatabase
C3DEXE=c3d
ANTSREGISTRATIONCMD=$(ANTSPATH)/antsRegistration
ANTSAPPLYTRANSFORMSCMD=$(ANTSPATH)/antsApplyTransforms
ANTSIMAGEMATHCMD=$(ANTSPATH)/ImageMath
PNGSLICE=python $(SCRIPTSPATH)/viewsoln.py --labelfile=$(SCRIPTSPATH)/dfltlabels.txt 
RFMODEL=FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel
# control texture features
RUNOTB=0

TESTCASES := Predict1000/before Predict1001/before Predict1002/01012000
# new cases automagically added
SUBDIRS := $(TESTCASES)
# look at all directories  of the for MRN/date
SUBDIRS := $(shell ls ImageDatabase/tcga_ov/[0-9]*/*_grey.nii.gz | cut -d'_' -f 1-2 | cut -d'/' -f 2-)


IMAGEDATA:= $(addsuffix /ImageData.Rdata,$(addprefix $(WORKDIR)/,$(SUBDIRS)))  
 
.SECONDARY: $(addsuffix /Mask.centroid.txt,$(addprefix $(WORKDIR)/,$(SUBDIRS)))  \
            $(addsuffix /Mask.nii.gz,$(addprefix $(WORKDIR)/,$(SUBDIRS)))  \
            $(IMAGEDATA)  \
            $(addsuffix /FullImageList.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS)))
gmmfeature: $(addsuffix /$(RFMODEL)/LABELS.RFGMM.nii.gz,$(addprefix $(WORKDIR)/,$(SUBDIRS)))
png: $(addsuffix /Truth.png,$(addprefix $(WORKDIR)/,$(SUBDIRS)))
predictors: $(addsuffix /TopPredictors.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS)))

# create tex file for viewing
tex:  png $(addsuffix /ViewProcessed.pdf,$(addprefix $(WORKDIR)/,$(SUBDIRS))) 

references.bbl:
# generate bbl file for use w/ \input commmand
%.bbl: %.bib
	pdflatex -jobname tmp$*         \
           \\documentclass{article}     \
           \\begin{document}            \
           \\bibliographystyle{plain}   \
           \\bibliography{$*}           \
           \\nocite{*}                  \
           \\end{document}
	bibtex tmp$*

summary.pdf: tex
	echo  $(IMAGEDATA) |  sed "s/\s\+/,/g" >  $(WORKDIR)/visualizeData.csv
	Rscript Code/visualizeData.R $(WORKDIR)
	pdflatex ViewSummary.tex
	pdftk ViewSummary.pdf `ls workdir/*/*/ViewProcessed.pdf | sort -V` cat output  summary.pdf

FEATURES = grey \
           pre_ATROPOS_GMM_POSTERIORS4 \
           pre_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO \
           pre__DIFFERENCE \
           NORMALIZED_DISTANCE \
           pre_ATROPOS_GMM_ECCENTRICITY \
           pre_ATROPOS_GMM_ELONGATION \
           pre_ATROPOS_GMM_LABEL3_DISTANCE \
           pre_ATROPOS_GMM \
           pre_ATROPOS_GMM_PHYSICAL_VOLUME \
           pre_ATROPOS_GMM_POSTERIORS1 \
           pre_ATROPOS_GMM_POSTERIORS2 \
           pre_ATROPOS_GMM_POSTERIORS3 \
           pre_ENTROPY_RADIUS_1 \
           pre_ENTROPY_RADIUS_3 \
           pre_MEAN_RADIUS_1 \
           pre_MEAN_RADIUS_3 \
           pre_NORMALIZED \
           pre_SIGMA_RADIUS_1 \
           pre_SIGMA_RADIUS_3 \
           pre_SKEWNESS_RADIUS_1 \
           pre_SKEWNESS_RADIUS_3


stats: $(foreach idft,$(FEATURES),      $(addsuffix _$(idft).lstat.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS))) )

echo:
	@echo $(SUBDIRS)
	@echo $(foreach idft,$(FEATURES),      $(addsuffix _$(idft).lstat.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS))) )

csv: 
	counter=0 ; for idfile in  $(WORKDIR)/*/*/*.lstat.csv ; do  if [[ $$counter -eq 0 ]] ;then cat $$idfile; else sed '1d' $$idfile; fi; counter=$$((counter+1)) ;done > DataSummary.csv
	mkdir -p DataSummary
	$(foreach idim,$(CONTRAST),$(foreach idft,$(FEATURES), grep  "$(idim)_$(idft)"  DataSummary.csv   >  DataSummary/$(idim)_$(idft).csv;  ))
 

# make -f prediction.makefile   qa  > qa.txt 2>&1
qa:
	@$(foreach iddir,$(SUBDIRS),  echo c3d $(DATADIR)/$(iddir)/Ven.nii.gz $(DATADIR)/$(iddir)/Truth.nii.gz -lstat; c3d $(DATADIR)/$(iddir)/Ven.nii.gz $(DATADIR)/$(iddir)/Truth.nii.gz -lstat; ) 

# create csv file of top image predictors
$(WORKDIR)/%/ViewProcessed.pdf: $(WORKDIR)/%/ImageData.Rdata
	echo "\\IfFileExists{$(WORKDIR)/$*/TopPredictors.csv}{\\verbatiminput{$(WORKDIR)/$*/TopPredictors.csv}}{predictors not found}\\viewdata{$(WORKDIR)/$*/}{Pre}\\viewdata{$(WORKDIR)/$*/}{Art}\\viewdata{$(WORKDIR)/$*/}{Ven}\\viewdata{$(WORKDIR)/$*/}{Del}" | sort -V > $(@D)/DoNotCOMMIT.tex; pdflatex -output-directory $(WORKDIR)/$*/ ViewProcessed.tex 

# create mask from truth image if does not exist
# get image centroid for plotting
$(WORKDIR)/%/Mask.nii.gz $(WORKDIR)/%/Mask.centroid.txt: 
	mkdir -p $(WORKDIR)/$* 
	if [[ -f $(DATADIR)/$*/Mask.nii.gz ]]; then echo "using Mask.nii.gz" ; cp $(DATADIR)/$*/Mask.nii.gz $(WORKDIR)/$*/Mask.nii.gz; elif [[ -f $(DATADIR)/$*/Truth.nii.gz ]]; then echo "using Truth.nii.gz" ; $(C3DEXE) $(DATADIR)/$*/Truth.nii.gz  -binarize  -o $(WORKDIR)/$*/Mask.nii.gz; else echo "NEED MASK" ;fi
	python Code/slicecentroid.py --imagedir=$(DATADIR)/$* > $(WORKDIR)/$*/Mask.centroid.txt
	
$(WORKDIR)/%/Truth.png: $(WORKDIR)/%/Mask.centroid.txt
	-c3d $(DATADIR)/$*/Truth.nii.gz -slice z `cat $<` -dup -oli Code/dfltlabels.txt 1.0   -type uchar -omc $(WORKDIR)/$*/Truth.png


# create csv file of image list
$(WORKDIR)/%/FullImageList.csv: $(WORKDIR)/%/Mask.nii.gz 
	echo  "DATAID" "MASK"          "TRUTH"                      "NORMALIZED_DISTANCE"       $(foreach idim,$(CONTRAST),$(foreach idft,$(FEATURES),               "$(idim)_$(idft)"       ))|  sed "s/\s\+/,/g" >  $@
	echo   "$*" "$<" "$(DATADIR)/$*/Truth.nii.gz"  $(WORKDIR)/$*/NORMALIZED_DISTANCE.nii.gz $(foreach idim,$(CONTRAST),$(foreach idft,$(FEATURES), "$(WORKDIR)/$*/$(idim)_$(idft).nii.gz"))|  sed "s/\s\+/,/g" >> $@

# create csv file of top image predictors
$(WORKDIR)/%/ImageData.Rdata $(WORKDIR)/%/TopPredictors.csv: $(WORKDIR)/%/FullImageList.csv
	Rscript Code/imageStatistics.R 3 $< $(@D)


#run mixture model to segment the image
#https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
#https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html#Secondary-Expansion
.SECONDEXPANSION:
$(WORKDIR)/%/$(RFMODEL)/LABELS.RFGMM.nii.gz: $(WORKDIR)/$(RFMODEL) $(WORKDIR)/$$*/Mask.nii.gz  $(WORKDIR)/$$*/Mask.centroid.txt 
	export SCRIPTSPATH=$(SCRIPTSPATH); mkdir -p $(WORKDIR)/$*/$(RFMODEL);  $(SCRIPTSPATH)/applyTumorSegmentationModel.sh  -d 3 -x $(word 2,$^)  -l 1  -n Pre -a $(DATADIR)/$*/Pre.nii.gz -n Art -a $(DATADIR)/$*/Art.nii.gz  -n Ven -a $(DATADIR)/$*/Ven.nii.gz -n Del -a $(DATADIR)/$*/Del.nii.gz -r 1 -r 3 -r 5 -s 2 -b 3 -z $(RUNOTB) -o $(WORKDIR)/$*/ -k $(WORKDIR)/$*/$(RFMODEL)/ -m $<  -e `cat $(word 3,$^)`
	$(ANTSIMAGEMATHCMD) 3 $@ MostLikely 0 $(WORKDIR)/$*/$(RFMODEL)/RF_POSTERIORS*.nii.gz

#extract image statistics from label map
#$(WORKDIR)/%.lstat.csv:  $(WORKDIR)/%.nii.gz   $(DATADIR)/$$(*D)/Truth.nii.gz 
$(WORKDIR)/%.lstat.csv:  $(DATADIR)/%.nii.gz
	mkdir -p $(dir $(WORKDIR)/$*)
	$(C3DEXE) $< $(dir $(DATADIR)/$*)/$(word 3,  $(subst /, ,$(DATADIR)/$*))_labels.nii.gz -lstat > $@.txt ; sed "s/^\s\+/$(firstword $(subst /, ,$(*D))),$(lastword $(subst /, ,$(*D))),$(*F),/g;s/\s\+/,/g;s/LabelID/ProjectID,DataID,FeatureID,LabelID/g;s/Vol(mm^3)/Vol.mm.3/g;s/Extent(Vox)/ExtentX,ExtentY,ExtentZ/g" $@.txt > $@


statsummary.csv:
	counter=0 ; for idfile in workdir/tcga_ov/*/*.lstat.csv ; do  if [[ "$$counter" -eq 0 ]] ;then cat $$idfile; else sed '1d' $$idfile; fi; counter=$$((counter+1)) ;done > $@
