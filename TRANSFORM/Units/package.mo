within TRANSFORM;
package Units "Additional models, functions, types, etc. for units"
  extends TRANSFORM.Icons.UnitsPackage;


  type NeutronFlux = Real (final unit="1/(m2.s)", final quantity= "NeutronFlux")
    "Neutron flux [1/(m2.s)]";
end Units;
