within TRANSFORM.Media.Solids;
package YSZ "YSZ: Yttria stabilized zirconia"
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="YSZ",
    T_min=Modelica.Units.Conversions.from_degC(-273),
    T_max=3000,
    MM_const=0.093129);

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 600*(state.T-T_reference);
    annotation(smoothOrder=2);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 6000;
    annotation(smoothOrder=2);
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 2.5;
    annotation(smoothOrder=2);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
    //Real cp0;
  algorithm
    cp := 600;
    annotation(smoothOrder=2);
  end specificHeatCapacityCp;
end YSZ;
