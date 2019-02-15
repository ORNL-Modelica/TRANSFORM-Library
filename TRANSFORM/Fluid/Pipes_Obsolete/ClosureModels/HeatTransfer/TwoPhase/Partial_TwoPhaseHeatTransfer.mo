within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.TwoPhase;
partial model Partial_TwoPhaseHeatTransfer
  "Partial two phase heat transfer model"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialPipeFlowHeatTransfer(
      replaceable package Medium =
        Modelica.Media.Water.StandardWater
      constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium);
  Units.NonDim x_th[nHT] "Thermodynmic quality";
  Units.NonDim x_abs[nHT] "Steam quality (0<x<1)";
protected
  SI.Pressure p[nHT] "Fluid pressure";
  SI.SpecificEnthalpy h[nHT] "Fluid specific enthalpy";
  Medium.SaturationProperties sat[nHT] "Properties of saturated fluid";
  Medium.ThermodynamicState bubble[nHT] "Bubble point state";
  Medium.ThermodynamicState dew[nHT] "Dew point state";
  Medium.SpecificEnthalpy h_fsat[nHT] "Saturated liquid temperature";
  Medium.SpecificEnthalpy h_gsat[nHT] "Saturated vapour temperature";
  SI.Density rho_fsat[nHT] "Saturated liquid density";
  Medium.DynamicViscosity mu_fsat[nHT] "Dynamic viscosity at bubble point";
  Medium.ThermalConductivity lambda_fsat[nHT] "Thermal conductivity at bubble point";
  Medium.SpecificHeatCapacity cp_fsat[nHT]
    "Specific heat capacity at bubble point";
  Medium.SurfaceTension sigma[nHT] "Surface tension";
  SI.Density rho_gsat[nHT] "Saturated vapour density";
  Medium.DynamicViscosity mu_gsat[nHT] "Dynamic viscosity at dew point";
  Medium.ThermalConductivity lambda_gsat[nHT] "Thermal conductivity at dew point";
  Medium.SpecificHeatCapacity cp_gsat[nHT] "Specific heat capacity at dew point";
equation
   for i in 1:nHT loop
     p[i] = states[i].p;
     h[i] = states[i].h;
     sat[i] = Medium.setSat_p(p[i]);
     bubble[i] = Medium.setBubbleState(sat[i], 1);
     dew[i] = Medium.setDewState(sat[i], 1);
     h_fsat[i] = bubble[i].h;
     h_gsat[i] = dew[i].h;
     rho_fsat[i] = bubble[i].d;
     mu_fsat[i] = Medium.dynamicViscosity(bubble[i]);
     lambda_fsat[i] = Medium.thermalConductivity(bubble[i]);
     cp_fsat[i] = Medium.heatCapacity_cp(bubble[i]);
     sigma[i] = Medium.surfaceTension(sat[i]);
     rho_gsat[i] = dew[i].d;
     mu_gsat[i] = Medium.dynamicViscosity(dew[i]);
     lambda_gsat[i] = Medium.thermalConductivity(dew[i]);
     cp_gsat[i] = Medium.heatCapacity_cp(dew[i]);
     x_th[i] = (h[i]- h_fsat[i])/(h_gsat[i]-h_fsat[i]);
     x_abs[i] = noEvent(if h[i] <= h_fsat[i] then 0 else if h[i] >= h_gsat[i] then 1 else (h[i]
          - h_fsat[i])/(h_gsat[i] - h_fsat[i]));
   end for;
end Partial_TwoPhaseHeatTransfer;
