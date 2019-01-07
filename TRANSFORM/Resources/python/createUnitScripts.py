# -*- coding: utf-8 -*-
"""
Created on Tue Oct 24 14:57:15 2017

@author: vmg

Creates .mos files for regression testing.

1. Place this file in LIBRARYPATH\Resources\python
2. Update 'folderPath' and 'folderName'
3. Run
	- This will generate scripts at locatin: LIBRARYPATH\Resources\Scripts
4. To generate referece results run the buildingspy regression test (generates reference results in LIBRARYPATH\Resources\ReferenceResults

"""

import os
import re
import errno
import sys
import shutil

folderPath = r'C:\Users\vmg\Documents\Modelica\TRANSFORM-Library'
folderName = r'TRANSFORM'

#useVarNames=true to use variables names (i.e., x={varnames})
#rather than x index (i.e. unitTests.x[1]) for regression plotting
simEnv = 'Dymola'
useVarNames = False  #not yet finished: allows regression/plot variables to be name of variable rather than uniTest.x[]
promptWriteOver = False #=true to prompt user to overwrite .mos files else default writeover

#=true to delete result files that don't have a matching .mos generation script
cleanupRefRes = True   
folderNameRefResults=os.path.join(folderPath,folderName,'Resources','ReferenceResults',simEnv)

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise

def query_yes_no(question, default="no"):
    """Ask a yes/no question via raw_input() and return their answer.
 
    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).
 
    The "answer" return value is one of "yes" or "no".
    """
    valid = {"yes":"y", "y":"y",
             "no":"n", "n":"n"}
    if default == None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [y/n] "
    elif default == "no":
        prompt = " [y/n] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)
 
    while 1:
        sys.stdout.write(question + prompt)
        choice = raw_input().lower()
        if default is not None and choice == '':
            return default
        elif choice in valid.keys():
            if valid[choice] == 'y':
                return True
            else:
                return False
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "\
                             "(or 'y' or 'n').\n")

def cleanupRefResults(unitTests,folderName,folderNameRefResults,simEnv):
    print('Cleaning up Reference Results Folder: {}'.format(folderNameRefResults))
    
    unitTests_RefResName = []
    for i, val in enumerate(unitTests):
        line = val.replace('\\','_')
        if simEnv.capitalize() == 'Dymola':
            line = line.split('_'+simEnv.capitalize()+'_')[1]#'_Resources_Scripts_'+simEnv.capitalize()+'_')[1]
        else:
            print('Unsupported simEnv: {}'.format(simEnv))
            break
        line = '_'.join((folderName,line))
        unitTests_RefResName.append('.'.join((line,'txt')))
    
    filelist = [ f for f in os.listdir(folderNameRefResults) if f.endswith(".txt") ]

    for f in filelist:
        if f not in unitTests_RefResName:
            while True:
                try:
                    ans = raw_input('File below was not found:\n{}\n###Confirm deletion [y/n]'.format(f))
                except ValueError:
                    print("Invalid response. Please enter 'y' or 'n'")
                    continue
                if ans.lower() not in ('y','n'):
                    print("Invalid response. Please enter 'y' or 'n'")
                    continue
                else:
                    #we're ready to exit the loop.
                    break
            if ans.lower() == 'y':
                os.remove(os.path.join(folderNameRefResults, f))       

# Delete Scripts folder if it exists
scriptsPath = os.path.join(folderPath,folderName,'Resources/Scripts/')
if os.path.exists(scriptsPath):
    print('Deleting {}'.format(scriptsPath))
    shutil.rmtree(os.path.join(folderPath,folderName,'Resources/Scripts/'))

# Get list of all files within Examples folders
directory_list = list()
exclude = set(['Resources'])
for root, dirs, files in os.walk(os.path.join(folderPath,folderName), topdown=True):
    dirs[:] = [d for d in dirs if d not in exclude]
    for name in dirs:
        if name == "Examples":
            directory_list.append(os.path.join(root, name))
        else:
            pass

# Determine if model in directory list is a test by looking for the .Example; portion of icon extender
test_list = list()
for item in directory_list:
    for root, dirs, files in os.walk(item, topdown=False):
        files[:] = [f for f in files if f.endswith('.mo')]
        for name in files:
            with open(os.path.join(root,name), 'r') as fil:
                for line in fil:
                    if '.Example;' in line:
                        test_list.append(os.path.join(root, name))
                        break

# Delete runAll.mos file if it exists
if os.path.exists(os.path.join(folderPath,'runAll_Dymola.mos')):
    os.remove(os.path.join(folderPath,'runAll_Dymola.mos'))
    
# List of possible simulation parameters
expParameters = list()
expParameters.append('StartTime')
expParameters.append('StopTime')
expParameters.append('Interval')
expParameters.append('NumberOfIntervals')
expParameters.append('Tolerance')
expParameters.append('fixedstepsize')
expParameters.append('Algorithm')

expSim = list()
expSim.append('startTime')
expSim.append('stopTime')
expSim.append('outputInterval')
expSim.append('numberOfIntervals')
expSim.append('tolerance')
expSim.append('fixedstepsize')
expSim.append('method')

exp_dict = dict(zip(expParameters, expSim))

# Instantiate lists for tests that have errors in creating simulation files
unitTests_notFound = list()
equals_notFound = list()

# Loop through each test looking for simulation parameters, unitTests model,
# variables for regression, and create .mos simulation script
unitTests = []
for item in test_list:
    lines = list()
    line_list = list()

    with open(item, 'r') as fil:
        lines = fil.readlines()

    exp_list = dict()
    with open(item, 'r') as fil:
        for num, line in enumerate(fil, 1):
            # Search for if experiment parameters are defined
            if 'experiment(' in line:
                # lineNew=''.join(line.rstrip('\n').strip().replace('"','') for line in lines[num-1:]
                # line_list = re.findall(r'[^,;()]+',lineNew)
                line_list = re.findall(r'[^,;()]+',''.join(line.rstrip('\n').strip() for line in lines[num-1:])) #.replace('"','')
                line_list = [s.replace('__Dymola_','').replace(' ','') for s in line_list]
                
                # Search and return experiment setup parameters
                for param in expParameters:
                    for val in line_list:
                        if param == 'Interval' or param == 'NumberOfIntervals':
                            # Handles exception for Intervals being found in NumberOfIntervals
                            # and case where if one is not used it defaults to 0 if it had previously been defined
                            if param in val:
                                if 'NumberOfIntervals' in val:
                                    if not val.split('=')[1] == 0:
                                        exp_list['NumberOfIntervals'] = val.split('=')[1]
                                        if val.split('=')[1] < 100:
                                            print('Buildingspy requires NumberOfIntervals >= 100. Consider revising the simulation conditions for: {}'.format(item))
                                        break
                                else:
                                    if not val.split('=')[1] == 0:
                                        exp_list['Interval'] = val.split('=')[1]
                                        break
                        else:
                            if param in val:
                                exp_list[param] = val.split('=')[1]
                                break

    # Search for unitTests model in test return warning if not found
    found_unitTests = False
    lines_list = re.findall(r'[^;]+',''.join(line.rstrip('\n').strip() for line in lines))
    lines_unit = list()
    n = []
    x_list = list()
    for i in lines_list:
        if 'unitTests' in i:
            lines_unit = i.replace(' ', '')
            lines_unit = re.findall(r'[^()]+', lines_unit)
            found_unitTests = True
            break
    if not found_unitTests:
        unitTests_notFound.append(item)

    else:
        # Search for variables to be saved for regression tests from unitTests and return warning if not found
        found_equals = False
        if useVarNames:
            for i in lines_unit:
                if 'x=' in i:
                    line_x_list = re.findall(r'x={([^\}]*)}', i)
                    x_list = ''.join(line_x_list).split(',')  # need regexp to deal with all c, {,} [,] etc cases along lines of ,\s*(?![^[]*\])
                    found_equals = True
        else:
            for i in lines_unit:
                if 'n=' in i:
                    n = int(''.join(re.findall(r'n=([^\,]*)',i)))
                    found_equals = True
                if not found_equals:
                    n = 1
                    found_equals = True
        if not found_equals:
            equals_notFound.append(item)
            print('Value of interest, x, not found in unitTests for test: {}'.format(item))

    # Create simulation file from gathered parameters
    if found_unitTests and found_equals:
        modelName = os.path.splitext(os.path.basename(item))[0]
        modelSimPath = ''.join(re.findall(r'[^;]+', ''.join(lines[0].rstrip('\n'))))
        modelSimPath = re.sub('.*within', '', modelSimPath)  # handles strange characters that sometime show up
        modelSimPath = modelSimPath.replace(' ', '')
        plotSimPath = modelSimPath + '.' + modelName
        
        # Create directory (if not exist) to save location of script file.
        # Default path is what is specified in .mos file after 'within ...;'
        # with the first entry dropped, i.e., within LIB.Examples;' yields
        # mosPath = C:\FOLDERPATH\FOLDERNAME\Resources\Scripts\SIMENV\Examples
        mosPath = os.path.join(folderPath, folderName, 'Resources', 'Scripts', simEnv, '\\'.join(modelSimPath.split('.')[1:]))
        mkdir_p(mosPath)
        
        mosPath_jMod = os.path.join(folderPath, folderName, 'Resources', 'Scripts', 'jModelica', '\\'.join(modelSimPath.split('.')[1:]))
        mkdir_p(mosPath_jMod)
        
        # Create list of all generated unit tests
        unitTests.append(os.path.join(mosPath,modelName))
        if promptWriteOver:
            # Check if file .mos already exists and prompt user if they wish to replace it.
            if os.path.isfile(os.path.join(mosPath, modelName + '.mos')):
                writeFile = query_yes_no('File {} already exists. \n Do you wish to replace it?'.format(os.path.join(mosPath, modelName + '.mos')))
            if os.path.isfile(os.path.join(mosPath_jMod, modelName + '.py')):
                writeFile = query_yes_no('File {} already exists. \n Do you wish to replace it?'.format(os.path.join(mosPath_jMod, modelName + '.py')))
        else:
            writeFile = True

        if writeFile:
            with open(os.path.join(mosPath, modelName + '.mos'), 'w') as mosfil:
                # Write simulation instruction
                mosfil.write('simulateModel("{}",'.format(plotSimPath))
                for key, value in exp_list.items():
                    mosfil.write('{}={},'.format(exp_dict[key], value))

                mosfil.write('resultFile="{}");\n\n'.format(modelName))

                # Write plots commands for inclusion in regression
                if useVarNames:
                    for num, val in enumerate(x_list, 1):
                        mosfil.write('createPlot(id={}, y={{"{}"}}, grid=true);\n'.format(num, val))
                else:
                    for i in xrange(n):
                        mosfil.write('createPlot(id={}, y={{"unitTests.x[{}]"}}, grid=true);\n'.format(i+1, i+1))
                        
            with open(os.path.join(mosPath_jMod, modelName + '.py'), 'w') as mosfil:
                # Write simulation instruction
                mosfil.write('from pymodelica import compile_fmu\n')
                mosfil.write('from pyfmi import load_fmu\n')
                mosfil.write("\nlibPath = r'{}/{}'\n".format(folderPath,folderName))
                mosfil.write("modelName = '{}'\n".format(plotSimPath))
                mosfil.write("\nfmu = compile_fmu(modelName,libPath,target='cs')\n")
                mosfil.write("model = load_fmu(fmu)\n\n")
                mosfil.write("opts = model.simulate_options()\n")
                mosfil.write("opts['time_limit'] = 60\n")
                mosfil.write("\nresults=model.simulate(options=opts)\n")
#                if 'StartTime' in exp_list:
#                    temp = exp_list['StartTime']
#                else:
#                    temp = 0
#                mosfil.write("start_time = {}\n".format(temp)) 
#                
#                if 'StopTime' in exp_list:
#                    temp = exp_list['StopTime']
#                else:
#                    temp = 1
#                mosfil.write("final_time = {}\n".format(temp))  
                
#                mosfil.write('\n')
#                mosfil.write("result = model.simulate(start_time=start_time,final_time=final_time)\n")
                 
#                mosfil.write("result = model.simulate()\n")
                
            with open(os.path.join(folderPath,'runAll_Dymola.mos'), 'a') as mosDym:
                mosDym.write('simulateModel("{}",'.format(plotSimPath))
                for key, value in exp_list.items():
                    mosDym.write('{}={},'.format(exp_dict[key], value))
                mosDym.write('resultFile="{}");\n'.format(modelName))

if not unitTests_notFound == []:
    print('Some .mo recognized as examples did not contain the unitTests model. View variable "unitTests_notFound" for the complete list')

if cleanupRefRes:
    cleanupRefResults(unitTests,folderName,folderNameRefResults,simEnv)
