within TRANSFORM.Media.Solids;
package Aluminum_Nitride "Aluminum Nitrid: Ceramic Material for Heaters"
    extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
      mediumName="AlN",
      T_min=298,
      T_max=3000);
      constant Real Molecular_weight = 40.9882 "mol/kg NIST";
      constant Real h_reference = 0 "Enthalpy of formation in kJ/mol";
      constant Real A1 =  17.23264;
      constant Real B1 =  85.63811;
      constant Real C1 = -83.27290;
      constant Real D1 =  29.63427;
      constant Real E1 = -0.537933;
      constant Real F1 = -328.0587;
      constant Real G1 =  15.87020;
      constant Real H1 = -317.9844;
      constant Real A2 =  49.78374;
      constant Real B2 =  2.238047;
      constant Real C2 = -0.742003;
      constant Real D2 =  0.087952;
      constant Real E2 = -2.813004;
      constant Real F2 = -341.3173;
      constant Real G2 =  66.70509;
      constant Real H2 = -317.9844;

    redeclare function extends specificEnthalpy
      "Specific enthalpy in kJ/mol * 40.9882 kg/mol"
    algorithm
     if state.T< 900 then

        h := (A1*(state.T / 1000) + B1/2*(state.T / 1000)^2 + C1/3*(state.T / 1000)^3 + D1/4*(state.T / 1000)^4 - E1/(state.T / 1000)+
        F1 - H1) * Molecular_weight "NIST Chemistry WebBook, SRD 69 https://webbook.nist.gov/cgi/inchi?ID=C24304005&Mask=2";

     else
        h := ( A2*(state.T / 1000) + B2/2*(state.T / 1000)^2 + C2/3*(state.T / 1000)^3 + D2/4*(state.T / 1000)^4 - E2/(state.T / 1000)+
        F2 - H2) * Molecular_weight "NIST Chemistry WebBook, SRD 69 https://webbook.nist.gov/cgi/inchi?ID=C24304005&Mask=2";
     end if;
    end specificEnthalpy;

    redeclare function extends density
      "Density"
    algorithm
      d := 3260
      "Theoretical Density Ran-Rong Lee - 
    Development of High Thermal Conductivity Aluminum Nitride Ceramic";
    end density;

    redeclare function extends thermalConductivity
      "Thermal conductivity"
    algorithm
      if state.T <= 600 then
         lambda := 23001239.044*state.T^(-1.97207763);
      else
         lambda := 114410.51121*state.T^(-1.138362885)
         "G. A. Slack 1979 Aluminum Nitride Crystal 
         Growth Fit to table III P22";
      end if;
    end thermalConductivity;

    redeclare function extends specificHeatCapacityCp
      "Specific heat capacity"
    algorithm
      if state.T < 900 then
         cp := (A1 + B1*(state.T / 1000) + C1*(state.T / 1000)^2+D1*(state.T / 1000)^3 + E1/(state.T / 1000)^2) * Molecular_weight;
      else
         cp := (A2 + B2*(state.T / 1000) + C2*(state.T / 1000)^2+D2*(state.T / 1000)^3 + E2/(state.T / 1000)^2) * Molecular_weight;
      end if;
    end specificHeatCapacityCp;
end Aluminum_Nitride;
