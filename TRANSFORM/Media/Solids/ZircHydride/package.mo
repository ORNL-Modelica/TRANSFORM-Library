within TRANSFORM.Media.Solids;
package ZircHydride "ZrH1.89"
  //ZrHx is complicated. Use with caution
//cp from http://linkinghub.elsevier.com/retrieve/pii/S0925838899003898
//lambda from variety of sources including: http://linkinghub.elsevier.com/retrieve/pii/S0022311501004573
//It's basically constant
extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
  mediumName="ZrH1.89",
  T_min=Modelica.Units.Conversions.from_degC(-273),
  T_max=1200,
  MM_const=0.093129);
    constant Real X = 1.89;
    constant Real A = 25.02;
    constant Real B = 4.746;
    constant Real C = 3.103e-3;
    constant Real D = 2.008e-2;
    constant Real E = 1.943e5;
    constant Real F = 6.358e5;
    constant Real G = 1.7863e5;

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
    //Real h0;
  algorithm
    //h0 := h_reference + ((A + B*X)*state.T + (C + D*X)/2*state.T^2 + (E + F*X)/state.T)/MM_const-G;
    //h := TRANSFORM.Math.spliceTanh(h0,1.793e5,state.T-300,50)/MM_const;
    h := h_reference + 330*(state.T-T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
    //Uses function for X>1.6
    //For X<1.6, use d:=1/(0.1541+0.0145*X)
  algorithm
    d := 1/(0.1706 + 0.0042*X)*1000;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := 18;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
    //Real cp0;
  algorithm
    //cp0 := (A + B*X + (C + D*X)*state.T - (E + F*X)/state.T^2)/MM_const;
    //cp := TRANSFORM.Math.spliceTanh(cp0,330,state.T-310,10);
    cp := 330;
  end specificHeatCapacityCp;
end ZircHydride;
