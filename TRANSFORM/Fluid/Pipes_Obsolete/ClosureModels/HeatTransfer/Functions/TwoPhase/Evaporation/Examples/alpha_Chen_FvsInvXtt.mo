within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.Examples;
model alpha_Chen_FvsInvXtt
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater;
  parameter Boolean spanQuality = true
    "true to span from saturated liquid to saturated vapor (create F vs 1/X_tt plot)";
  parameter Boolean spanFlux = false
    "true to span over flux range (to create S vs Re_tp plot). Must change number of simulation intervals to a large number (e.g., 1e4) to capture plot";
  parameter SI.Pressure p = 1e5 "Absolute pressure";
  parameter SI.SpecificEnthalpy h_start = 5e5 "Initial enthalpy value";
  parameter SI.SpecificEnthalpy h_end = 2e6 "Final enthalpy value";
  parameter SI.Length D = 1.0 "Hydraulic diameter";
  parameter Units.MassFlux G_start=0 "Total mass flow rate";
  parameter Units.MassFlux G_end=5000 "Total mass flow rate";
  parameter SI.Temperature Twall = 400 "Wall temperature";
  SI.SpecificEnthalpy dh "Enthalpy range";
  SI.SpecificEnthalpy h "Enthalpy";
  Units.MassFlux G "Total mass flow rate";
  Units.NonDim x_th "Thermodynmic quality";
  Units.NonDim x_abs "Steam quality (0<x<1)";
  Medium.ThermodynamicState state "Thermodynamic states";
  Medium.SaturationProperties sat "Properties of saturated fluid";
  Medium.ThermodynamicState bubble "Bubble point state";
  Medium.ThermodynamicState dew "Dew point state";
  Medium.SpecificEnthalpy h_fsat "Saturated liquid temperature";
  Medium.SpecificEnthalpy h_gsat "Saturated vapour temperature";
  SI.Density rho_fsat "Saturated liquid density";
  Medium.DynamicViscosity mu_fsat "Dynamic viscosity at bubble point";
  Medium.ThermalConductivity lambda_fsat "Thermal conductivity at bubble point";
  Medium.SpecificHeatCapacity cp_fsat "Specific heat capacity at bubble point";
  Medium.SurfaceTension sigma "Surface tension";
  SI.Density rho_gsat "Saturated vapour density";
  Medium.DynamicViscosity mu_gsat "Dynamic viscosity at dew point";
  Medium.ThermalConductivity k_gsat "Thermal conductivity at dew point";
  Medium.SpecificHeatCapacity cp_gsat "Specific heat capacity at dew point";
  SI.SpecificEnthalpy h_fg "Latent heat of vaporization";
  SI.TemperatureDifference Delta_Tsat
    "Saturation temperature difference (Twall-Tsat)";
  SI.PressureDifference Delta_psat
    "Saturation pressure difference (psat(Twall)-psat(Tsat))";
  SI.CoefficientOfHeatTransfer y "Heat transfer coefficient";
  Real X_tt_inv "Inverse of the Martenelli Parameter";
  Real F "Correction factor for two-phase impact on liquid-phase convection";
  Real S "Nucleare boiling suppresion factor";
  Real Re_tp "Two-phase Reynolds number";
protected
  SI.Time tt = 1 "1 second to suppress unit warning";
algorithm
  bubble :=Medium.setBubbleState(sat, 1);
  dew :=Medium.setDewState(sat, 1);
  h_fsat :=bubble.h;
  h_gsat :=dew.h;
  h_fg :=h_gsat - h_fsat;
  if spanQuality then
    dh :=h_fg;
    h :=h_fsat + dh*time/tt;
    G :=G_start;
  elseif spanFlux then
    dh :=0;
    h :=h_start;
    G :=(G_end - G_start)*time/tt;
  else
    dh :=(h_end - h_start);
    h :=h_start + dh*time/tt;
    G :=G_start;
  end if;
  state :=Medium.setState_ph(p, h);
  sat :=Medium.setSat_p(state.p);
  x_th :=(h - h_fsat)/(h_gsat - h_fsat);
  x_abs :=noEvent(if h <= h_fsat then 0 else if h >= h_gsat then 1 else (h -
    h_fsat)/(h_gsat - h_fsat));
  rho_fsat :=bubble.d;
  mu_fsat :=Medium.dynamicViscosity(bubble);
  lambda_fsat :=Medium.thermalConductivity(bubble);
  cp_fsat :=Medium.heatCapacity_cp(bubble);
  sigma :=Medium.surfaceTension(sat);
  rho_gsat :=dew.d;
  mu_gsat :=Medium.dynamicViscosity(dew);
  k_gsat :=Medium.thermalConductivity(dew);
  cp_gsat :=Medium.heatCapacity_cp(dew);
  Delta_Tsat :=Twall - sat.Tsat;
  Delta_psat :=Medium.saturationPressure(Twall) - state.p;
  (y,X_tt_inv,F,S,Re_tp) :=
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow(
                D=D,
                G=G,
                x=x_abs,
                rho_fsat=rho_fsat,
                mu_fsat=mu_fsat,
                lambda_fsat=lambda_fsat,
                cp_fsat=cp_fsat,
                sigma=sigma,
                rho_gsat=rho_gsat,
                mu_gsat=mu_gsat,
                h_fg=h_fg,
                Delta_Tsat=Delta_Tsat,
                Delta_psat=Delta_psat);
  annotation (experiment(__Dymola_NumberOfIntervals=1000, __Dymola_Algorithm=
          "Dassl"));
end alpha_Chen_FvsInvXtt;
