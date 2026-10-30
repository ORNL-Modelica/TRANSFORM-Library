within TRANSFORM.Fluid.Interfaces.Examples;
model BaseProperties2Phase_Test
  extends TRANSFORM.Icons.Example;
  package Medium=Modelica.Media.Water.StandardWater;
  constant Integer n=10 "Number of different states";
  constant SI.Pressure p = 1e5 "Pressure to set states";
  constant SI.SpecificEnthalpy[n] h = linspace(1e5,3e6,n) "Specific enthalpy to set state";
  constant Medium.ThermodynamicState[n] states = {Medium.setState_ph(p,h[i]) for i in 1:n};
  Media.BaseProperties2Phase[n] medium2(
    redeclare package Medium = Medium,
    state=states,
    S=10) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseProperties2Phase_Test;
