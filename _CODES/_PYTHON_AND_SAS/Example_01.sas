/* EXAMPLE
    Type        : Python with SAS.
    Description : Using the "X" command, we use python (2) with SAS to obtain
                  the path and names of the files within a folder for an ad hoc
                  file type.
    Assumptions : We assume that python is loaded in the server, and the python
                  file "GenerateFileWithMetadata.py" is in the WORK library.
*/

* Sets up the paths where the files and the python program are stored. ;
%LET _MLT_FILES_PATH           = %SYSFUNC(GETOPTION(WORK));
%LET _MLT_PATH_PYTHON_PROGRAMS = %SYSFUNC(GETOPTION(WORK));

* Creates the sample text files.;
X "touch '&_MLT_FILES_PATH./SampleFile_01.txt'";
X "touch '&_MLT_FILES_PATH./SampleFile_02.txt'";
X "touch '&_MLT_FILES_PATH./SampleFile_03.txt'";

* Calls the python program. ;
X "python &_MLT_PATH_PYTHON_PROGRAMS./GenerateFileWithMetadata.py '&_MLT_FILES_PATH.' 'txt' 'FileWithMetadata'";

* Load the data of the created file into a dataset. ;
DATA METADATA_INFORMATION;
  INFILE "&_MLT_FILES_PATH./FileWithMetadata.txt"
         DSD DLM = ','
         MISSOVER;
  LENGTH _PATH     $87.
         _FILENAME $17.
         _VERSION  $2.;
  INPUT  _PATH
         _FILENAME
         _VERSION  $;
RUN;
