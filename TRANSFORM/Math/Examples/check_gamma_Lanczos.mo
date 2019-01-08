within TRANSFORM.Math.Examples;
model check_gamma_Lanczos

  extends TRANSFORM.Icons.Example;

  final parameter Integer n=10;

  Real[n] gamma_Matlab = {2.67893853470775, 1.35411793942640, 1.0,
                             0.892979511569249, 0.902745292950934, 1.0,
                             1.19063934875900, 1.50457548825156, 2.0,
                             2.77815848043767};

  Real[n] y "Function value";

  Utilities.ErrorAnalysis.UnitTests unitTests(
    x=y,
    x_reference=gamma_Matlab,
    n=10)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  for i in 1:10 loop
    y[i] = TRANSFORM.Math.gamma_Lanczos(
              z=i/3.0);
  end for;

  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end check_gamma_Lanczos;
