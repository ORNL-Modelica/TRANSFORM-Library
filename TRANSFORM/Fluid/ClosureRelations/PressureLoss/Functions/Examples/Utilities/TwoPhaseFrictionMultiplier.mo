within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Examples.Utilities;
model TwoPhaseFrictionMultiplier
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater;
  parameter Integer nP=9;
  parameter Integer nX=12;
  parameter SI.Pressure ps[nP]={1.01,6.89,34.4,68.9,103,138,172,207,221.2}*1e5;
  parameter SIadd.NonDim x_abs[nX]={1,5,10,20,30,40,50,60,70,80,90,100}/100;
  parameter SI.SpecificEnthalpy hs[nX,9]={{Medium.bubbleEnthalpy(
      Medium.setSat_p(ps[j])) .* (1 - x_abs[i]) + Medium.dewEnthalpy(
      Medium.setSat_p(ps[j])) .* x_abs[i] for j in 1:nP} for i in 1:nX};
  parameter Medium.ThermodynamicState states[nX,nP]={{Medium.setState_ph(ps[j],
      hs[i, j]) for j in 1:nP} for i in 1:nX};
  Real phi2[nX,nP];
  Real diff = sum(abs(phi2 - data))/(nX*nP);
  Media.BaseProperties2Phase mediaProps[nX,nP](redeclare package Medium =
        Medium, state=states)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
protected
  Real data[nX,nP]=[
      16.21,3.40,1.44,1.19,1.10,1.05,1.04,1.01,1;
      67.6,12.18,3.12,1.89,1.49,1.28,1.16,1.06,1;
      121.2,21.8,5.06,2.73,1.95,1.56,1.3,1.13,1;
      212.2,38.7,7.8,4.27,2.81,2.08,1.60,1.25,1;
      292.8,53.5,11.74,5.71,3.6,2.57,1.87,1.36,1;
      366,67.3,14.7,7.03,4.36,3.04,2.14,1.48,1;
      435,80.2,17.45,8.3,5.08,3.48,2.41,1.6,1;
      500,92.4,20.14,9.5,5.76,3.91,2.67,1.71,1;
      563,104.2,22.7,10.7,6.44,4.33,2.89,1.82,1;
      623,115.7,25.1,11.81,7.08,4.74,3.14,1.93,1;
      682,127,27.5,12.9,7.75,5.21,3.37,2.04,1;
      738,137.4,29.8,13.98,8.32,5.52,3.60,2.14,1];
public
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={phi2[4, 1],diff})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  phi2 =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Utilities.TwoPhaseFrictionMultiplier(
    x_abs=mediaProps.x_abs,
    mu_lsat=mediaProps.mu_lsat,
    mu_vsat=mediaProps.mu_vsat,
    rho_lsat=mediaProps.rho_lsat,
    rho_vsat=mediaProps.rho_vsat);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100));
end TwoPhaseFrictionMultiplier;
