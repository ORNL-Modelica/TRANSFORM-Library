within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes.Examples;
model Integral
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  //parameter Real Vfrac_liquid = 0.5;
  TRANSFORM.Units.NonDim Vfrac_liquid=variableVfrac_liquid.y;
  parameter SI.Length r_1 = 1.25;
  parameter SI.Length r_2 = 1.5;
  parameter SI.Length r_3 = 1.5;
  parameter SI.Length h_1 = 1.25;
  parameter SI.Length h_2 = 0.75;
  final parameter SI.Volume V = pi*r_1^2*h_1 + pi*r_2^2*h_2 + 2/3*pi*r_3^3;
  TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes.Integral
    integral(
    Vfrac_liquid=Vfrac_liquid,
    V_liquid=V*Vfrac_liquid,
    V_vapor=V*(1 - Vfrac_liquid),
    r_1=r_1,
    h_1=h_1,
    r_2=r_2,
    h_2=h_2,
    r_3=r_3)
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  Modelica.Blocks.Sources.Sine variableVfrac_liquid(
    f=0.5,
    amplitude=0.9,
    offset=0.05) annotation (Placement(transformation(extent={{-10,
            20},{10,40}})));
  annotation (Documentation(info="<html>
<p>The various volumes and areas should balance the total volumes and total areas.</p>
<p>One thing that has be found was that depending on where the fraction of liquid starts, there is a potential</p>
<p>for the incorrect solution to be found due to the nonlinear behavior of the equations in some regions (e.g., spherical cap).</p>
<p><br>Also, behavior at fractional liquid volume of 0 causes potential problems (see level variable) and until fixed liquid volumes of 0 or 1 should be avoided.</p>
</html>"));
end Integral;
