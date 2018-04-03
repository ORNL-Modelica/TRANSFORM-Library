within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Examples.Models;
model Groeneveld2006LUT

  extends TRANSFORM.Icons.Example;

  SDF.NDTable q(
    nin=3,
    readFromFile=true,
    dataUnit="W/m2",
    scaleUnits={"kg/(m2.s)","1","Pa"},
    interpMethod=SDF.Types.InterpolationMethod.Akima,
    extrapMethod=SDF.Types.ExtrapolationMethod.Linear,
    dataset="/q",
    filename=Modelica.Utilities.Files.loadResource(
        "modelica://TRANSFORM/Resources/Data/2006LUT.sdf"))
    "Outputs predicted CHF heat flux [W/m2]"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine G(
    amplitude=4000,
    freqHz=1/10,
    offset=4000)
              "mass flux [kg/(m2.s)]"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Sine x(
    amplitude=0.75,
    freqHz=1,
    offset=0.25)  "thermodynamic quality"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Sine P(
    amplitude=10.5e6,
    offset=10.55e6,
    freqHz=10)     "pressure [Pa]"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={G.y,x.y,P.y,q.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
algorithm

equation
  connect(P.y, q.u[3]) annotation (Line(points={{-39,30},{-30,30},{-30,1.33333},
          {-12,1.33333}}, color={0,0,127}));
  connect(x.y, q.u[2])
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  connect(G.y, q.u[1]) annotation (Line(points={{-39,-30},{-30,-30},{-30,-1.33333},
          {-12,-1.33333}}, color={0,0,127}));
  annotation (experiment(StopTime=10));
end Groeneveld2006LUT;
