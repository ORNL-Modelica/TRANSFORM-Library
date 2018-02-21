within TRANSFORM;
package Units "Additional models, functions, types, etc. for units"
  extends TRANSFORM.Icons.UnitsPackage;


  type ExtraProperty = Real (min=0.0, final unit="1/kg", final quantity= "ExtraProperty")
    "Unspecified, mass-specific property transported by flow";

  type ExtraPropertyFlowRate = Real (final unit="1/s", final quantity= "ExtraPropertyFlowRate")
    "Flow rate of unspecified, mass-specific property";

  type ExtraPropertyConcentration = Real (final unit="1/m3", final quantity= "ExtraPropertyConcentration")
    "Concentration for unspecified, mass-specific property";

  type ExtraPropertyExtrinsic = Real (final unit="1", final quantity= "ExtraPropertyExtrinsic")
    "Value for unspecified property (e.g., atoms, mass, etc.)";
end Units;
