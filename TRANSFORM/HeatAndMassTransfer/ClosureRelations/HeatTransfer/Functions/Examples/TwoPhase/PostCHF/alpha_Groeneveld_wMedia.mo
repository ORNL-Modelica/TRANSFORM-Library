within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.Examples.TwoPhase.PostCHF;
model alpha_Groeneveld_wMedia
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater;
  parameter SI.Pressure p=15e6;
  parameter SIadd.NonDim x_abs=0.4;
  parameter SI.SpecificEnthalpy h=Medium.bubbleEnthalpy(Medium.setSat_p(p))*(1
       - x_abs) + Medium.dewEnthalpy(Medium.setSat_p(p))*x_abs;
  parameter SI.Velocity v=3;
  parameter Medium.ThermodynamicState state=Medium.setState_ph(p, h);
  //SIadd.NonDim x_abs = 0.4 "Absolute quality";
  SI.DynamicViscosity mu_vsat=mediaProps.mu_vsat
    "Vapor phase saturated dynamic viscosity";
  SI.Density rho_lsat=mediaProps.rho_lsat "Saturated liquid density";
  SI.Density rho_vsat=mediaProps.rho_vsat "Saturated vapor density";
  SI.ThermalConductivity lambda_vsat=mediaProps.lambda_vsat
    "Vapor phase thermal conductivity";
  SI.PrandtlNumber Pr_vw=mediaProps.mu_vsat*mediaProps.cp_vsat/mediaProps.lambda_vsat
    "Prandtl number for the vapor at the wall temperature";
  SI.Length D_hyd=0.012 "Hydraulic diameter";
  SI.Area crossArea=Modelica.Constants.pi*D_hyd^2/4 "Cross-sectional flow area";
  SI.MassFlowRate m_flow=v*rho_lsat*crossArea "Mass flow rate";
  SI.CoefficientOfHeatTransfer alpha;
  Real status "Success/Failure (0/1) status";
  TRANSFORM.Media.BaseProperties2Phase mediaProps(redeclare package Medium =
        Medium, state=state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={alpha})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  (alpha,status) =
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.PostCHF.alpha_Groeneveld(
    D_hyd,
    crossArea,
    m_flow,
    x_abs,
    mu_vsat,
    rho_lsat,
    rho_vsat,
    lambda_vsat,
    Pr_vw);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end alpha_Groeneveld_wMedia;
