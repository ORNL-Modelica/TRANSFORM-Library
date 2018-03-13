within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Examples.Functions.TwoPhase.PostCHF;
model alpha_Groeneveld
  import TRANSFORM;

  extends TRANSFORM.Icons.Example;

  parameter SI.Length D_hyd=0.012 "Hydraulic diameter";
  parameter SI.DynamicViscosity mu_vsat=2.28e-5/rho_lsat
    "Vapor phase saturated dynamic viscosity";
  parameter SI.Density rho_lsat=603.1 "Saturated liquid density";
  parameter SI.Density rho_vsat=96.7 "Saturated vapor density";
  parameter SIadd.NonDim x_abs=0.4 "Absolute quality";
  parameter SI.ThermalConductivity lambda_v=0.1164
    "Vapor phase thermal conductivity";
  parameter SI.PrandtlNumber Pr_vw=2.48
    "Prandtl number for the vapor at the wall temperature";
  parameter SI.Area crossArea=Modelica.Constants.pi*D_hyd^2/4
    "Cross-sectional flow area";
  parameter SI.MassFlowRate m_flow=3*crossArea "Mass flow rate";

  SI.CoefficientOfHeatTransfer alpha;
  Real status "Success/Failure (0/1) status";
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
    lambda_v,
    Pr_vw);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end alpha_Groeneveld;
