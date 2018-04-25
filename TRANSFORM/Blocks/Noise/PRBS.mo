within TRANSFORM.Blocks.Noise;
model PRBS "Pseudo-random Binary Sequence"
  parameter Real period=1 "Period of PRBS signal";
  parameter Real startTime=0 "Start Time for PRBS signal";
  parameter Real height=1 "Size of PRBS";
  parameter Real offset=0 "Floor of PRBS signal";
protected
  Modelica.Blocks.Noise.UniformNoise uniformNoise(
    y_min=-1,
    y_max=1,
    samplePeriod=period,
    startTime=startTime)
             annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
  Modelica.Blocks.Math.Sign sign1
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Modelica.Blocks.Math.Add add(k1=0.5)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.Constant const(k=0.5)
    annotation (Placement(transformation(extent={{-68,-40},{-48,-20}})));
public
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Modelica.Blocks.Math.Add add1(k1=height)
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  Modelica.Blocks.Sources.Constant const1(k=offset)
    annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
equation
  connect(uniformNoise.y, sign1.u)
    annotation (Line(points={{-75,0},{-70,0}}, color={0,0,127}));
  connect(sign1.y, add.u1) annotation (Line(points={{-47,0},{-34,0},{-34,6},{-22,
          6}}, color={0,0,127}));
  connect(const.y, add.u2)
    annotation (Line(points={{-47,-30},{-22,-30},{-22,-6}}, color={0,0,127}));
  connect(add.y, add1.u1)
    annotation (Line(points={{1,0},{10,0},{10,6},{42,6}}, color={0,0,127}));
  connect(const1.y, add1.u2) annotation (Line(points={{13,-30},{20,-30},{20,-6},
          {42,-6}}, color={0,0,127}));
  connect(add1.y, y)
    annotation (Line(points={{65,0},{84,0},{84,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PRBS;
