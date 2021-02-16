within TRANSFORM.Media.ExternalMedia.CoolProp;
package CarbonDioxide "Carbon Dioxide | Two Phase | Cool Prop"
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "CarbonDioxide",
    substanceNames = {"CO2"},
    ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
    SpecificEnthalpy(start=2e5));
end CarbonDioxide;
