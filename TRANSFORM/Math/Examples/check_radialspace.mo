within TRANSFORM.Math.Examples;
model check_radialspace
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  Real y[5];

   TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=5, x=y)
     annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =radialspace(0,1,5);


  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end check_radialspace;
