within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Examples.TubesAndConduits.TwoPhase;
model LaminarTurbulent_MSLDetailed2

  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater;

  parameter SI.Pressure p=1e5;
  parameter Medium.SaturationProperties sat=Medium.setSat_p(p);
  parameter Medium.ThermodynamicState state=Medium.setBubbleState(sat, 1);
  parameter SIadd.NonDim x_abs[nFM]={0,1,5,10,20,30,40,50,60,70,80,90,100}/100;

  parameter Integer nFM=13;

  parameter SI.Length dimension=0.1;
  parameter SI.Area crossArea=0.25*pi*dimension^2;
  parameter SI.Length dlength=0.1;
  parameter SI.Height roughness=2.5e-5;

  parameter SI.MassFlowRate m_flow=1;

  Media.BaseProperties2Phase mediaProps(redeclare package Medium = Medium,
      state=state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  SI.ReynoldsNumber Re=m_flow*dimension/(mediaProps.mu_lsat*crossArea);
  SI.ReynoldsNumber Re_v=m_flow*dimension/(mediaProps.mu_vsat*crossArea);

  Real fRe2;
  Real fRe2_v;
  SI.PressureDifference dps[nFM];
  SI.PressureDifference dp_v;
  Real phi2[nFM]={
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Utilities.TwoPhaseFrictionMultiplier(
      x_abs[i],
      mediaProps.mu_lsat,
      mediaProps.mu_vsat,
      mediaProps.rho_lsat,
      mediaProps.rho_vsat) for i in 1:nFM};
equation

  fRe2 =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Turbulent_Local_Developed_SwameeJain(
    Re=Re,
    dimension=dimension,
    roughness=roughness);

  fRe2_v =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Turbulent_Local_Developed_SwameeJain(
    Re=Re_v,
    dimension=dimension,
    roughness=roughness);

  dps = dlength*mediaProps.mu_lsat*mediaProps.mu_lsat/(2*mediaProps.rho_lsat*
    dimension*dimension*dimension)*phi2*fRe2;

  dp_v = dlength*mediaProps.mu_vsat*mediaProps.mu_vsat/(2*mediaProps.rho_vsat*
    dimension*dimension*dimension)*fRe2_v;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LaminarTurbulent_MSLDetailed2;
