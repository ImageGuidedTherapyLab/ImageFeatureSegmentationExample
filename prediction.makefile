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
segmentation: $(WORKDIR)/Predict0001/before/$(RFMODEL)/LABELS.GMM.nii.gz

$(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz: $(WORKDIR)/$(RFMODEL)
	export SCRIPTSPATH=$(SCRIPTSPATH); mkdir -p $(WORKDIR)/$*;  cd $(WORKDIR)/$*; $(SCRIPTSPATH)/applyTumorSegmentationModel.sh  -d 3 -x $(DATADIR)/$*/Mask.nii.gz         -l 1 -n Pre -a $(DATADIR)/$*/Pre.nii.gz  -n Art -a $(DATADIR)/$*/Art.nii.gz  -n Ven -a $(DATADIR)/$*/Ven.nii.gz -n Del -a $(DATADIR)/$*/Del.nii.gz  -r 1 -r 3 -r 5 -s 2 -b 3  -o $(WORKDIR)/$*/texture -k $(WORKDIR)/$*/$*/ -m $<  
	cd $(WORKDIR)/Predict0001/$*/; $(ANTSIMAGEMATHCMD) 3 LABELS.GMM.nii.gz MostLikely 0 RF_POSTERIORS*.nii.gz  
$(WORKDIR)/Predict0001/%/LABELS.GMM.png: $(WORKDIR)/Predict0001/%/LABELS.GMM.nii.gz
	cd $(WORKDIR)/Predict0001/$*/; $(PNGSLICE) --rfimage=LABELS.GMM.nii.gz --maskimage=$(DATADIR)/Predict0001/Mask.$(lastword $(subst ., ,$*)).nii.gz 

