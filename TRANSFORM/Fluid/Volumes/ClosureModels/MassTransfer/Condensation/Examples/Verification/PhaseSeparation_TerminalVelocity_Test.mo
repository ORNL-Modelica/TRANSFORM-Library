within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Condensation.Examples.Verification;
model PhaseSeparation_TerminalVelocity_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium=Modelica.Media.Water.StandardWater;
  constant Integer n=10 "Number of different states";
  constant SI.Pressure p = 1e5 "Pressure to set states";
  constant SI.SpecificEnthalpy[n] h = linspace(3e6,1e5,n) "Specific enthalpy to set state";
  constant Medium.ThermodynamicState[n] states = {Medium.setState_ph(p,h[i]) for i in 1:n};
  constant SI.Area Ac = 1 "Cross sectional area";
  constant SI.Length d_e = 0.001 "Equivalent spherical bubble diameter";
  TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Condensation.PhaseSeparation_TerminalVelocity[
    n] phaseSeparationHypothesis(
    redeclare package Medium = Medium,
    state=states,
    each V_fluid=1,
    each L_c=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=1));
end PhaseSeparation_TerminalVelocity_Test;
