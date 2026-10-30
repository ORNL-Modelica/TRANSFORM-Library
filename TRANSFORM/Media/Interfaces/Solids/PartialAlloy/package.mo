within TRANSFORM.Media.Interfaces.Solids;
partial package PartialAlloy "Partial material properties (base package of all material packages)"
  extends Modelica.Media.Interfaces.Types;

  extends Modelica.Icons.MaterialPropertiesPackage;
  // Constants to be set in Medium
  constant String mediumName="unusablePartialMedium" "Name of the medium";
  constant String substanceNames[:]={mediumName}
    "Names of the mixture substances. Set substanceNames={mediumName} if only one substance.";
  constant Modelica.Media.Interfaces.Types.Temperature T_reference=298.15
    "Reference temperature of Medium: default 25 deg Celsius";
  constant Modelica.Media.Interfaces.Types.SpecificEnthalpy h_reference=0
    "Reference enthalpy at T_reference";
  constant Temperature T_default=293.15
    "Default value for temperature of medium (for initialization)";
  constant SpecificEnthalpy h_default=specificEnthalpy_T(T_default)
    "Default value for specific enthalpy of medium (for initialization)";
  constant Boolean use_constantDensity = false "=true to have density constant at T_density if a temperature dependent function for density exists";
  constant Temperature T_density = T_reference "Reference temperature for constant density calculations";

  replaceable record ThermodynamicState
    "Minimal variable set that is available as input argument to every medium function"
    extends Modelica.Icons.Record;
  end ThermodynamicState;

  replaceable partial model BaseProperties
    "Base properties (d, T, h, u, MM) of a medium"
    parameter Boolean preferredMediumStates=false
      "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
      annotation (Evaluate=true, Dialog(tab="Advanced"));
    InputTemperature T "Temperature";
    SpecificEnthalpy h "Specific enthalpy of medium";
    Density d "Density of medium";
    SpecificInternalEnergy u "Specific internal energy of medium";
    SI.MolarMass MM "Molar mass (of mixture or single fluid)";
    ThermodynamicState state
      "Thermodynamic state record for optional functions";
    // Local connector definition, used for equation balancing check
    connector InputTemperature = input SI.Temperature;
  end BaseProperties;

  replaceable partial function setState_T
    "Return thermodynamic state as function of T"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output ThermodynamicState state "Thermodynamic state record";
  end setState_T;
  //   replaceable partial function setState_h
  //   "Return thermodynamic state as function of p, h and composition X or Xi"
  //   extends Modelica.Icons.Function;
  //   input SpecificEnthalpy h "Specific enthalpy";
  //   output ThermodynamicState state "Thermodynamic state record";
  //   end setState_h;
  replaceable partial function setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
    extends Modelica.Icons.Function;
    input Real x "flow variable";
    input ThermodynamicState state_a "Thermodynamic state if x > 0";
    input ThermodynamicState state_b "Thermodynamic state if x < 0";
    input Real x_small(min=0)
      "Smooth transition in the region -x_small < x < x_small";
    output ThermodynamicState state
      "Smooth thermodynamic state for all x (continuous and differentiable)";
    annotation (Documentation(info="<html>
  <p>
  This function is used to approximate the equation
  </p>
  <pre>
      state = <b>if</b> x &gt; 0 <b>then</b> state_a <b>else</b> state_b;
  </pre>
  
  <p>
  by a smooth characteristic, so that the expression is continuous and differentiable:
  </p>
  
  <pre>
     state := <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> state_a <b>else</b>
                        <b>if</b> x &lt; -x_small <b>then</b> state_b <b>else</b> f(state_a, state_b));
  </pre>
  
  <p>
  This is performed by applying function <b>Media.Common.smoothStep</b>(..)
  on every element of the thermodynamic state record.
  </p>
  
  <p>
  If <b>mass fractions</b> X[:] are approximated with this function then this can be performed
  for all <b>nX</b> mass fractions, instead of applying it for nX-1 mass fractions and computing
  the last one by the mass fraction constraint sum(X)=1. The reason is that the approximating function has the
  property that sum(state.X) = 1, provided sum(state_a.X) = sum(state_b.X) = 1.
  This can be shown by evaluating the approximating function in the abs(x) &lt; x_small
  region (otherwise state.X is either state_a.X or state_b.X):
  </p>
  
  <pre>
      X[1]  = smoothStep(x, X_a[1] , X_b[1] , x_small);
      X[2]  = smoothStep(x, X_a[2] , X_b[2] , x_small);
         ...
      X[nX] = smoothStep(x, X_a[nX], X_b[nX], x_small);
  </pre>
  
  <p>
  or
  </p>
  
  <pre>
      X[1]  = c*(X_a[1]  - X_b[1])  + (X_a[1]  + X_b[1])/2
      X[2]  = c*(X_a[2]  - X_b[2])  + (X_a[2]  + X_b[2])/2;
         ...
      X[nX] = c*(X_a[nX] - X_b[nX]) + (X_a[nX] + X_b[nX])/2;
      c     = (x/x_small)*((x/x_small)^2 - 3)/4
  </pre>
  
  <p>
  Summing all mass fractions together results in
  </p>
  
  <pre>
      sum(X) = c*(sum(X_a) - sum(X_b)) + (sum(X_a) + sum(X_b))/2
             = c*(1 - 1) + (1 + 1)/2
             = 1
  </pre>
  
  </html>"));
  end setSmoothState;

  replaceable partial function temperature "Return temperature"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Temperature T "Temperature";
  end temperature;

  replaceable partial function density "Return density"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Density d "Density";
  end density;

  replaceable partial function specificEnthalpy
    "Return specific enthalpy"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificEnthalpy h "Specific enthalpy";
  end specificEnthalpy;

  replaceable partial function specificInternalEnergy
    "Return specific internal energy"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificEnergy u "Specific internal energy";
  end specificInternalEnergy;

  replaceable partial function specificHeatCapacityCp
    "Return specific heat capacity at constant pressure"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output SpecificHeatCapacity cp
      "Specific heat capacity at constant pressure";
  end specificHeatCapacityCp;

  replaceable partial function thermalConductivity
    "Return thermal conductivity"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output ThermalConductivity lambda "Thermal conductivity";
  end thermalConductivity;

  replaceable partial function molarMass
    "Return the molar mass of the medium"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output MolarMass MM "Mixture molar mass";
  end molarMass;

  replaceable partial function linearExpansionCoefficient
    "Linear expansion coefficient"
    input ThermodynamicState state "Thermodynamic state record";
    output SI.LinearExpansionCoefficient alpha
        "Linear expansion coefficient of the material";
  end linearExpansionCoefficient;

  replaceable partial function emissivity "Emissivity"
    input ThermodynamicState state "Thermodynamic state record";
    output SI.Emissivity eps "Emissivity";
  end emissivity;

  replaceable partial function electricalResistivity "Electrical resistivity"
    input ThermodynamicState state "Thermodynamic state record";
    output SI.Resistivity rho_e "Electrical resistivity";
  end electricalResistivity;

  replaceable function specificEnthalpy_T
    "Return specific enthalpy from T"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy(setState_T(T));
    //annotation (inverse(T=temperature_h(h)));
    annotation (Inline=true, smoothOrder=2);
  end specificEnthalpy_T;

  replaceable function density_T "Return density from T"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output Density d "Density";
  algorithm
    d := density(setState_T(T));
    annotation (Inline=true, smoothOrder=2);
  end density_T;

  replaceable function specificHeatCapacityCp_T
    "Return specific heat capacity at constant pressure from T"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificHeatCapacity cp
      "Specific heat capacity at constant pressure";
  algorithm
    cp := specificHeatCapacityCp(setState_T(T));
    annotation (Inline=true, smoothOrder=2);
  end specificHeatCapacityCp_T;

  replaceable function thermalConductivity_T
    "Return thermal conductivity from T"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output ThermalConductivity lambda "Thermal conductivity";
  algorithm
    lambda := thermalConductivity(setState_T(T));
    annotation (Inline=true, smoothOrder=2);
  end thermalConductivity_T;
  //   replaceable partial function density_derh_p
  //   "Return density derivative w.r.t. specific enthalpy at constant pressure"
  //   extends Modelica.Icons.Function;
  //   input ThermodynamicState state "Thermodynamic state record";
  //   output DerDensityByEnthalpy ddhp
  //     "Density derivative w.r.t. specific enthalpy";
  //   end density_derh_p;
  //
  //   replaceable partial function density_derT_p
  //   "Return density derivative w.r.t. temperature at constant pressure"
  //   extends Modelica.Icons.Function;
  //   input ThermodynamicState state "Thermodynamic state record";
  //   output DerDensityByTemperature ddTp "Density derivative w.r.t. temperature";
  //   end density_derT_p;
  //
  //   replaceable function temperature_h "Return temperature from h"
  //   extends Modelica.Icons.Function;
  //   input SpecificEnthalpy h "Specific enthalpy";
  //   output Temperature T "Temperature";
  //   algorithm
  //   T := temperature(setState_h(h));
  //   end temperature_h;
  //
  //   replaceable function density_h "Return density from h"
  //   extends Modelica.Icons.Function;
  //   input SpecificEnthalpy h "Specific enthalpy";
  //   output Density d "Density";
  //   algorithm
  //   d := density(setState_h(h));
  //   end density_h;
  annotation (Documentation(info="<html>
<p>
<b>PartialMedium</b> is a package and contains all <b>declarations</b> for
a medium. This means that constants, models, and functions
are defined that every medium is supposed to support
(some of them are optional). A medium package
inherits from <b>PartialMedium</b> and provides the
equations for the medium. The details of this package
are described in
<a href=\"modelica://Modelica.Media.UsersGuide\">Modelica.Media.UsersGuide</a>.
</p>
</html>", revisions="<html>

</html>"));
end PartialAlloy;
