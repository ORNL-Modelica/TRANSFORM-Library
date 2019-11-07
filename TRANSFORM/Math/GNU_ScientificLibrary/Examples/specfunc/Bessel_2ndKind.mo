within TRANSFORM.Math.GNU_ScientificLibrary.Examples.specfunc;
model Bessel_2ndKind
  extends TRANSFORM.Icons.Example;

  Modelica.Blocks.Sources.Ramp ramp(
    startTime=0,
    height=19,
    duration=19,
    offset=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Models.specfunc.Bessel_Yn besselY0(n=0, x=ramp.y)
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Models.specfunc.Bessel_Yn besselY1(n=1, x=ramp.y)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Models.specfunc.Bessel_Yn besselY2(n=2, x=ramp.y)
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Models.specfunc.Bessel_Kn besselK0(n=0, x=ramp.y)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Models.specfunc.Bessel_Kn besselK1(n=1, x=ramp.y)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Models.specfunc.Bessel_Kn besselK2(n=2, x=ramp.y)
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=20,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end Bessel_2ndKind;
