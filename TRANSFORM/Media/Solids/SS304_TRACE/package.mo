within TRANSFORM.Media.Solids;
package SS304_TRACE "SS304: Stainless steel 304 from TRACE"

  // Reference 12-4 (304 stainless steel): J. C. Spanner, editor, “Nuclear Systems Materials Handbook—Vol. 1 Design Data,” Hanford Engineering Development Laboratory report TID-26666 (1976).

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="SS304",
    T_min=Modelica.SIunits.Conversions.from_degC(0),
    T_max=Modelica.SIunits.Conversions.from_degC(3000));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 426.17*(state.T - T_reference) + 0.5*0.43816*(state.T^2 - T_reference^2)-6.3759e-4/3*(state.T^3 - T_reference^3)+4.4803e-7/4*(state.T^4 - T_reference^4)-1.0729e-10/5*(state.T^5 - T_reference^5);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
protected
    Temperature T = if use_constantDensity then T_density else state.T;
  algorithm
    d := 7984 - 2.651e-1*T - 1.158e-4*T^2;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 8.116 + 1.618e-2*state.T;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 426.17 + 0.43816*state.T-6.3759e-4*state.T^2+4.4803e-7*state.T^3-1.0729e-10*state.T^4;
  end specificHeatCapacityCp;
end SS304_TRACE;
