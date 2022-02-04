within TRANSFORM.Media.Solids;
package ZrHx "Zirconium hydride with customizable stoiciometry (set X)"
  //ZrHx is complicated. Use with caution
  //cp reference: https://doi.org/10.1016/j.jallcom.2003.07.006
  //https://doi.org/10.1080/00223131.2014.935509
  //alpha reference: https://doi.org/10.1016/S0925-8388(01)01434-7
//lambda from variety of sources including: https://doi.org/10.1016/S0022-3115(01)00457-3
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="ZrHx",
    T_min=Modelica.Units.Conversions.from_degC(-273),
    T_max=1200,
    MM_const=(91.224+1.008*X)/1000);
    constant Real X = 1.6;
    constant Real cps = {25.02, 4.746, 3.103e-3, 2.008e-2, 1.943e5, 6.358e5};
    constant Real deltas = {67.9, 1.62e3, 1.18e2, 1.16e-2};
    constant Real alphas = {-0.1997, 0.5292, 0.5194};

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  protected
     SpecificEnthalpy h0;
  algorithm
    h0 :=((cps[1] + cps[2]*X)*T_reference + (cps[3] + cps[4]*X)*T_reference*
      T_reference/2 + (cps[5] + cps[6]*X)/T_reference)/MM_const;                                                                //integration constant that is a function of X, calculated at T_reference
    h := h_reference + (cps[1]+cps[2]*X+(cps[3]+cps[4]*X)*state.T-(cps[5]+cps[6]*X)/(state.T*state.T))/MM_const-h0;
  end specificEnthalpy;

  redeclare function extends density
    "Density at 298K"
  protected
     Real d0;
  algorithm
    if X >= 1.6 then
      d0 :=1/(0.1706 + 0.0042*X)*1000;
    else
      d0 :=1/(0.1541 + 0.0145*X)*1000;
    end if;
    d := d0/(1+linearExpansionCoefficient(state,T_density))^3;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := thermalDiffusivity(state)*specificHeatCapacityCp(state)*density(state);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := (cps[1] + cps[2]*X +(cps[3] + cps[4]*X)*state.T - (cps[5] + cps[6]*X)/(state.T*state.T))/MM_const;
  end specificHeatCapacityCp;

  redeclare function extends linearExpansionCoefficient
    "Linear expansion coefficient"
    input Temperature T;
  algorithm
    alpha := (alphas[1]+alphas[2]*T/1000+alphas[3]*(T/1000)^2)/100;
  end linearExpansionCoefficient;

  function thermalDiffusivity
    "Thermal diffusivity"
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.ThermalDiffusivity delta "Thermal diffusivity";
  algorithm
    delta := (deltas[1]/(state.T+deltas[2]*(2-X)-deltas[3])-deltas[4])/1e4;
  end thermalDiffusivity;
end ZrHx;
