within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.CHF;
model Groeneveld2006LUT

  SDF.NDTable
          diode(
    nin=3,
    readFromFile=true,
    dataUnit="W/m2",
    scaleUnits={"kg/(m2.s)","1","Pa"},
    interpMethod=SDF.Types.InterpolationMethod.Akima,
    extrapMethod=SDF.Types.ExtrapolationMethod.Linear,
    dataset="/q",
    filename=Modelica.Utilities.Files.loadResource(
        "modelica://TRANSFORM/Resources/Data/2006LUT.sdf"))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp G(
    duration=1,
    height=5000,
    offset=1000)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.Ramp x(
    duration=1,
    startTime=0.1,
    height=1,
    offset=-0.4)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    startTime=0.1,
    height=1e6,
    offset=1e5)
    annotation (Placement(transformation(extent={{-58,-64},{-38,-44}})));
algorithm

equation
  connect(G.y, diode.u[1]) annotation (Line(points={{-39,20},{-26,20},{-26,
          -1.33333},{-12,-1.33333}}, color={0,0,127}));
  connect(x.y, diode.u[2]) annotation (Line(points={{-39,-20},{-26,-20},{-26,0},
          {-12,0}}, color={0,0,127}));
  connect(P.y, diode.u[3]) annotation (Line(points={{-37,-54},{-28,-54},{-28,
          -28},{-12,-28},{-12,1.33333}}, color={0,0,127}));
end Groeneveld2006LUT;
