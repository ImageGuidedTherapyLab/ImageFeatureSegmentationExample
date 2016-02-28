import subprocess
import os

# setup command line parser to control execution
from optparse import OptionParser
parser = OptionParser()
parser.add_option( "--imagedir",
                  action="store", dest="imagedir", default=None,
                  help="DIR containing image info", metavar="DIR")
(options, args) = parser.parse_args()


if (options.imagedir != None):
  maskimage   = "%s/Mask.nii.gz" % options.imagedir
  truthimage  = "%s/Truth.nii.gz" % options.imagedir
  #print  truthimage 
  # necrosis first
  try: 
    getHeaderCmd = 'c3d %s -thresh 3 3 1 0  -centroid ' % truthimage 
    headerProcess = subprocess.Popen(getHeaderCmd ,shell=True,stdout=subprocess.PIPE ,stderr=subprocess.PIPE)
    while ( headerProcess.poll() == None ):
       pass
    rawcentroidinfo = headerProcess.stdout.readline().strip('\n')
    #print getHeaderCmd,rawcentroidinfo 
    centroid = eval( rawcentroidinfo.replace('CENTROID_VOX',''))
  except (NameError, SyntaxError) as excp: 
    # enhancing second
    try: 
      getHeaderCmd = 'c3d %s -thresh 2 2 1 0  -centroid ' % truthimage 
      headerProcess = subprocess.Popen(getHeaderCmd ,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE )
      while ( headerProcess.poll() == None ):
         pass
      rawcentroidinfo = headerProcess.stdout.readline().strip('\n')
      #print getHeaderCmd,rawcentroidinfo 
      centroid = eval( rawcentroidinfo.replace('CENTROID_VOX',''))
    except (NameError, SyntaxError)as excp : 
      #use mask
      getHeaderCmd = 'c3d %s -thresh 1 1 1 0  -centroid ' % maskimage 
      #print getHeaderCmd
      headerProcess = subprocess.Popen(getHeaderCmd ,shell=True,stdout=subprocess.PIPE )
      while ( headerProcess.poll() == None ):
         pass
      rawcentroidinfo = headerProcess.stdout.readline().strip('\n')
      centroid = eval( rawcentroidinfo.replace('CENTROID_VOX',''))
  #print getHeaderCmd
  #print centroid , int(centroid [2])
  print int(centroid [2])
else:
  parser.print_help()
  print options
 
