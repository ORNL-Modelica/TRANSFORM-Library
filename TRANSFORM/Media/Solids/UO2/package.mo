within TRANSFORM.Media.Solids;
package UO2 "UO2: Thermodynamic properties for unirradiated uranium dioxide"

  /*
UO2 Thermal conductivity, density, and heat capacity

ORNL. Thermophysical Properties of MOX and UO2 Fuels Including the
Effects of Irradiaiton. ORNL/TM-2000/351. 1996.

lambda => pg 25 eq. 6.2
d => pg 9-10 eq. N/A
cp => pg 18 eq 4.2
h => pg 18 eq 4.1
*/
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="UO2",
    T_min=273.15,
    T_max=3120);

  constant Real c1(unit="J/(kg.K)") = 302.27;
  constant Real c2(unit="J/(kg.K2)") = 8.463e-3;
  constant Real c3(unit="J/kg") = 8.741e7;
  constant Real theta(unit="K") = 548.68;
  constant Real Ea(unit="K") = 18531.7;

  constant SI.Density d_273=10970 "Density of 100% UO2";
  constant Units.NonDim porosity = 0.05 "Fuel porosity (d_TD - d)/d_td";

  redeclare function extends specificEnthalpy "Specific enthalpy"
  algorithm
      h := h_reference + c1*theta*(1/(exp(theta/state.T)-1)-1/(exp(theta/298)-1))
            +c2*(state.T^2-298^2)+c3*exp(-Ea/state.T);
    annotation (smoothOrder=1);
  end specificEnthalpy;

  redeclare function extends density "Density"
  algorithm
    d := TRANSFORM.Math.spliceTanh(
        (1-porosity)*d_273*(9.9672e-1 + 1.179e-5*state.T - 2.429e-9*state.T^2 + 1.219e-12
        *state.T^3)^(-3),
        (1-porosity)*d_273*(9.9734e-1 + 9.802e-6*state.T - 2.705e-10*state.T^2 + 4.391e-13
        *state.T^3)^(-3),
        state.T - 923,
        1);
        annotation(smoothOrder=1);
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"

    /*
  Units.nonDim B  burnupin at. % (1 at. % = 9.375 MWd/kgU)
  Units.nonDim omega = 1.09/(B^3.265)+0.0643*sqrt(state.T/B);
  Units.nonDim FD = omega*Modelica.Math.atan(1/omega) "Effect of dissolved fission products";
  Units.nonDim FP = 1+0.019*B/(3-0.019*B)/(1+exp(-(state.T-1200)/100)) "Effect of precipitated fission products";
  Units.nonDim FR = 1-0.2/(1+exp((state.T-900)/80)) "Radiation effect";
  */
protected
  Units.NonDim FM = (1-porosity)/(1+2*porosity) "Effect of porosity";
  algorithm
    lambda := (115.8/(7.5408 + 17.692*(state.T/1000) + 3.6142*(state.T/1000)^2) +
      7410.5*(state.T/1000)^(-5/2)*exp(-16.35/(state.T/1000)))*FM;
        annotation(smoothOrder=1);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := c1*(theta/state.T)^2*exp(theta/state.T)/(exp(theta/state.T) - 1)^2 + 2
      *c2*state.T + c3*Ea*exp(-Ea/state.T)/state.T^2;
        annotation(smoothOrder=1);
  end specificHeatCapacityCp;
end UO2;
