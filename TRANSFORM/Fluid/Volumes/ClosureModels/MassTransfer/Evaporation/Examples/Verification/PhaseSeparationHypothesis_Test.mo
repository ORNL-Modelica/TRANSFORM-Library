within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Evaporation.Examples.Verification;
model PhaseSeparationHypothesis_Test
  import TRANSFORM;
  extends Modelica.Icons.Example;

  package Medium=Modelica.Media.Water.StandardWater;

  constant Integer n=10 "Number of different states";

  constant SI.Pressure p = 1e5 "Pressure to set states";
  constant SI.SpecificEnthalpy[n] h = linspace(1e4,3e6,n) "Specific enthalpy to set state";
  constant Medium.ThermodynamicState[n] states = {Medium.setState_ph(p,h[i]) for i in 1:n};

  constant SI.Area Ac = 1 "Cross sectional area";
  constant SI.Length d_e = 0.001 "Equivalent spherical bubble diameter";

  TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Evaporation.PhaseSeparationHypothesis[
    n] phaseSeparationHypothesis(
    redeclare package Medium = Medium,
    state=states,
    each Ac=Ac,
    each d_e=d_e)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=1));
end PhaseSeparationHypothesis_Test;
