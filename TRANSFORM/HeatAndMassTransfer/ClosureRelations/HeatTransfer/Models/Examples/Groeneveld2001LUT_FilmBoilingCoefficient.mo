within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Examples;
model Groeneveld2001LUT_FilmBoilingCoefficient

  extends TRANSFORM.Icons.Example;

  SDF.NDTable alpha(
    readFromFile=true,
    interpMethod=SDF.Types.InterpolationMethod.Akima,
    extrapMethod=SDF.Types.ExtrapolationMethod.Linear,
    nin=4,
    filename=Modelica.Utilities.Files.loadResource(
        "modelica://TRANSFORM/Resources/Data/2001LUTFB.sdf"),
    dataset="/alpha",
    dataUnit="W/(m2.K)",
    scaleUnits={"1","K","kg/(m2.s)","Pa"})
    "Outputs predicted film boiling heat transfer coefficient [W/(m2.K)]"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine G(
    amplitude=4000,
    freqHz=1/10,
    offset=4000)
              "mass flux [kg/(m2.s)]"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.Sine x(
    amplitude=0.75,
    offset=0.25,
    freqHz=2)     "thermodynamic quality"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.Sine P(
    amplitude=10.5e6,
    offset=10.55e6,
    freqHz=10)     "pressure [Pa]"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=5, x={x.y,dT.y,G.y,P.y,
        alpha.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Sine dT(
    offset=600,
    freqHz=1,
    amplitude=650) "T_wall - T_sat"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
algorithm

equation
  connect(x.y, alpha.u[1]) annotation (Line(points={{-39,-50},{-20,-50},{-20,
          -1.5},{-12,-1.5}}, color={0,0,127}));
  connect(dT.y, alpha.u[2]) annotation (Line(points={{-39,-20},{-28,-20},{-28,
          -0.5},{-12,-0.5}}, color={0,0,127}));
  connect(G.y, alpha.u[3]) annotation (Line(points={{-39,20},{-28,20},{-28,0.5},
          {-12,0.5}}, color={0,0,127}));
  connect(P.y, alpha.u[4]) annotation (Line(points={{-39,50},{-20,50},{-20,1.5},
          {-12,1.5}}, color={0,0,127}));
  annotation (experiment(StopTime=10));
end Groeneveld2001LUT_FilmBoilingCoefficient;
