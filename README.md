### LiverSegmentationExample :grimacing:

### Usage

* make -f prediction.makefile segmentation
* make -f prediction.makefile volume
* make -f prediction.makefile png

An example image set from a single study needed as input to the random
forest models is shown below.

Mask.nii.gz  | Pre.nii.gz  | Art.nii.gz  | Ven.nii.gz | Del.nii.gz  
-----------  | ----------- | ----------  | ---------- | ----------
![mask](/DataSetupREADME/pdffig/mask.png) | ![pre](/DataSetupREADME/pdffig/precontrast.png) | ![art](/DataSetupREADME/pdffig/arterial.png) | ![ven](/DataSetupREADME/pdffig/venous.png) | ![del](/DataSetupREADME/pdffig/delay.png)

Each image set should be in a separate directory and should follow
the below naming convention *exactly*:
```
$ ls ImageDatabase/Predict0001/before/
Art.nii.gz  Del.nii.gz  Mask.nii.gz  Pre.nii.gz  Ven.nii.gz
```
