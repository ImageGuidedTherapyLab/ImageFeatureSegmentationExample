import subprocess
import os

# setup command line parser to control execution
from optparse import OptionParser
parser = OptionParser()
parser.add_option( "--rfimagefile",
                  action="store", dest="rfimagefile", default=None,
                  help="FILE containing image info", metavar="FILE")
parser.add_option( "--truthimage",
                  action="store", dest="truthimage", default=None,
                  help="FILE to write out ", metavar="FILE")
parser.add_option( "--maskimage",
                  action="store", dest="maskimage", default=None,
                  help="FILE to write out ", metavar="FILE")
parser.add_option( "--labelfile",
                  action="store", dest="labelfile", default='dfltlabels.txt',
                  help="FILE to write out ", metavar="FILE")
(options, args) = parser.parse_args()


if (options.rfimagefile != None and options.maskimage != None):
  maskimage    = options.maskimage  
  truthimage   = options.truthimage 
  rfsolnpng    = options.rfimagefile.replace('.nii.gz','.png')
  diffsolnpng  = options.rfimagefile.replace('.nii.gz','.diff.png')
  if ( truthimage != None  ): # check training set available
   if (  os.path.isfile(truthimage) ): # check training set available
    try: # necrosis first
      getHeaderCmd = 'c3d %s -thresh 3 3 1 0  -centroid ' % truthimage 
      print getHeaderCmd
      headerProcess = subprocess.Popen(getHeaderCmd ,shell=True,stdout=subprocess.PIPE )
      while ( headerProcess.poll() == None ):
         pass
      rawcentroidinfo = headerProcess.stdout.readline().strip('\n')
      centroid = eval( rawcentroidinfo.replace('CENTROID_VOX',''))
    except NameError: # enhancing second
      getHeaderCmd = 'c3d %s -thresh 2 2 1 0  -centroid ' % truthimage 
      print getHeaderCmd
      headerProcess = subprocess.Popen(getHeaderCmd ,shell=True,stdout=subprocess.PIPE )
      while ( headerProcess.poll() == None ):
         pass
      rawcentroidinfo = headerProcess.stdout.readline().strip('\n')
      centroid = eval( rawcentroidinfo.replace('CENTROID_VOX',''))
  else: #use mask
    getHeaderCmd = 'c3d %s -thresh 1 1 1 0  -centroid ' % maskimage 
    print getHeaderCmd
    headerProcess = subprocess.Popen(getHeaderCmd ,shell=True,stdout=subprocess.PIPE )
    while ( headerProcess.poll() == None ):
       pass
    rawcentroidinfo = headerProcess.stdout.readline().strip('\n')
    centroid = eval( rawcentroidinfo.replace('CENTROID_VOX',''))
  #print centroid , int(centroid [2])
  zloc =  int(centroid [2])
  #pngcmd = 'c3d %s -slice z %d  -clip 0 200 -pad 1x0x0vox 0x0x0vox 200 -color-map grey -type uchar -omc %s' % (options.rfimagefile,zloc,options.truthimage)
  #if 'Truth' in  options.rfimagefile or 'Mask' in  options.rfimagefile:
  pngcmd = 'c3d %s -slice z %d  -dup -oli %s 1.0 -type uchar -omc %s' % (options.rfimagefile,zloc,options.labelfile,rfsolnpng)
  print pngcmd
  os.system(pngcmd)
  pngcmd = 'c3d %s %s -scale -1 -add -binarize -scale 7 -slice z %d  -dup -oli %s 1.0 -type uchar -omc %s' % (truthimage,options.rfimagefile,zloc,options.labelfile,diffsolnpng)
  print pngcmd
  os.system(pngcmd)
else:
  parser.print_help()
  print options
 
