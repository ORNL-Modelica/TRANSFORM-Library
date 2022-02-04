within TRANSFORM.Media.IdealGases.Common.MixtureGas;
function h_TX_der "Return specific enthalpy derivative"
  import Modelica.Media.Interfaces.Choices;
   extends Modelica.Icons.Function;
   input SI.Temperature T "Temperature";
   input MassFraction X[nX] "Independent Mass fractions of gas mixture";
   //input Boolean exclEnthForm=excludeEnthalpyOfFormation
   // "If true, enthalpy of formation Hf is not included in specific enthalpy h";
   input Modelica.Media.Interfaces.Choices.ReferenceEnthalpy
                                   refChoice=referenceChoice
    "Choice of reference enthalpy";
   input SI.SpecificEnthalpy h_off=h_offset
    "User defined offset for reference enthalpy, if referenceChoice = UserDefined";
  input Real dT "Temperature derivative";
  input Real dX[nX] "Independent mass fraction derivative";
  output Real h_der "Specific enthalpy at temperature T";
algorithm
  h_der := if fixedX then
    dT*sum((Modelica.Media.IdealGases.Common.Functions.cp_T(
                               data[i], T)*reference_X[i]) for i in 1:nX) else
    dT*sum((Modelica.Media.IdealGases.Common.Functions.cp_T(
                               data[i], T)*X[i]) for i in 1:nX)+
    sum((TRANSFORM.Media.IdealGases.Common.Functions.h_T(
                           data[i], T)*dX[i]) for i in 1:nX);
  annotation (Inline = false, smoothOrder=1);
end h_TX_der;
