within TRANSFORM.Math.GNU_ScientificLibrary.Examples.specfunc;
model Bessel_1stKind
  extends TRANSFORM.Icons.Example;

  Modelica.Blocks.Sources.Ramp ramp(
    duration=20,
    startTime=0,
    height=20)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Models.specfunc.Bessel_J0 bessel_J0(x=ramp.y)
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Models.specfunc.Bessel_Jn besselJ0(n=0, x=ramp.y)
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Models.specfunc.Bessel_Jn besselJ1(n=1, x=ramp.y)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Models.specfunc.Bessel_Jn besselJ2(n=2, x=ramp.y)
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Models.specfunc.Bessel_In besselI0(n=0, x=ramp.y)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Models.specfunc.Bessel_In besselI1(n=1, x=ramp.y)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Models.specfunc.Bessel_In besselI2(n=2, x=ramp.y)
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=20,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end Bessel_1stKind;
