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

### Example Segmentation
Output images are organized with respect to the model used for the
segmentation $(WORKDIR)/%/$(RFMODEL)/LABELS.GMM.nii.gz

RF Output   | Mask.nii.gz  | Pre.nii.gz  | Art.nii.gz  | Ven.nii.gz | Del.nii.gz  
----------- | -----------  | ----------- | ----------  | ---------- | ----------
![rf](/DataSetupREADME/pdffig/LABELS.GMM.png) | ![mask](/DataSetupREADME/pdffig/Mask.png) | ![pre](/DataSetupREADME/pdffig/Pre.png) | ![art](/DataSetupREADME/pdffig/Art.png) | ![ven](/DataSetupREADME/pdffig/Ven.png) | ![del](/DataSetupREADME/pdffig/Del.png)

```
innovador$ make -f prediction.makefile segmentation
export SCRIPTSPATH=/workarea/fuentes/github/LiverSegmentationExample/Code; mkdir -p /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel;  cd /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before; /workarea/fuentes/github/LiverSegmentationExample/Code/applyTumorSegmentationModel.sh  -d 3 -x /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Mask.nii.gz         -l 1 -n Pre -a /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Pre.nii.gz  -n Art -a /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Art.nii.gz  -n Ven -a /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Ven.nii.gz -n Del -a /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Del.nii.gz  -r 1 -r 3 -r 5 -s 2 -b 3  -o /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texture -k /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel/ -m /workarea/fuentes/github/LiverSegmentationExample/workdir/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel  

    Using applyTumorSegmentationModel with the following arguments:
      image dimension         = 3
      anatomical image        = /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Pre.nii.gz /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Art.nii.gz /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Ven.nii.gz /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Del.nii.gz
      symmetric templates     = 
      cluster centers         = 
      image names             = Pre Art Ven Del
      radii                   = 1 3 5
      smoothing sigma         = 2
      priors                  = 
      difference pairs        = 
      output prefix           = /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texture

---------------------  Running applyTumorSegmentationModel.sh on innovador  ---------------------
######################################################################################
Create feature images
######################################################################################
/bin/bash /workarea/fuentes/github/LiverSegmentationExample/Code/createFeatureImages.sh -d 3 -x /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Mask.nii.gz -o /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texture -a /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Pre.nii.gz -n Pre -a /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Art.nii.gz -n Art -a /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Ven.nii.gz -n Ven -a /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Del.nii.gz -n Del -b 3 -r 1 -r 3 -r 5 -s 2 -l 1
python /workarea/fuentes/github/RandomForestHCCResponse/Code/slicecentroid.py --imagefile=/workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Mask.nii.gz
centroid 48
BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Mask.nii.gz -erode 1 3x3x0vox -o /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.png
END   <<<<<<<<<<<<<<<<<<<<



    Using createFeatureImages with the following arguments:
      image dimension         = 3
      anatomical image        = /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Pre.nii.gz /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Art.nii.gz /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Ven.nii.gz /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Del.nii.gz
      symmetric templates     = 
      symmetric template mask = 
      cluster centers         = 
      image names             = Pre Art Ven Del
      radii                   = 1 3 5
      smoothing sigma         = 2
      priors                  = 
      difference pairs        = 
      output prefix           = /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texture

---------------------  Running createFeatureImages.sh on innovador  ---------------------
BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz TruncateImageIntensity /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Pre.nii.gz 0.01 0.99 200
Lower quantile: 4.92341
Upper quantile: 98.548
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_RAWIMAGE.nii.gz m /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz
operation m
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/TotalVariationDenoisingImage /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_RAWIMAGE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz .1 10 4
Iteration 1/10
Iteration 2/10
Iteration 3/10
Iteration 4/10
Iteration 5/10
Iteration 6/10
Iteration 7/10
Iteration 8/10
Iteration 9/10
Iteration 10/10
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Pre.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/GradientMagnitudeImageFilter /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_GRADIENT.nii.gz
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_GRADIENT.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map jet -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_GRADIENT.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_RESCALE.nii.gz RescaleImage /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 0 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz TruncateImageIntensity /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Art.nii.gz 0.01 0.99 200
Lower quantile: 11.731
Upper quantile: 210.617
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_RAWIMAGE.nii.gz m /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz
operation m
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/TotalVariationDenoisingImage /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_RAWIMAGE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz .1 10 4
Iteration 1/10
Iteration 2/10
Iteration 3/10
Iteration 4/10
Iteration 5/10
Iteration 6/10
Iteration 7/10
Iteration 8/10
Iteration 9/10
Iteration 10/10
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Art.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/GradientMagnitudeImageFilter /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_GRADIENT.nii.gz
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_GRADIENT.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map jet -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_GRADIENT.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_RESCALE.nii.gz RescaleImage /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 0 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz TruncateImageIntensity /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Ven.nii.gz 0.01 0.99 200
Lower quantile: 22.4022
Upper quantile: 291.805
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_RAWIMAGE.nii.gz m /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz
operation m
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/TotalVariationDenoisingImage /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_RAWIMAGE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz .1 10 4
Iteration 1/10
Iteration 2/10
Iteration 3/10
Iteration 4/10
Iteration 5/10
Iteration 6/10
Iteration 7/10
Iteration 8/10
Iteration 9/10
Iteration 10/10
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Ven.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/GradientMagnitudeImageFilter /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_GRADIENT.nii.gz
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_GRADIENT.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map jet -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_GRADIENT.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_RESCALE.nii.gz RescaleImage /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 0 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz TruncateImageIntensity /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Del.nii.gz 0.01 0.99 200
Lower quantile: 28.6886
Upper quantile: 199.64
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_RAWIMAGE.nii.gz m /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz
operation m
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/TotalVariationDenoisingImage /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_RAWIMAGE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz .1 10 4
Iteration 1/10
Iteration 2/10
Iteration 3/10
Iteration 4/10
Iteration 5/10
Iteration 6/10
Iteration 7/10
Iteration 8/10
Iteration 9/10
Iteration 10/10
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Del.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/GradientMagnitudeImageFilter /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_GRADIENT.nii.gz
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_GRADIENT.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map jet -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_GRADIENT.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_RESCALE.nii.gz RescaleImage /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 0 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//Atropos -d 3 -a /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz -a /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz -a /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz -a /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz -i KMeans[3] -p Socrates[1] -x /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz -c [3,0] -k Gaussian -m [0.1,1x1x1] -o [/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureALL_ATROPOS_GMM.nii.gz,/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureALL_ATROPOS_GMM_POSTERIORS%d.nii.gz]

Running Atropos for 3-dimensional images.

Progress: 
  Iteration 0 (of 3): posterior probability = 0 (annealing temperature = 1)
  Iteration 1 (of 3): posterior probability = 0.927787 (annealing temperature = 1)

Writing output:
  Writing posterior image (class 1)
  Writing posterior image (class 2)
  Writing posterior image (class 3)

  AtroposSegmentationImageFilter (0x35be6a0)
    RTTI typeinfo:   itk::ants::AtroposSegmentationImageFilter<itk::Image<float, 3u>, itk::Image<unsigned int, 3u>, itk::Image<unsigned int, 3u> >
    Reference Count: 1
    Modified Time: 24763652
    Debug: Off
    Object Name: 
    Observers: 
      IterationEvent(Command)
    Inputs: 
      Primary: (0x35cb720) *
      _1: (0x35c86d0)
      _2: (0)
      _3: (0x35cbc00)
      _4: (0x35d36b0)
      _5: (0x35d69b0)
    Indexed Inputs: 
      0: Primary (0x35cb720)
      1: _1 (0x35c86d0)
      2: _2 (0)
      3: _3 (0x35cbc00)
      4: _4 (0x35d36b0)
      5: _5 (0x35d69b0)
    Required Input Names: Primary
    NumberOfRequiredInputs: 1
    Outputs: 
      Primary: (0xcd03f70)
    Indexed Outputs: 
      0: Primary (0xcd03f70)
    NumberOfRequiredOutputs: 1
    Number Of Threads: 24
    ReleaseDataFlag: Off
    ReleaseDataBeforeUpdateFlag: Off
    AbortGenerateData: Off
    Progress: 0
    Multithreader: 
      RTTI typeinfo:   itk::MultiThreader
      Reference Count: 1
      Modified Time: 201
      Debug: Off
      Object Name: 
      Observers: 
        none
      Thread Count: 24
      Global Maximum Number Of Threads: 128
      Global Default Number Of Threads: 24
    CoordinateTolerance: 1e-06
    DirectionTolerance: 1e-06
    Maximum number of iterations: 3
    Convergence threshold: 0
    Mask label: 1
    Number of tissue classes: 3
    Number of partial volume classes: 0
    Minimize memory usage: false
    Initialization strategy: K means clustering
    Posterior probability formulation: Socrates
      initial annealing temperature = 1
      annealing rate = 1
      minimum annealing temperature = 0.1
    MRF parameters
      MRF smoothing factor = 0.1
      MRF radius = [1, 1, 1]
    Use asynchronous updating of the labels.
      ICM parameters
        maximum ICM code = 13
        maximum number of ICM iterations = 1
    No outlier handling.
    Tissue class 1: proportion = 0.113572
      GaussianListSampleFunction (0x35ce640)
        mean = [20.247511619853867, 62.830234531493744, 130.742753798021, 104.81860343827118], covariance = [170.423, 135.114, 42.4748, 41.2019; 135.114, 969.003, 857.969, 358.473; 42.4748, 857.969, 3197.68, 981.817; 41.2019, 358.473, 981.817, 958.299]
    Tissue class 2: proportion = 0.35158
      GaussianListSampleFunction (0x35cbec0)
        mean = [38.719134389124264, 99.01839596080245, 154.70450786751667, 118.06995289856432], covariance = [39.8733, 67.3966, 48.271, 14.598; 67.3966, 1367.55, 942.452, 401.79; 48.271, 942.452, 2536.03, 933.964; 14.598, 401.79, 933.964, 739.593]
    Tissue class 3: proportion = 0.534351
      GaussianListSampleFunction (0x35d7e60)
        mean = [50.08857647032519, 88.53461968640492, 192.98343826856376, 122.64284556259045], covariance = [42.4123, -1.80766, 18.7124, 5.10375; -1.80766, 260.679, -48.3559, 22.6462; 18.7124, -48.3559, 461.408, 126.509; 5.10375, 22.6462, 126.509, 166.268]
Elapsed time: 167.05
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureALL_ATROPOS_GMM.nii.gz -slice z 48 -dup -oli /workarea/fuentes/github/RandomForestHCCResponse/Code/dfltlabels.txt 1.0 -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureALL_ATROPOS_GMM.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texture_DENOISE.nii.gz
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/FitCTContrastTransportModel /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texture_DENOISE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISE
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEPreArtDeriv.nii.gz -slice z 48 -clip -inf inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEPreArtDeriv.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEArtVenDeriv.nii.gz -slice z 48 -clip -inf inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEArtVenDeriv.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEVenDelDeriv.nii.gz -slice z 48 -clip -inf inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEVenDelDeriv.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEAreaUnderCurve.nii.gz -slice z 48 -clip -inf inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEAreaUnderCurve.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEArtDelDeriv.nii.gz -slice z 48 -clip -inf inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDENOISEArtDelDeriv.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 0 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_1.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 4 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_1.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 5 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 7 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 0 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_3.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 4 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_3.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 5 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 7 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 0 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_5.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_MEAN_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 4 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_5.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SIGMA_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 5 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_5.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_SKEWNESS_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz 7 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_5.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ENTROPY_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 0 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_1.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 4 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_1.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 5 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 7 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 0 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_3.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 4 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_3.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 5 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 7 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 0 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_5.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_MEAN_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 4 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_5.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SIGMA_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 5 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_5.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_SKEWNESS_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz 7 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_5.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ENTROPY_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 0 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_1.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 4 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_1.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 5 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 7 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 0 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_3.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 4 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_3.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 5 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 7 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 0 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_5.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_MEAN_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 4 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_5.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SIGMA_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 5 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_5.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_SKEWNESS_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz 7 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_5.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ENTROPY_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 0 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_1.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 4 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_1.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 5 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_1.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 7 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 0 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_3.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 4 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_3.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 5 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_3.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 7 3
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 0 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_5.nii.gz -slice z 48 -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_MEAN_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 4 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_5.nii.gz -slice z 48 -clip 0 25 -pad 1x0x0vox 0x0x0vox 25 -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SIGMA_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 5 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_5.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_SKEWNESS_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_5.nii.gz NeighborhoodStats /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz 7 5
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_5.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ENTROPY_RADIUS_5.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz 0
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz m /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz
operation m
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz Normalize /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
echo -c [0,0] impose no spatial regularization ??
-c [0,0] impose no spatial regularization ??
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//Atropos -d 3 -a /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_DENOISE.nii.gz -i KMeans[3] -p Socrates[1] -x /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz -c [0,0] -k Gaussian -m [0.1,1x1x1] -o [/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM.nii.gz,/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_POSTERIORS%d.nii.gz]

Running Atropos for 3-dimensional images.

Progress: 

Writing output:
  Writing posterior image (class 1)
  Writing posterior image (class 2)
  Writing posterior image (class 3)

  AtroposSegmentationImageFilter (0x22ba630)
    RTTI typeinfo:   itk::ants::AtroposSegmentationImageFilter<itk::Image<float, 3u>, itk::Image<unsigned int, 3u>, itk::Image<unsigned int, 3u> >
    Reference Count: 1
    Modified Time: 678
    Debug: Off
    Object Name: 
    Observers: 
      IterationEvent(Command)
    Inputs: 
      Primary: (0x22c7690) *
      _1: (0x22c4660)
    Indexed Inputs: 
      0: Primary (0x22c7690)
      1: _1 (0x22c4660)
    Required Input Names: Primary
    NumberOfRequiredInputs: 1
    Outputs: 
      Primary: (0x22beca0)
    Indexed Outputs: 
      0: Primary (0x22beca0)
    NumberOfRequiredOutputs: 1
    Number Of Threads: 24
    ReleaseDataFlag: Off
    ReleaseDataBeforeUpdateFlag: Off
    AbortGenerateData: Off
    Progress: 0
    Multithreader: 
      RTTI typeinfo:   itk::MultiThreader
      Reference Count: 1
      Modified Time: 189
      Debug: Off
      Object Name: 
      Observers: 
        none
      Thread Count: 24
      Global Maximum Number Of Threads: 128
      Global Default Number Of Threads: 24
    CoordinateTolerance: 1e-06
    DirectionTolerance: 1e-06
    Maximum number of iterations: 0
    Convergence threshold: 0
    Mask label: 1
    Number of tissue classes: 3
    Number of partial volume classes: 0
    Minimize memory usage: false
    Initialization strategy: K means clustering
    Posterior probability formulation: Socrates
      initial annealing temperature = 1
      annealing rate = 1
      minimum annealing temperature = 0.1
    MRF parameters
      MRF smoothing factor = 0.1
      MRF radius = [1, 1, 1]
    Use asynchronous updating of the labels.
      ICM parameters
        maximum ICM code = 0
        maximum number of ICM iterations = 1
    No outlier handling.
    Tissue class 1: proportion = 0.0775653
      GaussianListSampleFunction (0x22c7eb0)
        mean = [13.523450741698793], covariance = [62.8813]
    Tissue class 2: proportion = 0.406266
      GaussianListSampleFunction (0x22c7950)
        mean = [37.344187684556864], covariance = [24.3912]
    Tissue class 3: proportion = 0.516169
      GaussianListSampleFunction (0x22cddb0)
        mean = [51.26667187828106], covariance = [34.5574]
Elapsed time: 11.2962
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/CannyEdgeDetectionImageFilter /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_CANNY.nii.gz
Variance = 2
UpperThreshold = 0
LowerThreshold = 0
CannyEdgeDetectionImageFilter (0x36e01d0)
  RTTI typeinfo:   itk::CannyEdgeDetectionImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u> >
  Reference Count: 1
  Modified Time: 701
  Debug: Off
  Object Name: 
  Observers: 
    none
  Inputs: 
    Primary: (0x36d6f60) *
  Indexed Inputs: 
    0: Primary (0x36d6f60)
  Required Input Names: Primary
  NumberOfRequiredInputs: 1
  Outputs: 
    Primary: (0x36e48a0)
  Indexed Outputs: 
    0: Primary (0x36e48a0)
  NumberOfRequiredOutputs: 1
  Number Of Threads: 24
  ReleaseDataFlag: Off
  ReleaseDataBeforeUpdateFlag: Off
  AbortGenerateData: Off
  Progress: 1
  Multithreader: 
    RTTI typeinfo:   itk::MultiThreader
    Reference Count: 1
    Modified Time: 64
    Debug: Off
    Object Name: 
    Observers: 
      none
    Thread Count: 24
    Global Maximum Number Of Threads: 128
    Global Default Number Of Threads: 24
  CoordinateTolerance: 1e-06
  DirectionTolerance: 1e-06
Variance: [2, 2, 2]
MaximumError: [0.01, 0.01, 0.01]
  UpperThreshold: 0
  LowerThreshold: 0
Center: 13
Stride: 0x36e0510
  GaussianFilter: 
    DiscreteGaussianImageFilter (0x36e4c80)
      RTTI typeinfo:   itk::DiscreteGaussianImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u> >
      Reference Count: 1
      Modified Time: 436
      Debug: Off
      Object Name: 
      Observers: 
        none
      Inputs: 
        Primary: (0x36d6f60) *
      Indexed Inputs: 
        0: Primary (0x36d6f60)
      Required Input Names: Primary
      NumberOfRequiredInputs: 1
      Outputs: 
        Primary: (0x36e9180)
      Indexed Outputs: 
        0: Primary (0x36e9180)
      NumberOfRequiredOutputs: 1
      Number Of Threads: 24
      ReleaseDataFlag: Off
      ReleaseDataBeforeUpdateFlag: Off
      AbortGenerateData: Off
      Progress: 1
      Multithreader: 
        RTTI typeinfo:   itk::MultiThreader
        Reference Count: 1
        Modified Time: 75
        Debug: Off
        Object Name: 
        Observers: 
          none
        Thread Count: 24
        Global Maximum Number Of Threads: 128
        Global Default Number Of Threads: 24
      CoordinateTolerance: 1e-06
      DirectionTolerance: 1e-06
      Variance: [2, 2, 2]
      MaximumError: [0.01, 0.01, 0.01]
      MaximumKernelWidth: 32
      FilterDimensionality: 3
      UseImageSpacing: 1
      InternalNumberOfStreamDivisions: 9
  MultiplyImageFilter: 
    MultiplyImageFilter (0x36e9560)
      RTTI typeinfo:   itk::MultiplyImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u>, itk::Image<float, 3u> >
      Reference Count: 1
      Modified Time: 693
      Debug: Off
      Object Name: 
      Observers: 
        none
      Inputs: 
        Primary: (0x36eddb0) *
        _1: (0x36ef160)
      Indexed Inputs: 
        0: Primary (0x36eddb0)
        1: _1 (0x36ef160)
      Required Input Names: Primary
      NumberOfRequiredInputs: 2
      Outputs: 
        Primary: (0x36eda30)
      Indexed Outputs: 
        0: Primary (0x36eda30)
      NumberOfRequiredOutputs: 1
      Number Of Threads: 24
      ReleaseDataFlag: Off
      ReleaseDataBeforeUpdateFlag: Off
      AbortGenerateData: Off
      Progress: 1
      Multithreader: 
        RTTI typeinfo:   itk::MultiThreader
        Reference Count: 1
        Modified Time: 86
        Debug: Off
        Object Name: 
        Observers: 
          none
        Thread Count: 24
        Global Maximum Number Of Threads: 128
        Global Default Number Of Threads: 24
      CoordinateTolerance: 1e-06
      DirectionTolerance: 1e-06
      InPlace: Off
      The input and output to this filter are the same type. The filter can be run in place.
  UpdateBuffer1: 
    Image (0x36eddb0)
      RTTI typeinfo:   itk::Image<float, 3u>
      Reference Count: 2
      Modified Time: 431
      Debug: Off
      Object Name: 
      Observers: 
        none
      Source: (none)
      Source output name: (none)
      Release Data: Off
      Data Released: False
      Global Release Data: Off
      PipelineMTime: 0
      UpdateMTime: 0
      RealTimeStamp: 0 seconds 
      LargestPossibleRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      BufferedRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      RequestedRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      Spacing: [0.664062, 0.664062, 2.5]
      Origin: [170, 170, -450]
      Direction: 
-1 0 0
0 -1 0
0 0 1

      IndexToPointMatrix: 
-0.664062 0 0
0 -0.664062 0
0 0 2.5

      PointToIndexMatrix: 
-1.50588 0 0
0 -1.50588 0
0 0 0.4

      Inverse Direction: 
-1 0 0
0 -1 0
0 0 1

      PixelContainer: 
        ImportImageContainer (0x36ee070)
          RTTI typeinfo:   itk::ImportImageContainer<unsigned long, float>
          Reference Count: 1
          Modified Time: 432
          Debug: Off
          Object Name: 
          Observers: 
            none
          Pointer: 0x2aece563f010
          Container manages memory: true
          Size: 24379392
          Capacity: 24379392
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//GetConnectedComponentsFeatureImages 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
echo /opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ThresholdImage 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1 1 1 0
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ThresholdImage 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1 1 1 0
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM.nii.gz -thresh 1 1 1 0 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz -thresh .17 inf 1 0 -multiply -comp -thresh 1 1 1 0 -o /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz
  There are 312 connected components.
  Largest component has 4879 pixels.
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_CANNY.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_CANNY.nii.gz 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM.nii.gz -slice z 48 -dup -oli /workarea/fuentes/github/RandomForestHCCResponse/Code/dfltlabels.txt 1.0 -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_PHYSICAL_VOLUME.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_PHYSICAL_VOLUME.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_ECCENTRICITY.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_ECCENTRICITY.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_ELONGATION.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_ELONGATION.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_CANNY.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_CANNY.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_POSTERIORS1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_POSTERIORS1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_POSTERIORS2.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_POSTERIORS2.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_POSTERIORS3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texturePre_ATROPOS_GMM_POSTERIORS3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
echo -c [0,0] impose no spatial regularization ??
-c [0,0] impose no spatial regularization ??
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//Atropos -d 3 -a /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_DENOISE.nii.gz -i KMeans[3] -p Socrates[1] -x /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz -c [0,0] -k Gaussian -m [0.1,1x1x1] -o [/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM.nii.gz,/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_POSTERIORS%d.nii.gz]

Running Atropos for 3-dimensional images.

Progress: 

Writing output:
  Writing posterior image (class 1)
  Writing posterior image (class 2)
  Writing posterior image (class 3)

  AtroposSegmentationImageFilter (0x2bf0630)
    RTTI typeinfo:   itk::ants::AtroposSegmentationImageFilter<itk::Image<float, 3u>, itk::Image<unsigned int, 3u>, itk::Image<unsigned int, 3u> >
    Reference Count: 1
    Modified Time: 678
    Debug: Off
    Object Name: 
    Observers: 
      IterationEvent(Command)
    Inputs: 
      Primary: (0x2bfd690) *
      _1: (0x2bfa660)
    Indexed Inputs: 
      0: Primary (0x2bfd690)
      1: _1 (0x2bfa660)
    Required Input Names: Primary
    NumberOfRequiredInputs: 1
    Outputs: 
      Primary: (0x2bf4ca0)
    Indexed Outputs: 
      0: Primary (0x2bf4ca0)
    NumberOfRequiredOutputs: 1
    Number Of Threads: 24
    ReleaseDataFlag: Off
    ReleaseDataBeforeUpdateFlag: Off
    AbortGenerateData: Off
    Progress: 0
    Multithreader: 
      RTTI typeinfo:   itk::MultiThreader
      Reference Count: 1
      Modified Time: 189
      Debug: Off
      Object Name: 
      Observers: 
        none
      Thread Count: 24
      Global Maximum Number Of Threads: 128
      Global Default Number Of Threads: 24
    CoordinateTolerance: 1e-06
    DirectionTolerance: 1e-06
    Maximum number of iterations: 0
    Convergence threshold: 0
    Mask label: 1
    Number of tissue classes: 3
    Number of partial volume classes: 0
    Minimize memory usage: false
    Initialization strategy: K means clustering
    Posterior probability formulation: Socrates
      initial annealing temperature = 1
      annealing rate = 1
      minimum annealing temperature = 0.1
    MRF parameters
      MRF smoothing factor = 0.1
      MRF radius = [1, 1, 1]
    Use asynchronous updating of the labels.
      ICM parameters
        maximum ICM code = 0
        maximum number of ICM iterations = 1
    No outlier handling.
    Tissue class 1: proportion = 0.202179
      GaussianListSampleFunction (0x2bfdeb0)
        mean = [52.754389810451244], covariance = [226.96]
    Tissue class 2: proportion = 0.635699
      GaussianListSampleFunction (0x2bfd950)
        mean = [88.52434997019799], covariance = [117.471]
    Tissue class 3: proportion = 0.162122
      GaussianListSampleFunction (0x2c03db0)
        mean = [137.94951324607055], covariance = [433.537]
Elapsed time: 11.0461
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/CannyEdgeDetectionImageFilter /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_CANNY.nii.gz
Variance = 2
UpperThreshold = 0
LowerThreshold = 0
CannyEdgeDetectionImageFilter (0x2c991d0)
  RTTI typeinfo:   itk::CannyEdgeDetectionImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u> >
  Reference Count: 1
  Modified Time: 701
  Debug: Off
  Object Name: 
  Observers: 
    none
  Inputs: 
    Primary: (0x2c8ff60) *
  Indexed Inputs: 
    0: Primary (0x2c8ff60)
  Required Input Names: Primary
  NumberOfRequiredInputs: 1
  Outputs: 
    Primary: (0x2c9d8a0)
  Indexed Outputs: 
    0: Primary (0x2c9d8a0)
  NumberOfRequiredOutputs: 1
  Number Of Threads: 24
  ReleaseDataFlag: Off
  ReleaseDataBeforeUpdateFlag: Off
  AbortGenerateData: Off
  Progress: 1
  Multithreader: 
    RTTI typeinfo:   itk::MultiThreader
    Reference Count: 1
    Modified Time: 64
    Debug: Off
    Object Name: 
    Observers: 
      none
    Thread Count: 24
    Global Maximum Number Of Threads: 128
    Global Default Number Of Threads: 24
  CoordinateTolerance: 1e-06
  DirectionTolerance: 1e-06
Variance: [2, 2, 2]
MaximumError: [0.01, 0.01, 0.01]
  UpperThreshold: 0
  LowerThreshold: 0
Center: 13
Stride: 0x2c99510
  GaussianFilter: 
    DiscreteGaussianImageFilter (0x2c9dc80)
      RTTI typeinfo:   itk::DiscreteGaussianImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u> >
      Reference Count: 1
      Modified Time: 436
      Debug: Off
      Object Name: 
      Observers: 
        none
      Inputs: 
        Primary: (0x2c8ff60) *
      Indexed Inputs: 
        0: Primary (0x2c8ff60)
      Required Input Names: Primary
      NumberOfRequiredInputs: 1
      Outputs: 
        Primary: (0x2ca2180)
      Indexed Outputs: 
        0: Primary (0x2ca2180)
      NumberOfRequiredOutputs: 1
      Number Of Threads: 24
      ReleaseDataFlag: Off
      ReleaseDataBeforeUpdateFlag: Off
      AbortGenerateData: Off
      Progress: 1
      Multithreader: 
        RTTI typeinfo:   itk::MultiThreader
        Reference Count: 1
        Modified Time: 75
        Debug: Off
        Object Name: 
        Observers: 
          none
        Thread Count: 24
        Global Maximum Number Of Threads: 128
        Global Default Number Of Threads: 24
      CoordinateTolerance: 1e-06
      DirectionTolerance: 1e-06
      Variance: [2, 2, 2]
      MaximumError: [0.01, 0.01, 0.01]
      MaximumKernelWidth: 32
      FilterDimensionality: 3
      UseImageSpacing: 1
      InternalNumberOfStreamDivisions: 9
  MultiplyImageFilter: 
    MultiplyImageFilter (0x2ca2560)
      RTTI typeinfo:   itk::MultiplyImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u>, itk::Image<float, 3u> >
      Reference Count: 1
      Modified Time: 693
      Debug: Off
      Object Name: 
      Observers: 
        none
      Inputs: 
        Primary: (0x2ca6db0) *
        _1: (0x2ca8160)
      Indexed Inputs: 
        0: Primary (0x2ca6db0)
        1: _1 (0x2ca8160)
      Required Input Names: Primary
      NumberOfRequiredInputs: 2
      Outputs: 
        Primary: (0x2ca6a30)
      Indexed Outputs: 
        0: Primary (0x2ca6a30)
      NumberOfRequiredOutputs: 1
      Number Of Threads: 24
      ReleaseDataFlag: Off
      ReleaseDataBeforeUpdateFlag: Off
      AbortGenerateData: Off
      Progress: 1
      Multithreader: 
        RTTI typeinfo:   itk::MultiThreader
        Reference Count: 1
        Modified Time: 86
        Debug: Off
        Object Name: 
        Observers: 
          none
        Thread Count: 24
        Global Maximum Number Of Threads: 128
        Global Default Number Of Threads: 24
      CoordinateTolerance: 1e-06
      DirectionTolerance: 1e-06
      InPlace: Off
      The input and output to this filter are the same type. The filter can be run in place.
  UpdateBuffer1: 
    Image (0x2ca6db0)
      RTTI typeinfo:   itk::Image<float, 3u>
      Reference Count: 2
      Modified Time: 431
      Debug: Off
      Object Name: 
      Observers: 
        none
      Source: (none)
      Source output name: (none)
      Release Data: Off
      Data Released: False
      Global Release Data: Off
      PipelineMTime: 0
      UpdateMTime: 0
      RealTimeStamp: 0 seconds 
      LargestPossibleRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      BufferedRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      RequestedRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      Spacing: [0.664062, 0.664062, 2.5]
      Origin: [170, 170, -450]
      Direction: 
-1 0 0
0 -1 0
0 0 1

      IndexToPointMatrix: 
-0.664062 0 0
0 -0.664062 0
0 0 2.5

      PointToIndexMatrix: 
-1.50588 0 0
0 -1.50588 0
0 0 0.4

      Inverse Direction: 
-1 0 0
0 -1 0
0 0 1

      PixelContainer: 
        ImportImageContainer (0x2ca7070)
          RTTI typeinfo:   itk::ImportImageContainer<unsigned long, float>
          Reference Count: 1
          Modified Time: 432
          Debug: Off
          Object Name: 
          Observers: 
            none
          Pointer: 0x2b9e48c6d010
          Container manages memory: true
          Size: 24379392
          Capacity: 24379392
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//GetConnectedComponentsFeatureImages 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
echo /opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ThresholdImage 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1 1 1 0
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ThresholdImage 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1 1 1 0
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM.nii.gz -thresh 1 1 1 0 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz -thresh .17 inf 1 0 -multiply -comp -thresh 1 1 1 0 -o /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz
  There are 3281 connected components.
  Largest component has 98267 pixels.
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_CANNY.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_CANNY.nii.gz 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM.nii.gz -slice z 48 -dup -oli /workarea/fuentes/github/RandomForestHCCResponse/Code/dfltlabels.txt 1.0 -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_PHYSICAL_VOLUME.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_PHYSICAL_VOLUME.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_ECCENTRICITY.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_ECCENTRICITY.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_ELONGATION.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_ELONGATION.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_CANNY.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_CANNY.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_POSTERIORS1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_POSTERIORS1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_POSTERIORS2.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_POSTERIORS2.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_POSTERIORS3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureArt_ATROPOS_GMM_POSTERIORS3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
echo -c [0,0] impose no spatial regularization ??
-c [0,0] impose no spatial regularization ??
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//Atropos -d 3 -a /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_DENOISE.nii.gz -i KMeans[3] -p Socrates[1] -x /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz -c [0,0] -k Gaussian -m [0.1,1x1x1] -o [/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM.nii.gz,/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_POSTERIORS%d.nii.gz]

Running Atropos for 3-dimensional images.

Progress: 

Writing output:
  Writing posterior image (class 1)
  Writing posterior image (class 2)
  Writing posterior image (class 3)

  AtroposSegmentationImageFilter (0x2dcd630)
    RTTI typeinfo:   itk::ants::AtroposSegmentationImageFilter<itk::Image<float, 3u>, itk::Image<unsigned int, 3u>, itk::Image<unsigned int, 3u> >
    Reference Count: 1
    Modified Time: 678
    Debug: Off
    Object Name: 
    Observers: 
      IterationEvent(Command)
    Inputs: 
      Primary: (0x2dda690) *
      _1: (0x2dd7660)
    Indexed Inputs: 
      0: Primary (0x2dda690)
      1: _1 (0x2dd7660)
    Required Input Names: Primary
    NumberOfRequiredInputs: 1
    Outputs: 
      Primary: (0x2dd1ca0)
    Indexed Outputs: 
      0: Primary (0x2dd1ca0)
    NumberOfRequiredOutputs: 1
    Number Of Threads: 24
    ReleaseDataFlag: Off
    ReleaseDataBeforeUpdateFlag: Off
    AbortGenerateData: Off
    Progress: 0
    Multithreader: 
      RTTI typeinfo:   itk::MultiThreader
      Reference Count: 1
      Modified Time: 189
      Debug: Off
      Object Name: 
      Observers: 
        none
      Thread Count: 24
      Global Maximum Number Of Threads: 128
      Global Default Number Of Threads: 24
    CoordinateTolerance: 1e-06
    DirectionTolerance: 1e-06
    Maximum number of iterations: 0
    Convergence threshold: 0
    Mask label: 1
    Number of tissue classes: 3
    Number of partial volume classes: 0
    Minimize memory usage: false
    Initialization strategy: K means clustering
    Posterior probability formulation: Socrates
      initial annealing temperature = 1
      annealing rate = 1
      minimum annealing temperature = 0.1
    MRF parameters
      MRF smoothing factor = 0.1
      MRF radius = [1, 1, 1]
    Use asynchronous updating of the labels.
      ICM parameters
        maximum ICM code = 0
        maximum number of ICM iterations = 1
    No outlier handling.
    Tissue class 1: proportion = 0.100097
      GaussianListSampleFunction (0x2ddaeb0)
        mean = [69.33533750634548], covariance = [500.232]
    Tissue class 2: proportion = 0.234013
      GaussianListSampleFunction (0x2dda950)
        mean = [143.46700108596409], covariance = [327.435]
    Tissue class 3: proportion = 0.66589
      GaussianListSampleFunction (0x2de0db0)
        mean = [198.06256362572003], covariance = [321.39]
Elapsed time: 11.1877
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/CannyEdgeDetectionImageFilter /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_CANNY.nii.gz
Variance = 2
UpperThreshold = 0
LowerThreshold = 0
CannyEdgeDetectionImageFilter (0x28a81d0)
  RTTI typeinfo:   itk::CannyEdgeDetectionImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u> >
  Reference Count: 1
  Modified Time: 701
  Debug: Off
  Object Name: 
  Observers: 
    none
  Inputs: 
    Primary: (0x289ef60) *
  Indexed Inputs: 
    0: Primary (0x289ef60)
  Required Input Names: Primary
  NumberOfRequiredInputs: 1
  Outputs: 
    Primary: (0x28ac8a0)
  Indexed Outputs: 
    0: Primary (0x28ac8a0)
  NumberOfRequiredOutputs: 1
  Number Of Threads: 24
  ReleaseDataFlag: Off
  ReleaseDataBeforeUpdateFlag: Off
  AbortGenerateData: Off
  Progress: 1
  Multithreader: 
    RTTI typeinfo:   itk::MultiThreader
    Reference Count: 1
    Modified Time: 64
    Debug: Off
    Object Name: 
    Observers: 
      none
    Thread Count: 24
    Global Maximum Number Of Threads: 128
    Global Default Number Of Threads: 24
  CoordinateTolerance: 1e-06
  DirectionTolerance: 1e-06
Variance: [2, 2, 2]
MaximumError: [0.01, 0.01, 0.01]
  UpperThreshold: 0
  LowerThreshold: 0
Center: 13
Stride: 0x28a8510
  GaussianFilter: 
    DiscreteGaussianImageFilter (0x28acc80)
      RTTI typeinfo:   itk::DiscreteGaussianImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u> >
      Reference Count: 1
      Modified Time: 436
      Debug: Off
      Object Name: 
      Observers: 
        none
      Inputs: 
        Primary: (0x289ef60) *
      Indexed Inputs: 
        0: Primary (0x289ef60)
      Required Input Names: Primary
      NumberOfRequiredInputs: 1
      Outputs: 
        Primary: (0x28b1180)
      Indexed Outputs: 
        0: Primary (0x28b1180)
      NumberOfRequiredOutputs: 1
      Number Of Threads: 24
      ReleaseDataFlag: Off
      ReleaseDataBeforeUpdateFlag: Off
      AbortGenerateData: Off
      Progress: 1
      Multithreader: 
        RTTI typeinfo:   itk::MultiThreader
        Reference Count: 1
        Modified Time: 75
        Debug: Off
        Object Name: 
        Observers: 
          none
        Thread Count: 24
        Global Maximum Number Of Threads: 128
        Global Default Number Of Threads: 24
      CoordinateTolerance: 1e-06
      DirectionTolerance: 1e-06
      Variance: [2, 2, 2]
      MaximumError: [0.01, 0.01, 0.01]
      MaximumKernelWidth: 32
      FilterDimensionality: 3
      UseImageSpacing: 1
      InternalNumberOfStreamDivisions: 9
  MultiplyImageFilter: 
    MultiplyImageFilter (0x28b1560)
      RTTI typeinfo:   itk::MultiplyImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u>, itk::Image<float, 3u> >
      Reference Count: 1
      Modified Time: 693
      Debug: Off
      Object Name: 
      Observers: 
        none
      Inputs: 
        Primary: (0x28b5db0) *
        _1: (0x28b7160)
      Indexed Inputs: 
        0: Primary (0x28b5db0)
        1: _1 (0x28b7160)
      Required Input Names: Primary
      NumberOfRequiredInputs: 2
      Outputs: 
        Primary: (0x28b5a30)
      Indexed Outputs: 
        0: Primary (0x28b5a30)
      NumberOfRequiredOutputs: 1
      Number Of Threads: 24
      ReleaseDataFlag: Off
      ReleaseDataBeforeUpdateFlag: Off
      AbortGenerateData: Off
      Progress: 1
      Multithreader: 
        RTTI typeinfo:   itk::MultiThreader
        Reference Count: 1
        Modified Time: 86
        Debug: Off
        Object Name: 
        Observers: 
          none
        Thread Count: 24
        Global Maximum Number Of Threads: 128
        Global Default Number Of Threads: 24
      CoordinateTolerance: 1e-06
      DirectionTolerance: 1e-06
      InPlace: Off
      The input and output to this filter are the same type. The filter can be run in place.
  UpdateBuffer1: 
    Image (0x28b5db0)
      RTTI typeinfo:   itk::Image<float, 3u>
      Reference Count: 2
      Modified Time: 431
      Debug: Off
      Object Name: 
      Observers: 
        none
      Source: (none)
      Source output name: (none)
      Release Data: Off
      Data Released: False
      Global Release Data: Off
      PipelineMTime: 0
      UpdateMTime: 0
      RealTimeStamp: 0 seconds 
      LargestPossibleRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      BufferedRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      RequestedRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      Spacing: [0.664062, 0.664062, 2.5]
      Origin: [170, 170, -450]
      Direction: 
-1 0 0
0 -1 0
0 0 1

      IndexToPointMatrix: 
-0.664062 0 0
0 -0.664062 0
0 0 2.5

      PointToIndexMatrix: 
-1.50588 0 0
0 -1.50588 0
0 0 0.4

      Inverse Direction: 
-1 0 0
0 -1 0
0 0 1

      PixelContainer: 
        ImportImageContainer (0x28b6070)
          RTTI typeinfo:   itk::ImportImageContainer<unsigned long, float>
          Reference Count: 1
          Modified Time: 432
          Debug: Off
          Object Name: 
          Observers: 
            none
          Pointer: 0x2ad866ed4010
          Container manages memory: true
          Size: 24379392
          Capacity: 24379392
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//GetConnectedComponentsFeatureImages 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
echo /opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ThresholdImage 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1 1 1 0
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ThresholdImage 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1 1 1 0
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM.nii.gz -thresh 1 1 1 0 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz -thresh .17 inf 1 0 -multiply -comp -thresh 1 1 1 0 -o /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz
  There are 476 connected components.
  Largest component has 89342 pixels.
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_CANNY.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_CANNY.nii.gz 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM.nii.gz -slice z 48 -dup -oli /workarea/fuentes/github/RandomForestHCCResponse/Code/dfltlabels.txt 1.0 -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_PHYSICAL_VOLUME.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_PHYSICAL_VOLUME.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_ECCENTRICITY.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_ECCENTRICITY.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_ELONGATION.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_ELONGATION.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_CANNY.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_CANNY.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_POSTERIORS1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_POSTERIORS1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_POSTERIORS2.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_POSTERIORS2.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_POSTERIORS3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureVen_ATROPOS_GMM_POSTERIORS3.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
echo -c [0,0] impose no spatial regularization ??
-c [0,0] impose no spatial regularization ??
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//Atropos -d 3 -a /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_DENOISE.nii.gz -i KMeans[3] -p Socrates[1] -x /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureMASKERODE.nii.gz -c [0,0] -k Gaussian -m [0.1,1x1x1] -o [/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM.nii.gz,/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_POSTERIORS%d.nii.gz]

Running Atropos for 3-dimensional images.

Progress: 

Writing output:
  Writing posterior image (class 1)
  Writing posterior image (class 2)
  Writing posterior image (class 3)

  AtroposSegmentationImageFilter (0x33a5630)
    RTTI typeinfo:   itk::ants::AtroposSegmentationImageFilter<itk::Image<float, 3u>, itk::Image<unsigned int, 3u>, itk::Image<unsigned int, 3u> >
    Reference Count: 1
    Modified Time: 678
    Debug: Off
    Object Name: 
    Observers: 
      IterationEvent(Command)
    Inputs: 
      Primary: (0x33b2690) *
      _1: (0x33af660)
    Indexed Inputs: 
      0: Primary (0x33b2690)
      1: _1 (0x33af660)
    Required Input Names: Primary
    NumberOfRequiredInputs: 1
    Outputs: 
      Primary: (0x33a9ca0)
    Indexed Outputs: 
      0: Primary (0x33a9ca0)
    NumberOfRequiredOutputs: 1
    Number Of Threads: 24
    ReleaseDataFlag: Off
    ReleaseDataBeforeUpdateFlag: Off
    AbortGenerateData: Off
    Progress: 0
    Multithreader: 
      RTTI typeinfo:   itk::MultiThreader
      Reference Count: 1
      Modified Time: 189
      Debug: Off
      Object Name: 
      Observers: 
        none
      Thread Count: 24
      Global Maximum Number Of Threads: 128
      Global Default Number Of Threads: 24
    CoordinateTolerance: 1e-06
    DirectionTolerance: 1e-06
    Maximum number of iterations: 0
    Convergence threshold: 0
    Mask label: 1
    Number of tissue classes: 3
    Number of partial volume classes: 0
    Minimize memory usage: false
    Initialization strategy: K means clustering
    Posterior probability formulation: Socrates
      initial annealing temperature = 1
      annealing rate = 1
      minimum annealing temperature = 0.1
    MRF parameters
      MRF smoothing factor = 0.1
      MRF radius = [1, 1, 1]
    Use asynchronous updating of the labels.
      ICM parameters
        maximum ICM code = 0
        maximum number of ICM iterations = 1
    No outlier handling.
    Tissue class 1: proportion = 0.0997714
      GaussianListSampleFunction (0x33b2eb0)
        mean = [72.85082602325747], covariance = [281.166]
    Tissue class 2: proportion = 0.540581
      GaussianListSampleFunction (0x33b2950)
        mean = [113.99142106413744], covariance = [75.0704]
    Tissue class 3: proportion = 0.359648
      GaussianListSampleFunction (0x33b8db0)
        mean = [139.33493332351443], covariance = [126.395]
Elapsed time: 11.3474
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin/CannyEdgeDetectionImageFilter /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_CANNY.nii.gz
Variance = 2
UpperThreshold = 0
LowerThreshold = 0
CannyEdgeDetectionImageFilter (0x28f31d0)
  RTTI typeinfo:   itk::CannyEdgeDetectionImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u> >
  Reference Count: 1
  Modified Time: 701
  Debug: Off
  Object Name: 
  Observers: 
    none
  Inputs: 
    Primary: (0x28e9f60) *
  Indexed Inputs: 
    0: Primary (0x28e9f60)
  Required Input Names: Primary
  NumberOfRequiredInputs: 1
  Outputs: 
    Primary: (0x28f78a0)
  Indexed Outputs: 
    0: Primary (0x28f78a0)
  NumberOfRequiredOutputs: 1
  Number Of Threads: 24
  ReleaseDataFlag: Off
  ReleaseDataBeforeUpdateFlag: Off
  AbortGenerateData: Off
  Progress: 1
  Multithreader: 
    RTTI typeinfo:   itk::MultiThreader
    Reference Count: 1
    Modified Time: 64
    Debug: Off
    Object Name: 
    Observers: 
      none
    Thread Count: 24
    Global Maximum Number Of Threads: 128
    Global Default Number Of Threads: 24
  CoordinateTolerance: 1e-06
  DirectionTolerance: 1e-06
Variance: [2, 2, 2]
MaximumError: [0.01, 0.01, 0.01]
  UpperThreshold: 0
  LowerThreshold: 0
Center: 13
Stride: 0x28f3510
  GaussianFilter: 
    DiscreteGaussianImageFilter (0x28f7c80)
      RTTI typeinfo:   itk::DiscreteGaussianImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u> >
      Reference Count: 1
      Modified Time: 436
      Debug: Off
      Object Name: 
      Observers: 
        none
      Inputs: 
        Primary: (0x28e9f60) *
      Indexed Inputs: 
        0: Primary (0x28e9f60)
      Required Input Names: Primary
      NumberOfRequiredInputs: 1
      Outputs: 
        Primary: (0x28fc180)
      Indexed Outputs: 
        0: Primary (0x28fc180)
      NumberOfRequiredOutputs: 1
      Number Of Threads: 24
      ReleaseDataFlag: Off
      ReleaseDataBeforeUpdateFlag: Off
      AbortGenerateData: Off
      Progress: 1
      Multithreader: 
        RTTI typeinfo:   itk::MultiThreader
        Reference Count: 1
        Modified Time: 75
        Debug: Off
        Object Name: 
        Observers: 
          none
        Thread Count: 24
        Global Maximum Number Of Threads: 128
        Global Default Number Of Threads: 24
      CoordinateTolerance: 1e-06
      DirectionTolerance: 1e-06
      Variance: [2, 2, 2]
      MaximumError: [0.01, 0.01, 0.01]
      MaximumKernelWidth: 32
      FilterDimensionality: 3
      UseImageSpacing: 1
      InternalNumberOfStreamDivisions: 9
  MultiplyImageFilter: 
    MultiplyImageFilter (0x28fc560)
      RTTI typeinfo:   itk::MultiplyImageFilter<itk::Image<float, 3u>, itk::Image<float, 3u>, itk::Image<float, 3u> >
      Reference Count: 1
      Modified Time: 693
      Debug: Off
      Object Name: 
      Observers: 
        none
      Inputs: 
        Primary: (0x2900db0) *
        _1: (0x2902160)
      Indexed Inputs: 
        0: Primary (0x2900db0)
        1: _1 (0x2902160)
      Required Input Names: Primary
      NumberOfRequiredInputs: 2
      Outputs: 
        Primary: (0x2900a30)
      Indexed Outputs: 
        0: Primary (0x2900a30)
      NumberOfRequiredOutputs: 1
      Number Of Threads: 24
      ReleaseDataFlag: Off
      ReleaseDataBeforeUpdateFlag: Off
      AbortGenerateData: Off
      Progress: 1
      Multithreader: 
        RTTI typeinfo:   itk::MultiThreader
        Reference Count: 1
        Modified Time: 86
        Debug: Off
        Object Name: 
        Observers: 
          none
        Thread Count: 24
        Global Maximum Number Of Threads: 128
        Global Default Number Of Threads: 24
      CoordinateTolerance: 1e-06
      DirectionTolerance: 1e-06
      InPlace: Off
      The input and output to this filter are the same type. The filter can be run in place.
  UpdateBuffer1: 
    Image (0x2900db0)
      RTTI typeinfo:   itk::Image<float, 3u>
      Reference Count: 2
      Modified Time: 431
      Debug: Off
      Object Name: 
      Observers: 
        none
      Source: (none)
      Source output name: (none)
      Release Data: Off
      Data Released: False
      Global Release Data: Off
      PipelineMTime: 0
      UpdateMTime: 0
      RealTimeStamp: 0 seconds 
      LargestPossibleRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      BufferedRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      RequestedRegion: 
        Dimension: 3
        Index: [0, 0, 0]
        Size: [512, 512, 93]
      Spacing: [0.664062, 0.664062, 2.5]
      Origin: [170, 170, -450]
      Direction: 
-1 0 0
0 -1 0
0 0 1

      IndexToPointMatrix: 
-0.664062 0 0
0 -0.664062 0
0 0 2.5

      PointToIndexMatrix: 
-1.50588 0 0
0 -1.50588 0
0 0 0.4

      Inverse Direction: 
-1 0 0
0 -1 0
0 0 1

      PixelContainer: 
        ImportImageContainer (0x2901070)
          RTTI typeinfo:   itk::ImportImageContainer<unsigned long, float>
          Reference Count: 1
          Modified Time: 432
          Debug: Off
          Object Name: 
          Observers: 
            none
          Pointer: 0x2b4151f44010
          Container manages memory: true
          Size: 24379392
          Capacity: 24379392
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//GetConnectedComponentsFeatureImages 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
echo /opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ThresholdImage 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1 1 1 0
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ThresholdImage 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1 1 1 0
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM.nii.gz -thresh 1 1 1 0 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureNORMALIZED_DISTANCE.nii.gz -thresh .17 inf 1 0 -multiply -comp -thresh 1 1 1 0 -o /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz
  There are 2397 connected components.
  Largest component has 48487 pixels.
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_LABEL1_DISTANCE.nii.gz 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
/opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_CANNY.nii.gz MaurerDistance /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_CANNY.nii.gz 1
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM.nii.gz -slice z 48 -dup -oli /workarea/fuentes/github/RandomForestHCCResponse/Code/dfltlabels.txt 1.0 -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_VOLUME_TO_SURFACE_AREA_RATIO.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_PHYSICAL_VOLUME.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_PHYSICAL_VOLUME.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_ECCENTRICITY.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_ECCENTRICITY.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_ELONGATION.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_ELONGATION.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_CANNY.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_CANNY.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_POSTERIORS1.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_POSTERIORS1.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_POSTERIORS2.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_POSTERIORS2.png
END   <<<<<<<<<<<<<<<<<<<<


BEGIN >>>>>>>>>>>>>>>>>>>>
c3d /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_POSTERIORS3.nii.gz -slice z 48 -clip 0 inf -color-map grey -type uchar -omc /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureDel_ATROPOS_GMM_POSTERIORS3.png
END   <<<<<<<<<<<<<<<<<<<<



--------------------------------------------------------------------------------------
 Done with creating feature images
 Script executed in 3051 seconds
 0h 50m 51s
--------------------------------------------------------------------------------------
######################################################################################
Create csv file
######################################################################################
/workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureFeatureImageList.csv
Rscript /workarea/fuentes/github/LiverSegmentationExample/Code/createCSVFileFromModel.R /workarea/fuentes/github/LiverSegmentationExample/workdir/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Mask.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texture /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureFeatureImageList.csv
BEGIN >>>>>>>>>>>>>>>>>>>>
Rscript /workarea/fuentes/github/LiverSegmentationExample/Code/createCSVFileFromModel.R /workarea/fuentes/github/LiverSegmentationExample/workdir/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel /workarea/fuentes/github/LiverSegmentationExample/ImageDatabase/Predict0001/before/Mask.nii.gz /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/texture /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureFeatureImageList.csv
randomForest 4.6-10
Type rfNews() to see new features/changes/bug fixes.
END   <<<<<<<<<<<<<<<<<<<<


######################################################################################
Apply the model
######################################################################################
Rscript /workarea/fuentes/github/LiverSegmentationExample/Code/applyModel.R 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureFeatureImageList.csv /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel/RF_POSTERIORS 1
BEGIN >>>>>>>>>>>>>>>>>>>>
Rscript /workarea/fuentes/github/LiverSegmentationExample/Code/applyModel.R 3 /workarea/fuentes/github/LiverSegmentationExample/workdir/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/textureFeatureImageList.csv /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel/RF_POSTERIORS 1
Loading required package: Rcpp
Loading required package: methods
Loading required package: signal
Loading required package: MASS

Attaching package: ‘signal’

The following objects are masked from ‘package:stats’:

    filter, poly

Loading required package: timeSeries
Loading required package: timeDate
Loading required package: mFilter
Loading required package: robust
Loading required package: fit.models
Loading required package: lattice
Loading required package: robustbase
Loading required package: rrcov
Loading required package: pcaPP
Loading required package: mvtnorm
Scalable Robust Estimators with High Breakdown Point (version 1.3-4)

Loading required package: magic
Loading required package: abind
Loading required package: knitr
Loading required package: pixmap
Loading required package: misc3d
Welcome to ANTsR
randomForest 4.6-10
Type rfNews() to see new features/changes/bug fixes.

Attaching package: ‘randomForest’

The following object is masked from ‘package:timeSeries’:

    outlier

Loading required package: snow
  Reading feature image NORMALIZED_DISTANCE.
  Reading feature image Pre_DENOISE.
  Reading feature image Pre_GRADIENT.
  Reading feature image Art_DENOISE.
  Reading feature image Art_GRADIENT.
  Reading feature image Ven_DENOISE.
  Reading feature image Ven_GRADIENT.
  Reading feature image Del_DENOISE.
  Reading feature image Del_GRADIENT.
  Reading feature image DENOISEAreaUnderCurve.
  Reading feature image DENOISEPreArtDeriv.
  Reading feature image DENOISEArtVenDeriv.
  Reading feature image DENOISEVenDelDeriv.
  Reading feature image Pre_ATROPOS_GMM_POSTERIORS1.
  Reading feature image Pre_ATROPOS_GMM_POSTERIORS2.
  Reading feature image Pre_ATROPOS_GMM_POSTERIORS3.
  Reading feature image Pre_ATROPOS_GMM_LABEL1_DISTANCE.
  Reading feature image Pre_MEAN_RADIUS_1.
  Reading feature image Pre_MEAN_RADIUS_3.
  Reading feature image Pre_SIGMA_RADIUS_1.
  Reading feature image Pre_SIGMA_RADIUS_3.
  Reading feature image Pre_SKEWNESS_RADIUS_1.
  Reading feature image Pre_SKEWNESS_RADIUS_3.
  Reading feature image Art_ATROPOS_GMM_POSTERIORS1.
  Reading feature image Art_ATROPOS_GMM_POSTERIORS2.
  Reading feature image Art_ATROPOS_GMM_POSTERIORS3.
  Reading feature image Art_ATROPOS_GMM_LABEL1_DISTANCE.
  Reading feature image Art_MEAN_RADIUS_1.
  Reading feature image Art_MEAN_RADIUS_3.
  Reading feature image Art_SIGMA_RADIUS_1.
  Reading feature image Art_SIGMA_RADIUS_3.
  Reading feature image Art_SKEWNESS_RADIUS_1.
  Reading feature image Art_SKEWNESS_RADIUS_3.
  Reading feature image Ven_ATROPOS_GMM_POSTERIORS1.
  Reading feature image Ven_ATROPOS_GMM_POSTERIORS2.
  Reading feature image Ven_ATROPOS_GMM_POSTERIORS3.
  Reading feature image Ven_ATROPOS_GMM_LABEL1_DISTANCE.
  Reading feature image Ven_MEAN_RADIUS_1.
  Reading feature image Ven_MEAN_RADIUS_3.
  Reading feature image Ven_SIGMA_RADIUS_1.
  Reading feature image Ven_SIGMA_RADIUS_3.
  Reading feature image Ven_SKEWNESS_RADIUS_1.
  Reading feature image Ven_SKEWNESS_RADIUS_3.
  Reading feature image Del_ATROPOS_GMM_POSTERIORS1.
  Reading feature image Del_ATROPOS_GMM_POSTERIORS2.
  Reading feature image Del_ATROPOS_GMM_POSTERIORS3.
  Reading feature image Del_ATROPOS_GMM_LABEL1_DISTANCE.
  Reading feature image Del_MEAN_RADIUS_1.
  Reading feature image Del_MEAN_RADIUS_3.
  Reading feature image Del_SIGMA_RADIUS_1.
  Reading feature image Del_SIGMA_RADIUS_3.
  Reading feature image Del_SKEWNESS_RADIUS_1.
  Reading feature image Del_SKEWNESS_RADIUS_3.
Prediction took 182.654 seconds.
Writing  /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel/RF_POSTERIORS1.nii.gz .
Done writing image. PixelType: 'float' | Dimension: '3'.
Writing  /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel/RF_POSTERIORS2.nii.gz .
Done writing image. PixelType: 'float' | Dimension: '3'.
Writing  /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel/RF_POSTERIORS3.nii.gz .
Done writing image. PixelType: 'float' | Dimension: '3'.
END   <<<<<<<<<<<<<<<<<<<<



--------------------------------------------------------------------------------------
 Done with applying model
 Script executed in 3312 seconds
 0h 55m 12s
--------------------------------------------------------------------------------------
cd /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel; /opt/apps/ANTsR/dev//ANTsR_src/ANTsR/src/ANTS/ANTS-build//bin//ImageMath 3 LABELS.GMM.nii.gz MostLikely 0 RF_POSTERIORS*.nii.gz  
```

### Example Volume Calculation

Given the segmented images, c3d is used to extract volume information. 
```
innovador$ make -f prediction.makefile volume
cd /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel; c3d LABELS.GMM.nii.gz LABELS.GMM.nii.gz -lstat > LABELS.GMM.VolStat.txt ; sed "s/\s\+/,/g" LABELS.GMM.VolStat.txt > LABELS.GMM.VolStat.csv
innovador$ cat /workarea/fuentes/github/LiverSegmentationExample/workdir/Predict0001/before/FeatureModel00000130/KFold.0000000000000011111111111111111110.prior.GMM.RFModel/LABELS.GMM.VolStat.csv
LabelID,Mean,StdD,Max,Min,Count,Vol(mm^3),Extent(Vox)
,0,0.00000,0.00000,0.00000,0.00000,22587824,24901854.558,512,512,93
,1,1.00000,0.00000,1.00000,1.00000,1119734,1234446.187,270,299,71
,2,2.00000,0.00000,2.00000,2.00000,609718,672181.125,243,280,69
,3,3.00000,0.00000,3.00000,3.00000,62116,68479.531,144,176,40
```
