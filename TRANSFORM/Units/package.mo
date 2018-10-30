within TRANSFORM;
package Units "Additional models, functions, types, etc. for units"
  extends TRANSFORM.Icons.UnitsPackage;


  type SpecificActivity = Real (final unit="1/(s.kg)", final quantity= "SpecificActivity")
    "Specific activity [1/(s.kg)]";

  type Dose = Real (final unit="J/kg", final quantity= "Dose") "Dose [J/kg]";

  type DoseRate =Real (final unit="J/(s.kg)", final quantity= "DoseRate")
    "Dose rate [J/(kg.s)]";

  type StoppingPowerParticle =Real (final unit="J/m", final quantity= "StoppingPowerParticle")
    "Stopping power for particles [J/m]";
end Units;
