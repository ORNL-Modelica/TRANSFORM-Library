# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 13:12:28 2016

@author: Scott Greenwood
"""
# This finds all files with the '.mo' extension that reside in the directory.
# The all files and folders within directory will be searched.
# A text file lists all of the identified files.

import os


def findFiles(directory=None, f=None):
    with open('allMOFiles.txt', 'w') as outputFile:
        for root, dirs, files in os.walk(directory):
            for f in files:
                if f.endswith(".mo"):
                    print(os.path.join(root, f), file=outputFile)

    return

if __name__ == '__main__':
    directory = 'C:/Users/vmg\Documents/Modelica/TRANSFORM-Library/DependencyGraph/'
    findFiles(directory)
