# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 15:10:36 2016

@author: Scott Greenwood
"""

# This file searches a modelica '.mo' file for all "extends" clauses.
# Once an instance of extends is found everything after extend
# until the first semicolon (;) is saved.
#
# - fullFile is the file name
#
# - useDIRName and DIRName: for sourceName variable
#    uses the directory from fullFile and converts to Modelica syntax
#    i.e.,
#    if useDIRName = True & if DIRName = '/Fluids/' then
#    C:/Modelica/Fluids/Component.mo => Fluids.Component
#    elseif useDIRName = False then
#    C:/Modelica/Fluids/Component.mo => Component
#
# - usePeriod:
#    toggles returning just the last entry in extends in the result variable
#    i.e.,
#    if usePeriod = True then
#    extends Modelica.Fluids.Component(stuff) "comments" annotation(stuff);
#        => Component
#    elseif usePeriod = False then
#    extends Modelica.Fluids.Component(stuff) "comments" annotation(stuff);
#        => Modelica.Fluids.Component

import re


def searchFile(fullFile=None, useDIRName=False, DIRName=None, usePeriod=False):
    # === 1. ===
    # Extract file name based on if full path or just filename with extension
    indexMO = fullFile.find('.mo')
    isFullPath = fullFile.find('C:/')
    if isFullPath != -1:
        fullFile_reversed = fullFile[::-1]
        indexStart = len(fullFile) - fullFile_reversed.index('/')
        fileName = fullFile[indexStart:indexMO]
    else:
        fileName = fullFile[0:indexMO]

    sourceName = fileName

    if useDIRName:
        # Extract full source file name starting with TRANSFORM
        indexMO = fullFile.find('.mo')
        isFullPath = fullFile.find(DIRName)
        if isFullPath != -1:
            indexStart = isFullPath
            sourceNameSlash = fullFile[indexStart+1:indexMO]
            sourceName = sourceNameSlash.replace('/', '.')
        else:
            sourceName = fileName

    # Load all text with file and create a list to remove '\n' references
    with open(fullFile, 'r') as f:
        lines = f.read().splitlines()

    # Convert list back to string
    st = ''.join(lines)

    # === 2. ===
    # Return a list of everything after extends and before the semicolon
    result_list = re.findall(r'extends (.*?);', st)

    # === 3. ===
    result_full = []

    # Extract just the model name by only using information before the first
    # parenthesis (if one is present)
    for i in range(0, len(result_list)):
        list_value = result_list[i]
        try:
            indexParenth = list_value.index('(')
            result_full.append(list_value[0:indexParenth])
        except:
            result_full.append(list_value)

    # === 4. ===
    # Some extends belong to items like functions. These are not of interest
    # and can be identified by a ' ' or lack thereof.
    result_space = []
    for i in range(0, len(result_full)):
        noSpace_value = result_full[i]
        try:
            noSpace_value.index(' ')
        except:
            result_space.append(noSpace_value)

    if usePeriod:
        # Extract just the model name by identifying the path with the last '.'
        result_period = []
        for i in range(0, len(result_space)):
            full_value = result_space[i]
            full_value_reversed = full_value[::-1]
            try:
                indexPeriod = len(full_value) - full_value_reversed.index('.')
                result_period.append(full_value[indexPeriod:])
            except:
                result_period.append(full_value)
        resultName = result_period
    else:
        resultName = result_space

    # === 5. ===
    # Generate output file
    with open('Dependencies/Dep{}.txt'.format(fileName), 'w') as outputFile:
        for i in range(0, len(resultName)):
            print('"{}" -> "{}";'.format(sourceName, resultName[i]),
                  file=outputFile)

if __name__ == '__main__':
    fullFile = 'C:/Users/vmg/Documents/Modelica/TRANSFORM-Library/TRANSFORM/Fluid/Pipes/StraightDynamicPipe.mo'
    searchFile(fullFile)
#    fullFile = 'StraightDynamicPipe.mo'
#    searchFile(fullFile)
