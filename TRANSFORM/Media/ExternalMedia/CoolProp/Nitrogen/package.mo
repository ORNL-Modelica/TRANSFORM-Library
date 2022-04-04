within TRANSFORM.Media.ExternalMedia.CoolProp;
package Nitrogen "Nitrogen | Two Phase | Cool Prop"
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "Nitrogen",
    substanceNames = {"N2"},
    ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
    SpecificEnthalpy(start=2e5));
end Nitrogen;
