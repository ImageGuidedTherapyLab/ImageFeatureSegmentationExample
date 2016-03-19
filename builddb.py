import sqlite3
import time
import datetime
import string
import dicom
import subprocess,re,os
import ConfigParser

## Borrowed from
## $(SLICER_DIR)/CTK/Libs/DICOM/Core/Resources/dicom-schema.sql
## 
## --
## -- A simple SQLITE3 database schema for modelling locally stored DICOM files
## --
## -- Note: the semicolon at the end is necessary for the simple parser to separate
## --       the statements since the SQlite driver does not handle multiple
## --       commands per QSqlQuery::exec call!
## -- ;
## TODO note that SQLite does not enforce the length of a VARCHAR. 
## TODO (9) What is the maximum size of a VARCHAR in SQLite?
##
## TODO http://www.sqlite.org/faq.html#q9
##
## TODO SQLite does not enforce the length of a VARCHAR. You can declare a VARCHAR(10) and SQLite will be happy to store a 500-million character string there. And it will keep all 500-million characters intact. Your content is never truncated. SQLite understands the column type of "VARCHAR(N)" to be the same as "TEXT", regardless of the value of N.
initializedb = """
DROP TABLE IF EXISTS 'lstat' ;

CREATE TABLE 'lstat' (
 'DataID'     VARCHAR     NOT NULL,
 'Time'       DATE        NOT NULL,
 'FeatureID'  VARCHAR     NOT NULL,
 'LabelID'    INT         NOT NULL,
 'Mean'       REAL            NULL,
 'StdD'       REAL            NULL,
 'Max'        REAL            NULL,
 'Min'        REAL            NULL,
 'Count'      INT             NULL,
 'Volume'     REAL            NULL,
 'ExtentX'    INT             NULL,
 'ExtentY'    INT             NULL,
 'ExtentZ'    INT             NULL,
 PRIMARY KEY ('DataID','Time','FeatureID','LabelID') );
"""


from optparse import OptionParser
parser = OptionParser()
parser.add_option( "--initialize",
                  action="store_true", dest="initialize", default=False,
                  help="build initial sql file ", metavar = "BOOL")
parser.add_option( "--builddb",
                  action="store_true", dest="builddb", default=False,
                  help="build db ", metavar = "BOOL")
(options, args) = parser.parse_args()
#############################################################
# build initial sql file 
#############################################################
if (options.initialize ):
  # build new database
  os.system('rm ./DataSummary.sql')
  tagsconn = sqlite3.connect('./DataSummary.sql')
  for sqlcmd in initializedb.split(";"):
     tagsconn.execute(sqlcmd )
#############################################################
# update metadata
# build data base tables from CSV file
#############################################################
elif (options.builddb):
  import csv
  tagsconn = sqlite3.connect('./DataSummary.sql')

  # initialize new database table
  tagsconn = sqlite3.connect('./DataSummary.sql')
  for sqlcmd in initializedb.split(";"):
     tagsconn.execute(sqlcmd )
  cursor = tagsconn.cursor()

  # necrosis/recurrence with path
  with open('./DataSummary.csv', 'r') as csvfile:
      reader = csv.reader(csvfile, delimiter=',')
      rawdatasummary = [row for row in reader]
  header = rawdatasummary.pop(0)
  print len(rawdatasummary)
  for row in rawdatasummary:
    DataID                 =     row[ header.index('DataID') ]
    imagedate              = row[ header.index('Time')   ]
    sqlformatimagedate     = time.strftime("%Y-%m-%d",time.strptime(imagedate,"%m%d%Y"))
    FeatureID              = row[ header.index('FeatureID')   ]
    LabelID                = int(row[ header.index('LabelID')    ])
    MeanValue              = float(row[ header.index('Mean')     ])
    StdDValue              = float(row[ header.index('StdD')     ])
    MaxValue               = float(row[ header.index('Max')      ])
    MinValue               = float(row[ header.index('Min')      ])
    CountValue             = int(row[ header.index('Count')      ])
    VolumeValue            = float(row[ header.index('Vol.mm.3') ])
    ExtentX                = int(row[ header.index('ExtentX')    ])
    ExtentY                = int(row[ header.index('ExtentY')    ])
    ExtentZ                = int(row[ header.index('ExtentZ')    ])
    defaultpatiententry    = (DataID,sqlformatimagedate,FeatureID,LabelID,MeanValue,StdDValue,MaxValue,MinValue,CountValue,VolumeValue,ExtentX,ExtentY,ExtentZ)
    print defaultpatiententry
    cursor.execute('insert into lstat (DataID,Time,FeatureID,LabelID,Mean,StdD,Max,Min,Count,"Volume",ExtentX,ExtentY,ExtentZ) values (?,?,?,?,?,?,?,?,?,?,?,?,?);' , defaultpatiententry);

  # commit all updates
  tagsconn.commit()

  # query data
  dataquery ="""
  select ls1.Dataid, ls1.FeatureID,ls1.labelid,
         (julianday(ls2.time)-julianday(ls1.time)) as TimeDiff,
         ls2.Volume - ls1.Volume as VolDiff,
         ls1.time as TimeOne, ls1.Mean as MeanOne,ls1.Volume as VolumeOne,
         ls2.time as TimeTwo, ls2.Mean as MeanTwo,ls2.Volume as VolumeTwo   
  from lstat ls1
  join lstat ls2 on ls1.Dataid=ls2.dataid and ls1.FeatureID=ls2.FeatureID and ls1.labelid=ls2.labelid
  where ls1.Time<ls2.Time and ls1.labelid > 0;
  """

  # return query as list of dictionary
  cursor.execute(dataquery)
  queryNames= [description[0] for description in cursor.description]
  queryList = [dict(zip(queryNames,x)) for x in cursor]
  print queryNames #, queryDict


#############################################################
#############################################################
else:
  parser.print_help()
  print options
  print "sqlite3 DataSummary.sql 'select * from sqlite_master;'"

