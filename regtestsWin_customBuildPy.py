# -*- coding: utf-8 -*-
"""
Created on Mon Aug 14 09:49:13 2017

@author: vmg
"""

import os
import buildingspy.development.regressiontest as r
rt = r.Tester(check_html=False)#,tool="dymola")
LibPath  = os.path.join("TRANSFORM")
ResPath = LibPath
rt.showGUI(True)
rt.setLibraryRoot(LibPath, ResPath)
rt.setNumberOfThreads(1)
#rt.TestSinglePackage('Media.Solids.Examples.Hastelloy_N_Haynes', SinglePack=True)
rt.run()
