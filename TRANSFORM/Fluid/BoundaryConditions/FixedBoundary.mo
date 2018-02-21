within TRANSFORM.Fluid.BoundaryConditions;
model FixedBoundary "Boundary source component"
  import Modelica.Media.Interfaces.Choices.IndependentVariables;
  extends BaseClasses.PartialSource;
  parameter Boolean use_p=true "select p or d"
    annotation (Evaluate = true,
                Dialog(group = "Boundary pressure or Boundary density"));
  parameter Medium.AbsolutePressure p=Medium.p_default "Boundary pressure"
    annotation (Dialog(group = "Boundary pressure or Boundary density",
                       enable = use_p));
parameter Medium.Density d=
 (if use_T then Medium.density_pTX(
                  Medium.p_default,Medium.T_default,Medium.X_default)
  else Medium.density_phX(
                  Medium.p_default,Medium.h_default,Medium.X_default))
    "Boundary density"
    annotation (Dialog(group = "Boundary pressure or Boundary density",
                       enable=not use_p));
  parameter Boolean use_T=true "select T or h"
    annotation (Evaluate = true,
                Dialog(group = "Boundary temperature or Boundary specific enthalpy"));
  parameter Medium.Temperature T=Medium.T_default "Boundary temperature"
    annotation (Dialog(group = "Boundary temperature or Boundary specific enthalpy",
                       enable = use_T));
  parameter Medium.SpecificEnthalpy h=Medium.h_default
    "Boundary specific enthalpy"
    annotation (Dialog(group="Boundary temperature or Boundary specific enthalpy",
                enable = not use_T));
  parameter Medium.MassFraction X[Medium.nX](
       quantity=Medium.substanceNames)=Medium.X_default
    "Boundary mass fractions m_i/m"
    annotation (Dialog(group = "Only for multi-substance flow", enable=Medium.nXi > 0));

  parameter Medium.ExtraProperty C[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Boundary trace substances"
    annotation (Dialog(group = "Only for trace-substance flow", enable=Medium.nC > 0));
protected
  Medium.ThermodynamicState state;
equation
  Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
                                        Medium.singleState, use_p, X,
                                        "FixedBoundary");
  if use_p or Medium.singleState then
     // p given
     if use_T then
        // p,T,X given
        state = Medium.setState_pTX(p, T, X);
     else
        // p,h,X given
        state = Medium.setState_phX(p, h, X);
     end if;

     if Medium.ThermoStates == IndependentVariables.dTX then
        medium.d = Medium.density(state);
     else
        medium.p = Medium.pressure(state);
     end if;

     if Medium.ThermoStates == IndependentVariables.ph or
        Medium.ThermoStates == IndependentVariables.phX then
        medium.h = Medium.specificEnthalpy(state);
     else
        medium.T = Medium.temperature(state);
     end if;

  else
     // d given
     if use_T then
        // d,T,X given
        state = Medium.setState_dTX(d, T, X);

        if Medium.ThermoStates == IndependentVariables.dTX then
           medium.d = Medium.density(state);
        else
           medium.p = Medium.pressure(state);
        end if;

        if Medium.ThermoStates == IndependentVariables.ph or
           Medium.ThermoStates == IndependentVariables.phX then
           medium.h = Medium.specificEnthalpy(state);
        else
           medium.T = Medium.temperature(state);
        end if;

     else
        // d,h,X given
        medium.d = d;
        medium.h = h;
        state = Medium.setState_dTX(d,T,X);
     end if;
  end if;

  medium.Xi = X[1:Medium.nXi];

  ports.C_outflow = fill(C, nPorts);
  annotation (defaultComponentName="boundary",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255})}),
    Documentation(info="<html>
<p>
Model <b>FixedBoundary</b> defines constant values for boundary conditions:
</p>
<ul>
<li> Boundary pressure or boundary density.</li>
<li> Boundary temperature or boundary specific enthalpy.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>
Note, that boundary temperature, density, specific enthalpy,
mass fractions and trace substances have only an effect if the mass flow
is from the Boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>"));
end FixedBoundary;
