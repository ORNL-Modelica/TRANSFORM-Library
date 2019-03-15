within TRANSFORM.Fluid.Machines.Examples;
model Turbine_SinglePhase_Test2
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.IdealGases.SingleGases.H2 "Working fluid";

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT source(
    p=182000,
    nPorts=1,
    T=1373.15,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-48,12},{-28,32}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink(
    nPorts=1,
    use_p_in=false,
    p(displayUnit="bar") = 152000,
    T=823.15,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{66,30},{46,10}})));
  inner TRANSFORM.Fluid.System
                  system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TRANSFORM.Fluid.Machines.Turbine_SinglePhase_Map turbine(
    p_a_start(displayUnit="kPa") = 8e5,
    p_b_start(displayUnit="kPa") = 1.5e5,
    T_a_start=1373.15,
    T_b_start=823.15,
    m_flow_start=5,
    redeclare package Medium = Medium,
    efficiencyChar=[0,0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,
        0.65; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1; 1.2,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
        1.4,1,1,1,1,1,1,1,1,1,1,1,1,1,1; 1.8,1,1,1,1,1,1,1,1,1,1,1,1,1,1; 2.1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1],
    flowChar=[0,0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65;
        1.2,1.5,1.41,1.355,1.305,1.26,1.22,1.18,1.15,1.13,1.105,1.088,1.076,
        1.07,1.068; 1.4,1.5,1.42,1.37,1.33,1.29,1.255,1.225,1.195,1.17,1.152,
        1.135,1.12,1.115,1.108; 1.8,1.5,1.44,1.405,1.372,1.342,1.315,1.29,1.265,
        1.248,1.23,1.212,1.2,1.185,1.178; 2.1,1.5,1.45,1.425,1.402,1.38,1.36,
        1.34,1.322,1.307,1.29,1.275,1.265,1.255,1.245])
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.Electrical.PowerConverters.Generator_Basic generator
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
equation
  connect(source.ports[1], turbine.port_a) annotation (Line(points={{-28,22},{-10,
          22},{-10,6}},                   color={0,127,255}));
  connect(turbine.port_b, sink.ports[1])
    annotation (Line(points={{10,6},{10,20},{46,20}}, color={0,127,255}));
  connect(generator.shaft, turbine.shaft_b) annotation (Line(points={{23.9,-0.1},
          {16.95,-0.1},{16.95,0},{10,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
<p>The is a comparison of the steam turbine results using the conditions and comparing the results specified in Example 7.6 in the source.</p>
<p><br>References:</p>
<p>Smith, J.M., Vand Ness, H.C., Abbott, M.M.m &apos;Introduction to Chemical Engineering Thermodynamics 7E,&apos;</p>
<p>pg. 269-270, Example 7.6, 2005.</p>
</html>"));
end Turbine_SinglePhase_Test2;
