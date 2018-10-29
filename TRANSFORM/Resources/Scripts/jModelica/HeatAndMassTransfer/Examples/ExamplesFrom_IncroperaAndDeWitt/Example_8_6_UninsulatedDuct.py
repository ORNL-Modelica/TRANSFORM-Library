from pymodelica import compile_fmu
from pyfmi import load_fmu

libPath = r'C:\Users\vmg\Documents\Modelica\TRANSFORM-Library/TRANSFORM'
modelName = 'TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_IncroperaAndDeWitt.Example_8_6_UninsulatedDuct'

fmu = compile_fmu(modelName,libPath,target='cs')
model = load_fmu(fmu)

result = model.simulate()
