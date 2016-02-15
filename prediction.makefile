ROOTDIR=$(WORK)/github/LiverSegmentationExample
WORKDIR=$(ROOTDIR)/workdir
DATADIR=$(ROOTDIR)/ImageDatabase
SCRIPTSPATH=$(ROOTDIR)/Code
ATROPOSCMD=$(ANTSPATH)/Atropos
C3DEXE=c3d
ANTSREGISTRATIONCMD=$(ANTSPATH)/antsRegistration
ANTSAPPLYTRANSFORMSCMD=$(ANTSPATH)/antsApplyTransforms
ANTSIMAGEMATHCMD=$(ANTSPATH)/ImageMath
PNGSLICE=python $(SCRIPTSPATH)/viewsoln.py --labelfile=$(SCRIPTSPATH)/dfltlabels.txt 
RFMODEL=FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel

# new cases automagically added
SUBDIRS := $(shell find ImageDatabase/ -mindepth 2 -links 2 -type d -print | cut -d'/' -f 2-)

trifeature: $(addsuffix /$(RFMODEL)/LABELS.TRIGMM.nii.gz,$(addprefix $(WORKDIR)/,$(SUBDIRS)))
# TODO
#segmentation: $(addsuffix /$(RFMODEL)/LABELS.GMM.nii.gz,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))
#volume: $(addsuffix /$(RFMODEL)/LABELS.GMM.VolStat.csv,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))
#png: $(addsuffix /$(RFMODEL)/LABELS.GMM.png,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))


$(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz: $(WORKDIR)/$(RFMODEL)
	export SCRIPTSPATH=$(SCRIPTSPATH); mkdir -p $(WORKDIR)/$*/$(RFMODEL);  cd $(WORKDIR)/$*; $(SCRIPTSPATH)/applyTumorSegmentationModel.sh  -d 3 -x $(DATADIR)/$*/Mask.nii.gz         -l 1 -n Pre -a $(DATADIR)/$*/Pre.nii.gz  -n Art -a $(DATADIR)/$*/Art.nii.gz  -n Ven -a $(DATADIR)/$*/Ven.nii.gz -n Del -a $(DATADIR)/$*/Del.nii.gz  -r 1 -r 3 -r 5 -s 2 -b 3  -o $(WORKDIR)/$*/texture -k $(WORKDIR)/$*/$(RFMODEL)/ -m $<  

$(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.VolStat.csv: $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); c3d LABELS.GMM.nii.gz LABELS.GMM.nii.gz -lstat > LABELS.GMM.VolStat.txt ; sed "s/\s\+/,/g" LABELS.GMM.VolStat.txt > LABELS.GMM.VolStat.csv 
$(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.png: $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Pre.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Art.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Ven.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Del.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Mask.nii.gz --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=./LABELS.GMM.nii.gz --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz


$(WORKDIR)/%/Mask.centroid.txt : $(DATADIR)/%/Mask.nii.gz 
	python Code/slicecentroid.py --imagefile=$< > $@

#run mixture model to segment the image
#https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
#https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html#Secondary-Expansion
.SECONDEXPANSION:
$(WORKDIR)/%/$(RFMODEL)/LABELS.TRIGMM.nii.gz: $(WORKDIR)/$(RFMODEL) $(DATADIR)/$$*/Mask.nii.gz $(DATADIR)/$$*/Art.nii.gz $(DATADIR)/$$*/Ven.nii.gz $(DATADIR)/$$*/Del.nii.gz $(WORKDIR)/$$*/Mask.centroid.txt 
	export SCRIPTSPATH=$(SCRIPTSPATH); mkdir -p $(WORKDIR)/$*/$(RFMODEL);  $(SCRIPTSPATH)/applyTumorSegmentationModel.sh  -d 3 -x $(word 2,$^)  -l 1  -n Art -a $(word 3,$^)  -n Ven -a $(word 4,$^) -n Del -a $(word 5,$^) -r 1 -r 3 -r 5 -s 2 -b 3  -o $(WORKDIR)/$*/texture -k $(WORKDIR)/$*/$(RFMODEL)/ -m $<  -e `cat $(word 6,$^)`

