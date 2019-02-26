within TRANSFORM.Fluid.Machines.Examples;
model Compressor_SinglePhase_Test2
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
    use_p_in=false,
    p(displayUnit="bar") = 180000,
    T=293.15,
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{66,30},{46,10}})));
  inner TRANSFORM.Fluid.System
                  system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TRANSFORM.Fluid.Machines.Compressor_SinglePhase_Map compressor(
    redeclare package Medium = Medium,
    efficiencyChar=efficiencyChar,
    flowChar=flowChar,
    pressureChar=pressureChar,
    scale_u2=1/100)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed=
        3000/60*3.14159)
    annotation (Placement(transformation(extent={{50,-40},{30,-20}})));
equation
  connect(source.ports[1], compressor.port_a) annotation (Line(points={{-52,0},
          {-48,0},{-48,-14},{-40,-14}}, color={0,127,255}));
  connect(compressor.port_b, sink.ports[1]) annotation (Line(points={{-20,-14},
          {12,-14},{12,20},{46,20}}, color={0,127,255}));
  connect(constantSpeed.flange, compressor.shaft_b) annotation (Line(points={{
          30,-30},{6,-30},{6,-20},{-20,-20}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
<p>The is a comparison of the steam turbine results using the conditions and comparing the results specified in Example 7.6 in the source.</p>
<p><br>References:</p>
<p>Smith, J.M., Vand Ness, H.C., Abbott, M.M.m &apos;Introduction to Chemical Engineering Thermodynamics 7E,&apos;</p>
<p>pg. 269-270, Example 7.6, 2005.</p>
</html>"));
end Compressor_SinglePhase_Test2;
