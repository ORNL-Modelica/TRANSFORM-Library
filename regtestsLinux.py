import os
import buildingspy.development.regressiontest as r
rt = r.Tester(check_html=False)
myMoLib = os.path.join("TRANSFORM")
rt.setLibraryRoot(myMoLib)
#rt.showGUI(False)
rt.setNumberOfThreads(2)
rt.run() 