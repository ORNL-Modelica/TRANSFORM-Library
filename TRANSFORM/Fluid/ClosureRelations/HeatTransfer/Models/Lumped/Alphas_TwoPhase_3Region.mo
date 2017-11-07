within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Alphas_TwoPhase_3Region "Specify alphas | Two Phase | 3 Regions"

  extends PartialTwoPhase;

  input SI.CoefficientOfHeatTransfer alpha_SinglePhaseLiquid=mediaProps.lambda
       ./ dimension .*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Turbulent coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer alpha_TwoPhaseSaturated=mediaProps.lambda
       ./ dimension .*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Coefficient of heat transfer - Saturated Two Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer alpha_SinglePhaseVapor=mediaProps.lambda
       ./ dimension .*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Turbulent coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.Length L_char=dimension
    "Characteristic dimension for calculation of Nu"
    annotation (Dialog(group="Input Variables"));
  input SI.ThermalConductivity lambda=mediaProps.lambda
    "Thermal conductivity for calculation of Nu"
    annotation (Dialog(group="Input Variables"));

  parameter Units.nonDim x_CHF=0.9
    "Steam quality corresponding to Critical Heat Flux"
    annotation (Dialog(group="Heat Transfer Model:"));

protected
  SI.CoefficientOfHeatTransfer
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated;
  SI.CoefficientOfHeatTransfer
    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor;

equation

    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated =TRANSFORM.Math.spliceTanh(
    alpha_TwoPhaseSaturated,
    alpha_SinglePhaseLiquid,
    mediaProps.x_th,
    deltax=0.02);

    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor =TRANSFORM.Math.spliceTanh(
    alpha_SinglePhaseVapor,
    alpha_TwoPhaseSaturated,
    mediaProps.x_th - x_CHF,
    deltax=0.02);

    alpha =TRANSFORM.Math.spliceTanh(
    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor,
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated,
    mediaProps.x_th - 0.5,
    deltax=0.02);

  Nu = alpha .* L_char ./ lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas_TwoPhase_3Region;
