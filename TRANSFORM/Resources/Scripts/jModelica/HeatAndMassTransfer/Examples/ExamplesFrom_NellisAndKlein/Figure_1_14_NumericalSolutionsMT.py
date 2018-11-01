from pymodelica import compile_fmu
from pyfmi import load_fmu

libPath = r'C:\Users\vmg\Documents\Modelica\External\TRANSFORM-Library/TRANSFORM'
modelName = 'TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein.Figure_1_14_NumericalSolutionsMT'

fmu = compile_fmu(modelName,libPath,target='cs')
model = load_fmu(fmu)

opts = model.simulate_options()
opts['time_limit'] = 60

results=model.simulate(options=opts)
