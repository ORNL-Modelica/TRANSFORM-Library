within TRANSFORM.Math.Examples;
model check_replaceArrayValues
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  parameter Real array[:] = {1,2,1,2,1,2};
  parameter Integer iReplace[2] = {3,1};
  parameter Real valueR[size(iReplace,1)] = {-1,-2};
  Real y[size(array,1)];
   TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=6,x=y)
     annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =replaceArrayValues(array, iReplace, valueR);
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end check_replaceArrayValues;
