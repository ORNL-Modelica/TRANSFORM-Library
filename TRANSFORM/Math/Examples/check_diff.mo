within TRANSFORM.Math.Examples;
model check_diff
  extends TRANSFORM.Icons.Example;
  parameter Real u[:] = {1,2,5,10,20};
  parameter Real y[size(u,1)-1]=diff(u);
     TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=4,x=y)
       annotation (Placement(transformation(extent={{80,80},{100,100}})));
// equation
//    y =diff(u);
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end check_diff;
