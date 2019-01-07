within TRANSFORM.Math.Examples;
model check_xor
  extends TRANSFORM.Icons.Example;

  parameter Integer u1[:] = {1,0,1,0,0};
  parameter Integer u2[size(u1,1)] = {0,1,1,0,1};

   Integer y[size(u1,1)];

     TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=5,x=y)
       annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
   y =xor(u1, u2);


  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end check_xor;
