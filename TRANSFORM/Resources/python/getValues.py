# -*- coding: utf-8 -*-
"""
Created on Wed Sep 26 14:26:05 2018

@author: vmg

This returns a specific index value from the time dependent data (variables)
for a give component and prints the specified file name if desired.

The idea is to provide a repeatable way to extract initial conditions for
copying back into the Modelca model.
"""

import numpy as np
from buildingspy.io.outputfile import Reader

def writeValues(components,results,fileName='returnValues.txt'):
    '''
Create a file with minimal/zero formatting
    '''
    with open(fileName,'w') as fil:
        for c in components:
            fil.write('{}\n'.format(c))
            for key, value in results[c].items():
                
                # Condense values, arrays, etc. into single line
                line = ','.join(str(value).split()).replace('[','{').replace(']','}')
                
                # Remove extraneous ','
                line = line.replace(',}','}')
                line = line.replace('{,','{')
                
                # Write the file
                fil.write('{} = {}\n'.format(key,line))
       
        
def writeValues_MOFormatted(components,results,fileName='returnValues.txt',unitMap={'p':'SI.Pressure','T':'SI.Temperature','h':'SI.SpecificEnthalpy','d':'SI.Density'},fullName=False):
    '''
Create a file with formatting for Modelica files
    '''
    with open(fileName,'w') as fil:
        for c in components:
            fil.write('//{}\n'.format(c))
            for key, value in results[c].items():
                
                # Condense values, arrays, etc. into single line
                line = ','.join(str(value).split()).replace('[','{').replace(']','}')
                
                #Remove extraneous ','
                line = line.replace(',}','}')
                line = line.replace('{,','{')
                
                # Create new key with formating
                if not fullName:
                    c = c.split('.')[0]
                newKey = key + '_start_{}'.format(c).replace('.','_')
                
                # Assign units if foundin the mapped unit dictionary
                unit = ''
                if key in unitMap:
                    unit = unitMap[key]
                else:
                    unit = 'Real'
                    
                # Add notation for array variable
                suffix = ''
                if '{' in line:
                    suffix = '[:]'
                    
                # Write the file
                fil.write('parameter {} {}{} = {} annotation(Dialog(tab="Initialization"));\n'.format(unit,newKey,suffix,line))
   
             
def GenericPipe(r,components = ['pipe'],keyword='mediums',variables = ['p','T','h','d'],iGet=-1,fileName='returnValues.txt',writeToFile = False):
    resultsFull = {}
    results = {}   
    
    for c in components:
        resultsFull[c] = dict.fromkeys(variables)
        results[c] = dict.fromkeys(variables)
        
        # Check for component
        if r.varNames('{}.{}\[1].{}'.format(c,keyword,variables[0])):
            
            # Get number of elements
            nI = int(r.values('{}.geometry.nV'.format(c))[1][0])
            
            # Get length of simulation results
            nt = len(r.values('{}.{}[1].{}'.format(c,keyword,variables[0]))[0])
            
            # Store results in a matrix
            for v in variables:
                temp = np.ndarray((nI,nt))
                for i in range(nI):
                    temp[i,:] = r.values('{}.{}[{}].{}'.format(c,keyword,i+1,v))[1]
                resultsFull[c][v] = temp
                results[c][v] = temp[:,iGet]
                
        else:
            print('No results found for {}'.format(c))
    
    if writeToFile:
        writeValues(components,results,fileName)
    
    return results


def SimpleVolume(r,components = ['pipe'],keyword='medium',variables = ['p','T','h','d'],iGet=-1,fileName='returnValues.txt',writeToFile = False):
    resultsFull = {}
    results = {}
    
    for c in components:
        resultsFull[c] = dict.fromkeys(variables)
        results[c] = dict.fromkeys(variables)
                      
        # Check for component    
        if r.varNames('{}.{}.{}'.format(c,keyword,variables[0])):
            
            # Store results in a matrix
            for v in variables:
                temp = r.values('{}.{}.{}'.format(c,keyword,v))[1]
                resultsFull[c][v] = temp
                results[c][v] = temp[iGet]
                
        else:
            print('No results found for {}'.format(c))
    
    if writeToFile:
            writeValues(components,results,fileName)
    
    return results


def Cylinder_FD(r,components = ['cylinder'],keyword='solutionMethod', variables = ['Ts'],iGet=-1,fileName='returnValues.txt',writeToFile = True):
    resultsFull = {}
    results = {}
    
    for c in components:
        resultsFull[c] = dict.fromkeys(variables)
        results[c] = dict.fromkeys(variables)
        
        # Check for component
        if r.varNames('{}.{}.{}\[1, 1]'.format(c,keyword,variables[0])):
            
            # Get number of elements per dimension
            nI = int(r.values('{}.nR'.format(c))[1][0])
            nJ = int(r.values('{}.nZ'.format(c))[1][0])
            
            # Get length of simulation results
            nt = len(r.values('{}.{}.{}[1, 1]'.format(c,keyword,variables[0]))[0])
            
            # Store results in a matrix
            for v in variables:
                temp = np.ndarray((nI,nJ,nt))
                for i in range(nI):
                    for j in range(nJ):
                        temp[i,j,:] = r.values('{}.{}.{}[{}, {}]'.format(c,keyword,v,i+1,j+1))[1]
                resultsFull[c][v] = temp
                results[c][v] = temp[:,:,iGet]
                
        else:
            print('No results found for {}'.format(c))
    
    if writeToFile:
        writeValues(components,results,fileName)
    
    return results


if __name__ == "__main__":
    r = Reader('GenericModule2.mat','dymola')
    
    components_GenericPipe = ['core.coolantSubchannel','hotLeg','coldLeg']
    components_SimpleVolume = ['inletPlenum','outletPlenum']
    components = components_GenericPipe + components_SimpleVolume
    
    results = {}
    results.update(GenericPipe(r,components_GenericPipe))
    results.update( SimpleVolume(r,components_SimpleVolume))
    
    writeValues(components,results)
    writeValues_MOFormatted(components,results)