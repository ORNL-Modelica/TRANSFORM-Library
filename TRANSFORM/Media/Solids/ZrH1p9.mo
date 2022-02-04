within TRANSFORM.Media.Solids;
package ZrH1p9 "ZrH1.9"
  //ZrHx is complicated. Use with caution
  //This is a simpler version of the ZrHx material
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="ZrH1p9",
    T_min=Modelica.Units.Conversions.from_degC(-273),
    T_max=1200,
    MM_const=(91.224+1.008*X)/1000);
    final constant Real X = 1.9;
    final constant Real alphas = {-0.1997, 0.5292, 0.5194};
  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := 330 *(state.T-T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density at 298K"
  protected
     Real d0;
  algorithm
    d0 :=1/(0.1706 + 0.0042*X)*1000;
    d := d0/(1+linearExpansionCoefficient(state,T_density))^3;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 18;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 330;
  end specificHeatCapacityCp;

  redeclare function extends linearExpansionCoefficient
    "Linear expansion coefficient"
    input Temperature T;
  algorithm
    alpha := (alphas[1]+alphas[2]*T/1000+alphas[3]*(T/1000)^2)/100;
  end linearExpansionCoefficient;
end ZrH1p9;
