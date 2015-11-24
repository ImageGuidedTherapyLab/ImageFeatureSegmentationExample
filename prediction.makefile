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
# TODO - add additional cases here
#PREDICTLIST = Predict0001/before Predict0091/genomic
PREDICTLIST = Predict0001/before
segmentation: $(addsuffix /$(RFMODEL)/LABELS.GMM.nii.gz,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))
volume: $(addsuffix /$(RFMODEL)/LABELS.GMM.VolStat.csv,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))
png: $(addsuffix /$(RFMODEL)/LABELS.GMM.png,$(addprefix $(WORKDIR)/,$(PREDICTLIST)))


$(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz: $(WORKDIR)/$(RFMODEL)
	export SCRIPTSPATH=$(SCRIPTSPATH); mkdir -p $(WORKDIR)/$*/$(RFMODEL);  cd $(WORKDIR)/$*; $(SCRIPTSPATH)/applyTumorSegmentationModel.sh  -d 3 -x $(DATADIR)/$*/Mask.nii.gz         -l 1 -n Pre -a $(DATADIR)/$*/Pre.nii.gz  -n Art -a $(DATADIR)/$*/Art.nii.gz  -n Ven -a $(DATADIR)/$*/Ven.nii.gz -n Del -a $(DATADIR)/$*/Del.nii.gz  -r 1 -r 3 -r 5 -s 2 -b 3  -o $(WORKDIR)/$*/texture -k $(WORKDIR)/$*/$(RFMODEL)/ -m $<  
	cd $(WORKDIR)/$*/$(RFMODEL); $(ANTSIMAGEMATHCMD) 3 LABELS.GMM.nii.gz MostLikely 0 RF_POSTERIORS*.nii.gz  
$(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.VolStat.csv: $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); c3d LABELS.GMM.nii.gz LABELS.GMM.nii.gz -lstat > LABELS.GMM.VolStat.txt ; sed "s/\s\+/,/g" LABELS.GMM.VolStat.txt > LABELS.GMM.VolStat.csv 
$(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.png: $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Pre.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Art.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Ven.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Del.nii.gz  --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=$(DATADIR)/$*/Mask.nii.gz --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
	cd $(WORKDIR)/$*/$(RFMODEL); $(PNGSLICE) --rfimage=./LABELS.GMM.nii.gz --maskimage=$(DATADIR)/$*/Mask.nii.gz --truthimage=LABELS.GMM.nii.gz
