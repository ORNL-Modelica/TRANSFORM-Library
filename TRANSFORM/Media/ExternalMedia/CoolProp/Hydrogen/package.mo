within TRANSFORM.Media.ExternalMedia.CoolProp;
package Hydrogen "Hydrogen | Two Phase | Cool Prop"
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "Hydrogen",
    substanceNames = {"hydrogen"},
    ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
    SpecificEnthalpy(start=2e5));
end Hydrogen;
