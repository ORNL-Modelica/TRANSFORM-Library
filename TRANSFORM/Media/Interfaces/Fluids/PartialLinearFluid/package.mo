within TRANSFORM.Media.Interfaces.Fluids;
partial package PartialLinearFluid "Generic pure liquid model with constant cp, compressibility and thermal expansion coefficients"
  //extends Modelica.Media.Interfaces.PartialPureSubstance
  extends TRANSFORM.Media.Interfaces.Fluids.PartialPureSubstance(ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pTX,
      singleState=false);
  constant SpecificHeatCapacity cp_const
    "Specific heat capacity at constant pressure";
  constant IsobaricExpansionCoefficient beta_const
    "Thermal expansion coefficient at constant pressure";
  constant SI.IsothermalCompressibility kappa_const
    "Isothermal compressibility";
  constant MolarMass MM_const "Molar mass";
  constant Density reference_d "Density in reference conditions";
  constant SpecificEnthalpy reference_h
    "Specific enthalpy in reference conditions";
  constant SpecificEntropy reference_s
    "Specific entropy in reference conditions";
  constant Boolean constantJacobian
    "If true, entries in thermodynamic Jacobian are constant, taken at reference conditions";

  redeclare record ThermodynamicState
    "A selection of variables that uniquely defines the thermodynamic state"
    extends Modelica.Icons.Record;
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
  end ThermodynamicState;

  redeclare model extends BaseProperties(T(stateSelect=if
          preferredMediumStates then StateSelect.prefer else StateSelect.default),
      p(stateSelect=if preferredMediumStates then StateSelect.prefer else
          StateSelect.default)) "Base properties of medium"
  equation
    d = (1 + (p - reference_p)*kappa_const - (T - reference_T)*beta_const)*
      reference_d;
    h = reference_h + (T - reference_T)*cp_const + (p - reference_p)*(1 -
      beta_const*reference_T)/reference_d;
    u = h - p/d;
    p = state.p;
    T = state.T;
    MM = MM_const;
    R = 8.3144/MM;
  end BaseProperties;

  redeclare function extends setState_pTX
    "Set the thermodynamic state record from p and T (X not needed)"
  algorithm
    state := ThermodynamicState(p=p, T=T);
  end setState_pTX;

  redeclare function extends setState_phX
    "Set the thermodynamic state record from p and h (X not needed)"
  algorithm
    state := ThermodynamicState(p=p, T=(h - reference_h - (p - reference_p)*(
      (1 - beta_const*reference_T)/reference_d))/cp_const + reference_T);
  end setState_phX;

  redeclare function extends setState_psX
    "Set the thermodynamic state record from p and s (X not needed)"
  algorithm
    state := ThermodynamicState(p=p, T=reference_T*cp_const/(cp_const - s +
      reference_s + (p - reference_p)*(-beta_const/reference_d)));
  end setState_psX;

  redeclare function extends setState_dTX
    "Set the thermodynamic state record from d and T (X not needed)"
  algorithm
    state := ThermodynamicState(p=((d - reference_d) + (T - reference_T)
      *beta_const*reference_d)/(reference_d*kappa_const) + reference_p, T=T);
  end setState_dTX;

  redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(p=Modelica.Media.Common.smoothStep(
        x,
        state_a.p,
        state_b.p,
        x_small), T=Modelica.Media.Common.smoothStep(
        x,
        state_a.T,
        state_b.T,
        x_small));
  end setSmoothState;

  redeclare function extends pressure
    "Return the pressure from the thermodynamic state"
  algorithm
    p := state.p;
  end pressure;

  redeclare function extends temperature
    "Return the temperature from the thermodynamic state"
  algorithm
    T := state.T;
  end temperature;

  redeclare function extends density
    "Return the density from the thermodynamic state"
  algorithm
    d := (1 + (state.p - reference_p)*kappa_const - (state.T - reference_T)*
      beta_const)*reference_d;
  end density;

  redeclare function extends specificEnthalpy
    "Return the specific enthalpy from the thermodynamic state"
  algorithm
    h := reference_h + (state.T - reference_T)*cp_const + (state.p -
      reference_p)*(1 - beta_const*reference_T)/reference_d;
  end specificEnthalpy;

  redeclare function extends specificEntropy
    "Return the specific entropy from the thermodynamic state"
  algorithm
    s := reference_s + (state.T - reference_T)*cp_const/state.T + (state.p -
      reference_p)*(-beta_const/reference_d);
  end specificEntropy;

  redeclare function extends specificInternalEnergy
    "Return the specific internal energy from the thermodynamic state"
  algorithm
    u := specificEnthalpy(state) - state.p/reference_d;
  end specificInternalEnergy;

  redeclare function extends specificGibbsEnergy
    "Return specific Gibbs energy from the thermodynamic state"
    extends Modelica.Icons.Function;
  algorithm
    g := specificEnthalpy(state) - state.T*specificEntropy(state);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy from the thermodynamic state"
    extends Modelica.Icons.Function;
  algorithm
    f := specificInternalEnergy(state) - state.T*specificEntropy(state);
  end specificHelmholtzEnergy;

  redeclare function extends velocityOfSound
    "Return velocity of sound from the thermodynamic state"
    extends Modelica.Icons.Function;
  algorithm
    a := sqrt(max(0, 1/(kappa_const*density(state) - beta_const*beta_const*
      state.T/cp_const)));
  end velocityOfSound;

  redeclare function extends isentropicExponent
    "Return isentropic exponent from the thermodynamic state"
    extends Modelica.Icons.Function;
  algorithm
    gamma := 1/(state.p*kappa_const)*cp_const/specificHeatCapacityCv(state);
  end isentropicExponent;

  redeclare function extends isentropicEnthalpy "Return isentropic enthalpy"
    /* Previous wrong equation:

protected
  SpecificEntropy s_upstream = specificEntropy(refState)
    "Specific entropy at component inlet";
  ThermodynamicState downstreamState "State at downstream location";
algorithm
  downstreamState.p := p_downstream;
  downstreamState.T := reference_T*cp_const/
    (s_upstream -reference_s -(p_downstream-reference_p)*(-beta_const/reference_d) - cp_const);
  h_is := specificEnthalpy(downstreamState);
*/
  algorithm
    /* s := reference_s + (refState.T-reference_T)*cp_const/refState.T +
                        (refState.p-reference_p)*(-beta_const/reference_d)
        = reference_s + (state.T-reference_T)*cp_const/state.T +
                        (p_downstream-reference_p)*(-beta_const/reference_d);

      (state.T-reference_T)*cp_const/state.T
     = (refState.T-reference_T)*cp_const/refState.T + (refState.p-reference_p)*(-beta_const/reference_d)
       - (p_downstream-reference_p)*(-beta_const/reference_d)
     = (refState.T-reference_T)*cp_const/refState.T + (refState.p-p_downstream)*(-beta_const/reference_d)

     (x - reference_T)/x = k
     x - reference_T = k*x
     (1-k)*x = reference_T
     x = reference_T/(1-k);

     state.T = reference_T/(1 - ((refState.T-reference_T)*cp_const/refState.T + (refState.p-p_downstream)*(-beta_const/reference_d))/cp_const)
  */
    h_is := specificEnthalpy(setState_pTX(
            p_downstream,
            reference_T/(1 - ((refState.T - reference_T)/refState.T + (
        refState.p - p_downstream)*(-beta_const/(reference_d*cp_const)))),
            reference_X));
    annotation (Documentation(info="<html>
<p>
A minor approximation is used: the reference density is used instead of the real
one, which would require a numeric solution.
</p>
</html>"));
  end isentropicEnthalpy;

  redeclare function extends specificHeatCapacityCp
    "Return specific heat capacity at constant volume"
  algorithm
    cp := cp_const;
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
    "Return specific heat capacity at constant volume from the thermodynamic state"
  algorithm
    cv := if constantJacobian then cp_const - reference_T*beta_const*
      beta_const/(kappa_const*reference_d) else state.T*beta_const*beta_const
      /(kappa_const*reference_d);
  end specificHeatCapacityCv;

  redeclare function extends isothermalCompressibility
    "Return the isothermal compressibility kappa"
  algorithm
    kappa := kappa_const;
  end isothermalCompressibility;

  redeclare function extends isobaricExpansionCoefficient
    "Return the isobaric expansion coefficient"
  algorithm
    beta := beta_const;
  end isobaricExpansionCoefficient;

  redeclare function extends density_derp_h
    "Return density derivative w.r.t. pressure at const specific enthalpy"
  algorithm
    ddph := if constantJacobian then kappa_const*reference_d + (beta_const*(1
       - reference_T*beta_const))/cp_const else kappa_const*density(state) +
      (beta_const*(1 - temperature(state)*beta_const))/cp_const;
  end density_derp_h;

  redeclare function extends density_derh_p
    "Return density derivative w.r.t. specific enthalpy at constant pressure"
  algorithm
    ddhp := if constantJacobian then -beta_const*reference_d/cp_const else -
      beta_const*density(state)/cp_const;
  end density_derh_p;

  redeclare function extends density_derp_T
    "Return density derivative w.r.t. pressure at const temperature"
  algorithm
    ddpT := if constantJacobian then kappa_const*reference_d else kappa_const
      *density(state);
  end density_derp_T;

  redeclare function extends density_derT_p
    "Return density derivative w.r.t. temperature at constant pressure"
  algorithm
    ddTp := if constantJacobian then -beta_const*reference_d else -beta_const
      *density(state);
  end density_derT_p;

  redeclare function extends density_derX
    "Returns the partial derivative of density with respect to mass fractions at constant pressure and temperature"
  algorithm
    dddX := fill(0, nX);
  end density_derX;

  redeclare function extends molarMass "Return molar mass"
  algorithm
    MM := MM_const;
  end molarMass;

  annotation (Documentation(info="<html>
<h4>Linear Compressibility Fluid Model</h4>
<p>This linear compressibility fluid model is based on the assumptions that:
</p>
<ul>
<li>The specific heat capacity at constant pressure (cp) is constant</li>
<li>The isobaric expansion coefficient (beta) is constant</li>
<li>The isothermal compressibility (kappa) is constant</li>
<li>Pressure and temperature are used as states</li>
<li>The influence of density on specific enthalpy (h), entropy (s), inner energy (u) and heat capacity (cv) at constant volume is neglected.
</ul>
<p>
That means that the density is a linear function in temperature and in pressure.
In order to define the complete model, a number of constant reference values are needed which
are computed at the reference values of the states pressure p and temperature T. The model can
be interpreted as a linearization of a full non-linear fluid model (but it is not linear in all
thermodynamic coordinates). Reference values are needed for
</p>
<ol>
<li>the density (reference_d),</li>
<li>the specific enthalpy (reference_h),</li>
<li>the specific entropy (reference_s).</li>
</ol>
<p>
Apart from that, a user needs to define the molar mass, MM_const.
Note that it is possible to define a fluid by computing the reference
values from a full non-linear fluid model by computing the package constants
using the standard functions defined in a fluid package (see example in liquids package).
</p>
<p>
In order to avoid numerical inversion of the temperature in the T_ph and T_ps functions, the density
is always taken to be the reference density in the computation of h, s, u and cv. For liquids (and this
model is intended only for liquids) the relative error of doing so is 1e-3 to 1e-4 at most. The model would
be more \"correct\" based on the other assumptions, if occurrences of reference_d in the computations of h,s,u
and cv would be replaced by a call to density(state). That would require a numerical solution for T_ps, while T_ph can be solved symbolically from a quadratic function. Errors from this approximation are small because liquid density varies little.</p>
<h4>Efficiency considerations</h4>
<p>One of the main reasons to use a simple, linear fluid model is to achieve high performance
in simulations. There are a number of possible compromises and possibilities to improve performance.
Some of them can be influenced by a flag. The following rules where used in this model:</p>
<ul>
<li>All forward evaluations (using the ThermodynamicState record as input) are exactly following
the assumptions above.</li>
<li>If the flag <b>constantJacobian</b> is set to true in the package, all functions that
typically appear in thermodynamic Jacobians (specificHeatCapacityCv, density_derp_h, density_derh_p,
density_derp_T, density_derT_p) are evaluated at reference conditions (that means using the reference
density) instead of the density of the current pressure and temperature. This makes it possible to evaluate
the thermodynamic Jacobian at compile time.</li>
<li>For inverse functions using other inputs than the states (e.g pressure p and specific enthalpy h),
the inversion is using the reference state whenever that is necessary to achieve a symbolic inversion.</li>
<li>If <b>constantJacobian</b> is set to false, the above list of functions is computed exactly according
to the above list of assumptions</li>
</ul>
<dl>
<dt><b>Authors:</b></dt>
<dd>Francesco Casella<br>
    Dipartimento di Elettronica e Informazione<br>
    Politecnico di Milano<br>
    Via Ponzio 34/5<br>
    I-20133 Milano, Italy<br>
    email: <A HREF=\"mailto:casella@elet.polimi.it\">casella@elet.polimi.it</A><br>
    and <br>
    Hubertus Tummescheit<br>
    Modelon AB<br>
    Ideon Science Park<br>
    SE-22730 Lund, Sweden<br>
    email: <A HREF=\"mailto:Hubertus.Tummescheit@Modelon.se\">Hubertus.Tummescheit@Modelon.se</A>
</dd>
</dl>
</html>"));
end PartialLinearFluid;
