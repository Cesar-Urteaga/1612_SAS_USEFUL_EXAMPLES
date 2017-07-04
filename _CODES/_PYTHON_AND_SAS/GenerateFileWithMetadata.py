#!/usr/bin/python
# In order to make this file executable in a unix os, execute the following:
# "chmod 755 GenerateFileWithMetadata.py"

#-------------------------------------------------------------------------------
# Author        : Raul.
# Creation Date : June 30, 2017.
# Description   : Script that creates a comma-separated file with metadata
#                 information about the files of a given type and in a specified
#                 folder.
# Parameters    : gFolderPath           - The address of the folder where the
#                                         files are supposed to be.
#                 gFileExtension        - The type of file that we are looking
#                                         for.
#                 gNameFileWithMetadata - The name of the file that will have
#                                         the file's metadata.
# Output        : Creates a TXT file with the metadata in the folder where the
#                 files are stored.
#-------------------------------------------------------------------------------

#------------------------------------------------------------------------ IMPORT
# Imported modules.
import sys
import os

#-------------------------------------------------------------------------- CODE
# Stores the parameters given to the script. Remember that the first element
# is the name of the script.
gFolderPath           = sys.argv[1]
gFileExtension        = sys.argv[2]
gNameFileWithMetadata = sys.argv[3]

# We send a summary to the user of the parameters given.
print "Folder path                 : " + gFolderPath
print "File extension              : " + gFileExtension
print "Name file with the metadata : " + gNameFileWithMetadata

# Change the working directory to the given path, where the files are stored.
# N.B.: In a Linux server, the working directory outside the program does not
#       change.
os.chdir(gFolderPath)

# We create a file where the metadata will be stored.
FileWithMetadata = open("./" + gNameFileWithMetadata + ".txt", "w+")

# For each directory in the top folder, it yields a 3-tuple with the current
# path, folders within the current directory, and filenames.  Folders and
# filenames are returned in lists.
for dirpath, dirnames, filenames in os.walk(".", topdown = True):
  for file in filenames:
    if file.endswith(gFileExtension) and \
       file != gNameFileWithMetadata + ".txt":
      FileWithMetadata.write(os.path.realpath(dirpath) + ",")
      FileWithMetadata.write(file + "\n")
