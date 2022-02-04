within TRANSFORM.Media.Solids;
package UN "UN: Uranium Mononitride"
  //Uses data from the series of papers by Hayes, Thomas and Peddicord
  //10.1016/0022-3115(90)90374-V
  //10.1016/0022-3115(90)90374-W
  //10.1016/0022-3115(90)90374-X
  //10.1016/0022-3115(90)90374-Y
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="UN",
    T_min=Modelica.Units.Conversions.from_degC(-273),
    T_max=3170,
    MM_const=0.252,
    use_constantDensity=true,
    T_density=1000);
    constant Real theta(unit="K") = 365.7;
    constant Real porosity = 0;
    constant Real h0 = 8183.64;

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + (51.14*theta)/(exp(theta/state.T)-1)+4.746e-3*state.T^2+1.4609e7*exp(-18081/state.T)-8176.44;
    annotation(smoothOrder=2);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
protected
    Temperature T = if use_constantDensity then T_density else state.T;
  algorithm
    //d := 14090;//density at 1000 K from below equation
    d:= (14.42-2.779e-4*T-4.897e-8*T^2)*1000;
    annotation(smoothOrder=2);
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := min(1.864*exp(-2.14*porosity)*state.T^0.361,29.5);
    annotation(smoothOrder=2);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := (51.14*(theta/state.T)^2*exp(theta/state.T)/(exp(theta/state.T)-1)^2+9.491e-3*state.T+2.6415e11/state.T^2*exp(-18081/state.T))/MM_const;
    annotation(smoothOrder=2);
  end specificHeatCapacityCp;
end UN;
