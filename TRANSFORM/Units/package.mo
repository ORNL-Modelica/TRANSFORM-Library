within TRANSFORM;
package Units "Additional models, functions, types, etc. for units"
  extends TRANSFORM.Icons.UnitsPackage;


  type IsobaricExpansionCoefficient = Real (
      min=0,
      max=1.0e8,
      unit="1/K")
    "Type for isobaric expansion coefficient with medium specific attributes";
end Units;
