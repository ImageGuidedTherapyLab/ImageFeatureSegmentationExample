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
RUNOTB=1
RUNOTB=0

TESTCASES := Predict1000/before Predict1001/before Predict1002/before
# new cases automagically added
SUBDIRS := $(TESTCASES)
SUBDIRS := $(filter-out $(TESTCASES),$(shell find ImageDatabase/ -mindepth 2 -links 2 -type d -print | cut -d'/' -f 2-) )
 
.SECONDARY: $(addsuffix /Mask.centroid.txt,$(addprefix $(WORKDIR)/,$(SUBDIRS)))  \
            $(addsuffix /FullImageList.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS)))
gmmfeature: $(addsuffix /$(RFMODEL)/LABELS.RFGMM.nii.gz,$(addprefix $(WORKDIR)/,$(SUBDIRS)))
png: $(addsuffix /Truth.png,$(addprefix $(WORKDIR)/,$(SUBDIRS)))
predictors: $(addsuffix /TopPredictors.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS)))

echo:
	@echo $(SUBDIRS)

# create tex file for viewing
tex:  png $(addsuffix /ViewProcessed.pdf,$(addprefix $(WORKDIR)/,$(SUBDIRS))) 

summary.pdf: tex
	pdftk `ls workdir/*/*/*.pdf | sort -V` cat output  summary.pdf

CONTRAST = Pre Art Ven Del
FEATURES = RAWIMAGE                                    \
           DENOISE                                     \
           RESCALE                                     \
           GRADIENT                                    \
           ATROPOS_GMM_CANNY                           \
           ATROPOS_GMM_ECCENTRICITY                    \
           ATROPOS_GMM_ELONGATION                      \
           ATROPOS_GMM_LABEL1_DISTANCE                 \
           ATROPOS_GMM                                 \
           ATROPOS_GMM_PHYSICAL_VOLUME                 \
           ATROPOS_GMM_POSTERIORS1                     \
           ATROPOS_GMM_POSTERIORS2                     \
           ATROPOS_GMM_POSTERIORS3                     \
           ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO    \
           ENTROPY_RADIUS_1                            \
           ENTROPY_RADIUS_3                            \
           ENTROPY_RADIUS_5                            \
           MEAN_RADIUS_1                               \
           MEAN_RADIUS_3                               \
           MEAN_RADIUS_5                               \
           OTBClusterProminence_1                      \
           OTBClusterProminence_3                      \
           OTBClusterProminence_5                      \
           OTBClusterShade_1                           \
           OTBClusterShade_3                           \
           OTBClusterShade_5                           \
           OTBCorrelation_1                            \
           OTBCorrelation_3                            \
           OTBCorrelation_5                            \
           OTBEnergy_1                                 \
           OTBEnergy_3                                 \
           OTBEnergy_5                                 \
           OTBEntropy_1                                \
           OTBEntropy_3                                \
           OTBEntropy_5                                \
           OTBHaralickCorrelation_1                    \
           OTBHaralickCorrelation_3                    \
           OTBHaralickCorrelation_5                    \
           OTBInertia_1                                \
           OTBInertia_3                                \
           OTBInertia_5                                \
           OTBInverseDifferenceMoment_1                \
           OTBInverseDifferenceMoment_3                \
           OTBInverseDifferenceMoment_5                \
           SIGMA_RADIUS_1                              \
           SIGMA_RADIUS_3                              \
           SIGMA_RADIUS_5                              \
           SKEWNESS_RADIUS_1                           \
           SKEWNESS_RADIUS_3                           \
           SKEWNESS_RADIUS_5                                 

stats: $(foreach idft,$(FEATURES),      $(addsuffix /Pre_$(idft).lstat.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS))) )\
       $(foreach idft,$(FEATURES),      $(addsuffix /Art_$(idft).lstat.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS))) )\
       $(foreach idft,$(FEATURES),      $(addsuffix /Ven_$(idft).lstat.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS))) )\
       $(foreach idft,$(FEATURES),      $(addsuffix /Del_$(idft).lstat.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS))) )\
       $(addsuffix /NORMALIZED_DISTANCE.lstat.csv,$(addprefix $(WORKDIR)/,$(SUBDIRS)))

csv: 
	counter=0 ; for idfile in  $(WORKDIR)/*/*/*.lstat.csv ; do  if [[ $$counter -eq 0 ]] ;then cat $$idfile; else sed '1d' $$idfile; fi; counter=$$((counter+1)) ;done > DataSummary.csv
 

# TODO
#segmentation: $(addsuffix /$(RFMODEL)/LABELS.GMM.nii.gz,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))
#volume: $(addsuffix /$(RFMODEL)/LABELS.GMM.VolStat.csv,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))
#png: $(addsuffix /$(RFMODEL)/LABELS.GMM.png,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))

# $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.png: $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz
# 	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Pre.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
# 	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Art.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
# 	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Ven.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
# 	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Del.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
# 	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Mask.nii.gz --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
# 	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=./LABELS.GMM.nii.gz --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
# 
# $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.VolStat.csv: $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz
# 	echo vglrun itksnap -g $(DATADIR)/$*/Art.nii.gz -s $(DATADIR)/$*/Truth.nii.gz
# 	cd $(WORKDIR)/$*/$(RFMODEL); c3d LABELS.GMM.nii.gz LABELS.GMM.nii.gz -lstat > LABELS.GMM.VolStat.txt ; sed "s/\s\+/,/g" LABELS.GMM.VolStat.txt > LABELS.GMM.VolStat.csv 
# 


# create csv file of top image predictors
$(WORKDIR)/%/ViewProcessed.pdf: $(WORKDIR)/%/TopPredictors.csv
	echo "\\IfFileExists{$(WORKDIR)/$*/TopPredictors.csv}{\\verbatiminput{$(WORKDIR)/$*/TopPredictors.csv}}{predictors not found}\\viewdata{$(WORKDIR)/$*/}{Pre}\\viewdata{$(WORKDIR)/$*/}{Art}\\viewdata{$(WORKDIR)/$*/}{Ven}\\viewdata{$(WORKDIR)/$*/}{Del}" | sort -V > DoNotCOMMIT.tex; pdflatex -output-directory $(WORKDIR)/$*/ ViewProcessed.tex 

# create mask from truth image if does not exist
$(DATADIR)/%/Mask.nii.gz: $(DATADIR)/%/Truth.nii.gz
	mkdir -p $(WORKDIR)/$*
	$(C3DEXE) $<  -binarize  -o $@

$(WORKDIR)/%/Truth.png: $(WORKDIR)/%/Mask.centroid.txt
	-c3d $(DATADIR)/$*/Truth.nii.gz -slice z `cat $<` -dup -oli Code/dfltlabels.txt 1.0   -type uchar -omc $(WORKDIR)/$*/Truth.png

# get image centroid for plotting
$(WORKDIR)/%/Mask.centroid.txt : $(DATADIR)/%/Mask.nii.gz 
	mkdir -p $(WORKDIR)/$*
	python Code/slicecentroid.py --imagefile=$< > $@

# create csv file of image list
$(WORKDIR)/%/FullImageList.csv: $(DATADIR)/%/Mask.nii.gz 
	echo  "MASK"     "TRUTH"                      "NORMALIZED_DISTANCE"       $(foreach idim,$(CONTRAST),$(foreach idft,$(FEATURES),               "$(idim)_$(idft)"       ))|  sed "s/\s\+/,/g" >  $@
	echo  "$<" "$(<D)/Truth.nii.gz"  $(WORKDIR)/$*/NORMALIZED_DISTANCE.nii.gz $(foreach idim,$(CONTRAST),$(foreach idft,$(FEATURES), "$(WORKDIR)/$*/$(idim)_$(idft).nii.gz"))|  sed "s/\s\+/,/g" >> $@

# create csv file of top image predictors
$(WORKDIR)/%/TopPredictors.csv: $(WORKDIR)/%/FullImageList.csv
	Rscript Code/imageStatistics.R 3 $< $(@D)

#run mixture model to segment the image
#https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
#https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html#Secondary-Expansion
.SECONDEXPANSION:
$(WORKDIR)/%/$(RFMODEL)/LABELS.RFGMM.nii.gz: $(WORKDIR)/$(RFMODEL) $(DATADIR)/$$*/Mask.nii.gz  $(WORKDIR)/$$*/Mask.centroid.txt 
	export SCRIPTSPATH=$(SCRIPTSPATH); mkdir -p $(WORKDIR)/$*/$(RFMODEL);  $(SCRIPTSPATH)/applyTumorSegmentationModel.sh  -d 3 -x $(word 2,$^)  -l 1  -n Pre -a $(DATADIR)/$*/Pre.nii.gz -n Art -a $(DATADIR)/$*/Art.nii.gz  -n Ven -a $(DATADIR)/$*/Ven.nii.gz -n Del -a $(DATADIR)/$*/Del.nii.gz -r 1 -r 3 -r 5 -s 2 -b 3 -z $(RUNOTB) -o $(WORKDIR)/$*/ -k $(WORKDIR)/$*/$(RFMODEL)/ -m $<  -e `cat $(word 3,$^)`
	$(ANTSIMAGEMATHCMD) 3 $@ MostLikely 0 $(WORKDIR)/$*/$(RFMODEL)/RF_POSTERIORS*.nii.gz

#extract image statistics from label map
$(WORKDIR)/%.lstat.csv:  $(WORKDIR)/%.nii.gz   $(DATADIR)/$$(*D)/Truth.nii.gz 
	$(C3DEXE) $^ -lstat > $@.txt ; sed "s/^\s\+/$(firstword $(subst /, ,$(*D))),$(lastword $(subst /, ,$(*D))),$(*F),/g;s/\s\+/,/g;s/LabelID/DataID,Time,FeatureID,LabelID/g;s/Vol(mm^3)/Vol.mm.3/g;s/Extent(Vox)/ExtentX,ExtentY,ExtentZ/g" $@.txt > $@

