#!/usr/bin/python
# In order to make this file executable in a unix os, execute the following:
# "chmod 755 GenerateFileWithMetadata.py"
# I have tested this file in python 3.

#-------------------------------------------------------------------------------
# Author        : Cesar R. Urteaga-Reyesvera.
# Creation Date : Dec 08, 2017.
# Description   : Script that creates a comma-separated file with metadata
#                 information about the SAS programs in the current directory as
#                 well as a file with the SAS statements of these files that
#                 allows to identify possible data input tables.  At the end,
#                 the program's aim is identify the possible data inputs in a
#                 set of SAS programs.
# Parameters    : gFolderPath             - The address of the folder where the
#                                           SAS programs are supposed to be.
#                 gNameFileWithMetadata   - The name of the file that will have
#                                           the file's metadata.  Do not include
#                                           the file extension.
#                 gNameFileWithStatements - The name of the file that will have
#                                           all the SAS statements related to
#                                           input tables.  Do not include the
#                                           file extension.
# Output        : Creates two TXT files with the information described above in
#                 the folder where the files are stored.
#-------------------------------------------------------------------------------

#------------------------------------------------------------------------ IMPORT
# Imported modules.
import sys
import os
import re

#-------------------------------------------------------------------------- CODE
# Stores the parameters given to the script. Remember that the first element
# is the name of the script.
gFolderPath             = sys.argv[1]
gNameFileWithMetadata   = sys.argv[2]
gNameFileWithStatements = sys.argv[3]

# We send a summary to the user of the parameters given.
print("Folder path                 : " + gFolderPath)
print("Name file with the metadata : " + gNameFileWithMetadata)
print("Name file with statements   : " + gNameFileWithStatements)

# Change the working directory to the given path, where the files are stored.
# N.B.: In a Linux server, the working directory outside the program does not
#       change.
os.chdir(gFolderPath)

# We create a file where the metadata will be stored.
FileWithMetadata = open("./" + gNameFileWithMetadata + ".txt", "w+")
# We create a file with the SAS statements.
FileWithStatements = open("./" + gNameFileWithStatements + ".txt", "w+")

# For each directory in the top folder, it yields a 3-tuple with the current
# path, folders within the current directory, and filenames.  Folders and
# filenames are returned in lists.
for dirpath, dirnames, filenames in os.walk(".", topdown = True):
  for file in filenames:
    if file.upper().endswith(".SAS") and \
       (file != gNameFileWithMetadata + ".txt" or \
        file != gNameFileWithCode + ".txt"):
      FileWithMetadata.write(os.path.realpath(dirpath) + ",")
      FileWithMetadata.write(file + "\n")
      # We open each SAS program file to look for input tables and save the
      # statements only if they contain the following keywords:
      FileWithCode = open(os.path.realpath(dirpath) + "\\" + file, "r")
      for line in FileWithCode:
        if re.match(".*LIBNAME", line.upper()) or \
           re.match(".*SET +.+[.]+", line.upper()) or \
           re.match(".*FROM +.+[.]+", line.upper()) or \
           re.match(".*[%]LET.+[.]+", line.upper()) or \
           re.match(".*DATA *= *.+[.]+", line.upper()):
          FileWithStatements.write(file + "|")
          FileWithStatements.write(line.lstrip())
