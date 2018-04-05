within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Examples.Functions.TwoPhase.CHF;
model Biasi_quality
  import TRANSFORM;

  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater;

  parameter SI.Pressure p=15e6;
  parameter SIadd.NonDim x_abs=0.4;
  parameter SI.SpecificEnthalpy h=Medium.bubbleEnthalpy(Medium.setSat_p(p))*(1
       - x_abs) + Medium.dewEnthalpy(Medium.setSat_p(p))*x_abs;

  parameter Medium.ThermodynamicState state=Medium.setState_ph(p, h);

  parameter SIadd.MassFlux G = 1000 "Mass flux";
  parameter SI.Length D_htd=0.012 "Heated diameter";

  parameter SI.Length L_B = 200;

  SI.SpecificEnthalpy h_lv=mediaProps.h_lv
    "Latent heat of vaporization";

  SIadd.NonDim x_CHF;

  TRANSFORM.Media.BaseProperties2Phase mediaProps(redeclare package Medium =
        Medium, state=state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation

  x_CHF = TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.CHF.Biasi_quality(G, p, L_B, D_htd, h_lv)
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end Biasi_quality;
