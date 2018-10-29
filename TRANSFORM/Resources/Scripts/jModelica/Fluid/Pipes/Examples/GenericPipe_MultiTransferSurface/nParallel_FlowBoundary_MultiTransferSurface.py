from pymodelica import compile_fmu
from pyfmi import load_fmu

libPath = r'C:\Users\vmg\Documents\Modelica\TRANSFORM-Library/TRANSFORM'
modelName = 'TRANSFORM.Fluid.Pipes.Examples.GenericPipe_MultiTransferSurface.nParallel_FlowBoundary_MultiTransferSurface'

fmu = compile_fmu(modelName,libPath,target='cs')
model = load_fmu(fmu)

result = model.simulate()
