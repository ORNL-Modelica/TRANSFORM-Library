within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
model Alphas_TwoPhase_5Region "Specify alphas | Two Phase | 5 Regions"

  extends PartialTwoPhase;

  input SI.CoefficientOfHeatTransfer alpha_SinglePhaseLiquid_lam=mediaProps.lambda
       ./ dimension .*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Laminar coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Inputs"));

  input SI.CoefficientOfHeatTransfer alpha_SinglePhaseLiquid_turb=mediaProps.lambda
       ./ dimension .*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Turbulent coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Inputs"));

  input SI.CoefficientOfHeatTransfer alpha_TwoPhaseSaturated=mediaProps.lambda
       ./ dimension .*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Coefficient of heat transfer - Saturated Two Phase"
    annotation (Dialog(group="Inputs"));

  input SI.CoefficientOfHeatTransfer alpha_SinglePhaseVapor_lam=mediaProps.lambda
       ./ dimension .*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Laminar coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Inputs"));

  input SI.CoefficientOfHeatTransfer alpha_SinglePhaseVapor_turb=mediaProps.lambda
       ./ dimension .*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Re, Pr) "Turbulent coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Inputs"));

  input SI.Length L_char=dimension
    "Characteristic dimension for calculation of Nu"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity lambda=mediaProps.lambda
    "Thermal conductivity for calculation of Nu"
    annotation (Dialog(group="Inputs"));

  input Real HT_width[3]={0.02,0.02,0.02}
   "Smooth transition width"
   annotation (Dialog(tab="Advanced",group="Inputs"));

  input Real HT_smooth[3]={0,0.5,0.9}
   "Smooth value for transition between regions with phase transition"
   annotation (Dialog(tab="Advanced",group="Inputs"));

  input Real Var_smooth=mediaProps.alphaV
    "Variable for smoothing between regions with phase transition"
    annotation (Dialog(tab="Advanced",group="Inputs"));

protected
  SI.CoefficientOfHeatTransfer alpha_SinglePhase_Liquid;
  SI.CoefficientOfHeatTransfer alpha_SinglePhase_Vapor;
  SI.CoefficientOfHeatTransfer
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated;
  SI.CoefficientOfHeatTransfer
    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor;

equation

    alpha_SinglePhase_Liquid =TRANSFORM.Math.spliceTanh(
        alpha_SinglePhaseLiquid_turb,
        alpha_SinglePhaseLiquid_lam,
        Re - Re_center,
        Re_width);

    alpha_SinglePhase_Vapor =TRANSFORM.Math.spliceTanh(
        alpha_SinglePhaseVapor_turb,
        alpha_SinglePhaseVapor_lam,
        Re - Re_center,
        Re_width);

    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated =TRANSFORM.Math.spliceTanh(
    alpha_TwoPhaseSaturated,
    alpha_SinglePhase_Liquid,
    Var_smooth - HT_smooth[1],
    deltax=HT_width[1]);

    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor =TRANSFORM.Math.spliceTanh(
    alpha_SinglePhase_Vapor,
    alpha_TwoPhaseSaturated,
    Var_smooth - HT_smooth[3],
    deltax=HT_width[3]);

    alpha =TRANSFORM.Math.spliceTanh(
    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor,
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated,
    Var_smooth - HT_smooth[2],
    deltax=HT_width[2]);

  Nu = alpha .* L_char ./ lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas_TwoPhase_5Region;
