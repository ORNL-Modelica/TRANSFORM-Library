within TRANSFORM.Fluid.Machines.Examples;
model Compressor_SinglePhase_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.IdealGases.SingleGases.H2 "Working fluid";

    parameter Real efficiencyChar[6, 4]=[0, 95, 100, 105; 1, 82.5e-2, 81e-2,
      80.5e-2; 2, 84e-2, 82.9e-2, 82e-2; 3, 83.2e-2, 82.2e-2, 81.5e-2; 4,
      82.5e-2, 81.2e-2, 79e-2; 5, 79.5e-2, 78e-2, 76.5e-2];
  parameter Real flowChar[6, 4]=[0, 95, 100, 105; 1, 38.3e-3, 43e-3,
      46.8e-3; 2, 39.3e-3, 43.8e-3, 47.9e-3; 3, 40.6e-3, 45.2e-3, 48.4e-3;
      4, 41.6e-3, 46.1e-3, 48.9e-3; 5, 42.3e-3, 46.6e-3, 49.3e-3];
  parameter Real pressureChar[6, 4]=[0, 95, 100, 105; 1, 22.6, 27, 32; 2, 22,
      26.6, 30.8; 3, 20.8, 25.5, 29; 4, 19, 24.3, 27.1; 5, 17, 21.5, 24.2];

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT source(
    p=30000,
    T=293.15,
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
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
    p_a_start(displayUnit="bar") = 180000,
    p_b_start(displayUnit="bar") = 150000,
    T_a_start=1373.15,
    T_b_start=823.15,
    m_flow_start=5,
    redeclare package Medium = Medium,
    efficiencyChar=[0,0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65;
        0,1,1,1,1,1,1,1,1,1,1,1,1,1,1; 1.2,1,1,1,1,1,1,1,1,1,1,1,1,1,1; 1.4,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1; 1.8,1,1,1,1,1,1,1,1,1,1,1,1,1,1; 2.1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1],
    flowChar=[0,0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65; 1.2,
        1.5,1.41,1.355,1.305,1.26,1.22,1.18,1.15,1.13,1.105,1.088,1.076,1.07,1.068;
        1.4,1.5,1.42,1.37,1.33,1.29,1.255,1.225,1.195,1.17,1.152,1.135,1.12,1.115,
        1.108; 1.8,1.5,1.44,1.405,1.372,1.342,1.315,1.29,1.265,1.248,1.23,1.212,
        1.2,1.185,1.178; 2.1,1.5,1.45,1.425,1.402,1.38,1.36,1.34,1.322,1.307,1.29,
        1.275,1.265,1.255,1.245])
    annotation (Placement(transformation(extent={{22,-30},{42,-10}})));
  TRANSFORM.Electrical.PowerConverters.Generator_Basic generator
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  TRANSFORM.Fluid.Machines.Compressor_SinglePhase_Map compressor(
    redeclare package Medium = Medium,
    efficiencyChar=efficiencyChar,
    flowChar=flowChar,
    pressureChar=pressureChar)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume(
    redeclare package Medium = Medium,
    p_start=180000,
    T_start=1273.15,
    Q_gen=1e6)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(turbine.port_b, sink.ports[1])
    annotation (Line(points={{42,-14},{42,20},{46,20}},
                                                      color={0,127,255}));
  connect(turbine.shaft_b, generator.shaft) annotation (Line(points={{42,-20},{50,
          -20},{50,-20.1},{59.9,-20.1}}, color={0,0,0}));
  connect(turbine.shaft_a, compressor.shaft_b)
    annotation (Line(points={{22,-20},{-20,-20}}, color={0,0,0}));
  connect(source.ports[1], compressor.port_a) annotation (Line(points={{-52,0},
          {-48,0},{-48,-14},{-40,-14}}, color={0,127,255}));
  connect(volume.port_a, compressor.port_b) annotation (Line(points={{-6,0},{-14,
          0},{-14,-14},{-20,-14}}, color={0,127,255}));
  connect(volume.port_b, turbine.port_a) annotation (Line(points={{6,0},{14,0},{
          14,-14},{22,-14}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
<p>The is a comparison of the steam turbine results using the conditions and comparing the results specified in Example 7.6 in the source.</p>
<p><br>References:</p>
<p>Smith, J.M., Vand Ness, H.C., Abbott, M.M.m &apos;Introduction to Chemical Engineering Thermodynamics 7E,&apos;</p>
<p>pg. 269-270, Example 7.6, 2005.</p>
</html>"));
end Compressor_SinglePhase_Test;
