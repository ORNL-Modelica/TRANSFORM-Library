from pymodelica import compile_fmu
from pyfmi import load_fmu

libPath = r'C:\Users\vmg\Documents\Modelica\TRANSFORM-Library/TRANSFORM'
modelName = 'TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Examples.DistributedPipe_1D_MultiTransferSurface.check_Nus_SinglePhase_2Region_F1D_modelBased'

fmu = compile_fmu(modelName,libPath,target='cs')
model = load_fmu(fmu)

opts = model.simulate_options()
opts['time_limit'] = 60

results=model.simulate(options=opts)
