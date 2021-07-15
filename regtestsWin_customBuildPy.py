# -*- coding: utf-8 -*-
"""
Created on Mon Aug 14 09:49:13 2017

@author: vmg
"""

import os
import buildingspy.development.regressiontest as r
rt = r.Tester(check_html=False)
LibPath = os.path.join("TRANSFORM")
ResPath = LibPath
rt.showGUI(False)
rt.setLibraryRoot(LibPath, ResPath)
rt.setNumberOfThreads(1)
#rt.TestSinglePackage('ClosedGeometry_Test', SinglePack=True)
rt.run()
