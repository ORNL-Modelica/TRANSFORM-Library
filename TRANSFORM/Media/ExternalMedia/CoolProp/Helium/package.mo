within TRANSFORM.Media.ExternalMedia.CoolProp;
package Helium "Helium | Two Phase | Cool Prop"
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "Helium",
    substanceNames = {"helium"},
    ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
    SpecificEnthalpy(start=2e5));
end Helium;
