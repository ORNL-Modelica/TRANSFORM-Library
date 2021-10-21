within TRANSFORM.Media;
model BaseProperties2Phase
  replaceable package Medium = Modelica.Media.Water.StandardWater
   constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
                                                    "Medium in component"
   annotation(choicesAllMatching=true);
  replaceable model VoidFraction =
      TRANSFORM.Fluid.ClosureRelations.VoidFraction.Homogeneous_wSlipVelocity
    constrainedby TRANSFORM.Fluid.ClosureRelations.VoidFraction.PartialVoidFraction
    annotation (choicesAllMatching=true);
  VoidFraction voidFraction(
    x_abs=x_abs,
    rho_p=rho_lsat,
    rho_s=rho_vsat)             annotation(Placement(transformation(extent={{-8,-8},
            {8,8}})));
//   replaceable function alphaVoid =
//   TRANSFORM.Fluid.ClosureRelations.VoidFraction.Functions.alphaV_Homogeneous_wSlipRatio
//     "Void fraction model" annotation(choicesAllMatching=true);
  input Medium.ThermodynamicState state "Medium state" annotation(Dialog(group="Inputs"));
//   input Units.NonDim S = 1.0 "Slip ratio for void fraction" annotation(Dialog(group="Inputs"));
  constant SI.Pressure p_crit = Medium.fluidConstants[1].criticalPressure "Critical pressure";
  constant SI.Temperature T_crit = Medium.fluidConstants[1].criticalTemperature "Critical temperature";
  SI.SpecificEnthalpy h "Fluid specific enthalpy";
  SI.Density d "Fluid density";
  SI.Temperature T "Fluid temperature";
  SI.Pressure p "Fluid pressure";
  Units.NonDim x_th "Thermodynamic quality";
  Units.NonDim x_abs "Absolute mass quality (0<x<1)";
  Units.VoidFraction alphaV "Void fraction";
  Medium.DynamicViscosity mu "Dynamic viscosity";
  Medium.ThermalConductivity lambda "Thermal conductivity";
  Medium.SaturationProperties sat "Properties of saturated fluid";
  Medium.ThermodynamicState bubble "Bubble point state";
  Medium.ThermodynamicState dew "Dew point state";
  Medium.SpecificEnthalpy h_lsat "Saturated liquid temperature";
  Medium.SpecificEnthalpy h_vsat "Saturated vapour temperature";
  Medium.SpecificEnthalpy h_lv "Latent heat of vaporization";
  SI.Density rho_lsat "Saturated liquid density";
  Medium.DynamicViscosity mu_lsat "Dynamic viscosity at bubble point";
  Medium.ThermalConductivity lambda_lsat "Thermal conductivity at bubble point";
  Medium.SpecificHeatCapacity cp_lsat
    "Specific heat capacity at bubble point";
  Medium.SurfaceTension sigma "Surface tension";
  SI.Density rho_vsat "Saturated vapour density";
  Medium.DynamicViscosity mu_vsat "Dynamic viscosity at dew point";
  Medium.ThermalConductivity lambda_vsat "Thermal conductivity at dew point";
  Medium.SpecificHeatCapacity cp_vsat "Specific heat capacity at dew point";
equation
     h = Medium.specificEnthalpy(state);
     d = noEvent(
          if h <= h_lsat then
            Medium.density(state)
          else if h >= h_vsat then
            Medium.density(state)
          else
            alphaV*rho_vsat + (1-alphaV)*rho_lsat);
     T = Medium.temperature(state);
     p = Medium.pressure(state);
     mu=Medium.dynamicViscosity(state);
     lambda=Medium.thermalConductivity(state);
     sat = Medium.setSat_p(p);
     bubble = Medium.setBubbleState(sat, 1);
     dew = Medium.setDewState(sat, 1);
     h_lsat = bubble.h;
     h_vsat = dew.h;
     h_lv = h_vsat - h_lsat;
     rho_lsat = bubble.d;
     mu_lsat = Medium.dynamicViscosity(bubble);
     lambda_lsat = Medium.thermalConductivity(bubble);
     cp_lsat = Medium.heatCapacity_cp(bubble);
     sigma = Medium.surfaceTension(sat);
     rho_vsat = dew.d;
     mu_vsat = Medium.dynamicViscosity(dew);
     lambda_vsat = Medium.thermalConductivity(dew);
     cp_vsat = Medium.heatCapacity_cp(dew);
     x_th = (h- h_lsat)/(h_vsat-h_lsat);
//      x_abs = noEvent(if h <= h_lsat then 0 else if h >= h_vsat then 1 else (h
//           - h_lsat)/(h_vsat - h_lsat));
     x_abs = noEvent(if p/p_crit < 1.0 then max(0.0, min(1.0, (h - h_lsat)/max(h_vsat - h_lsat,
    1e-6))) else 1.0);
     alphaV = voidFraction.alphaV;
//       alphaVoid(
//       x_abs,
//       rho_lsat,
//       rho_vsat,
//       S);
  annotation (defaultComponentName="mediaProps",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-48,20},{46,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseProperties2Phase;
