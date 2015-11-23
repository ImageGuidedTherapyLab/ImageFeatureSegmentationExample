WORKDIR=$(WORK)/github/RandomForestHCCResponse/Code/workdir
DATADIR=$(WORK)/github/RandomForestHCCResponse/Code/HCCDatabase
ATROPOSCMD=$(ANTSPATH)/Atropos
C3DEXE=c3d
ANTSREGISTRATIONCMD=$(ANTSPATH)/antsRegistration
ANTSAPPLYTRANSFORMSCMD=$(ANTSPATH)/antsApplyTransforms
ANTSIMAGEMATHCMD=$(ANTSPATH)/ImageMath
PNGSLICE=python $(WORK)/github/RandomForestHCCResponse/Code/viewsoln.py --labelfile=$(WORK)/github/RandomForestHCCResponse/Code/dfltlabels.txt 
IDMODEL=00000130
PREDICTLIST = Predict0001 
$(WORKDIR)/Predict0001/%/LABELS.GMM.nii.gz: $(WORKDIR)/%.GMM.RFModel
	mkdir -p $(WORKDIR)/Predict0001/$*;  cd $(WORKDIR)/Predict0001; ../../applyTumorSegmentationModel.sh  -d 3 -x $(DATADIR)/Predict0001/Mask.$(lastword $(subst ., ,$*)).nii.gz         -l 1 -n Pre -a $(DATADIR)/Predict0001/Pre.$(lastword $(subst ., ,$*)).nii.gz  -n Art -a $(DATADIR)/Predict0001/Art.$(lastword $(subst ., ,$*)).nii.gz  -n Ven -a $(DATADIR)/Predict0001/Ven.$(lastword $(subst ., ,$*)).nii.gz -n Del -a $(DATADIR)/Predict0001/Del.$(lastword $(subst ., ,$*)).nii.gz  -r 1 -r 3 -r 5 -s 2 -b 3  -o $(WORKDIR)/Predict0001/texture$(lastword $(subst ., ,$*)) -k $(WORKDIR)/Predict0001/$*/ -m $<  
	cd $(WORKDIR)/Predict0001/$*/; $(ANTSIMAGEMATHCMD) 3 LABELS.GMM.nii.gz MostLikely 0 RF_POSTERIORS*.nii.gz  
$(WORKDIR)/Predict0001/%/LABELS.GMM.png: $(WORKDIR)/Predict0001/%/LABELS.GMM.nii.gz
	cd $(WORKDIR)/Predict0001/$*/; $(PNGSLICE) --rfimage=LABELS.GMM.nii.gz --maskimage=$(DATADIR)/Predict0001/Mask.$(lastword $(subst ., ,$*)).nii.gz 

