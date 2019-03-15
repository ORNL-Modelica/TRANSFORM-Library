within TRANSFORM.Math.Examples;
model check_psi
  extends TRANSFORM.Icons.Example;

  Real y "Function value";
  Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

    y = TRANSFORM.Math.psi(x=time-2,nk=10);

  annotation (experiment(StopTime=4), __Dymola_experimentSetupOutput);
end check_psi;
