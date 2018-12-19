within TRANSFORM.Media.Solids;
package ZrNb_E125 "ZircAlloy: Thermodynamic properties for ZrNb_E125"

  /*
Zirconium-niobium (2.5%) alloy type N-2.5 (E-125).

IAEA. Thermophysical Properties of Materials for Nuclear Engineering:
A Tutorial and Collection of Data. IAEA-THPH. ISBN 978-92-0-106508-7. 2008

lambda => pg. 158 eq. 6.22
d => pg. 158 eq. 6.20
cp => pg 158 eq. 6.21
*/

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="ZrNb_E125",
    T_min=1,
    T_max=1100);

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 221*(state.T - T_reference) + 0.172*(state.T^2 - T_reference^2)/2 - 5.87e-5*(state.T^3 - T_reference^3)/3;
  end specificEnthalpy;

  redeclare function extends density
    "Density"
protected
    Temperature T = if use_constantDensity then T_density else state.T;
  algorithm
    d := 6657 - 0.2861*T;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 14 + 0.0115*state.T;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 221 + 0.172*state.T - 5.87e-5*state.T^2;
  end specificHeatCapacityCp;
end ZrNb_E125;
