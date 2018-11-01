from pymodelica import compile_fmu
from pyfmi import load_fmu

libPath = r'C:\Users\vmg\Documents\Modelica\External\TRANSFORM-Library/TRANSFORM'
modelName = 'TRANSFORM.Nuclear.ReactorKinetics.Examples.Functions.Initial_powerBased_powerHistory'

fmu = compile_fmu(modelName,libPath,target='cs')
model = load_fmu(fmu)

opts = model.simulate_options()
opts['time_limit'] = 60

results=model.simulate(options=opts)
