within TRANSFORM.Media.LookupTableMedia.BaseClasses.Common;
record FluidConstants
  "Critical, triple, molecular and other standard data of fluid"
  extends Modelica.Icons.Record;
  String iupacName
    "Complete IUPAC name (or common name, if non-existent)";
  String casRegistryNumber
    "Chemical abstracts sequencing number (if it exists)";
  String chemicalFormula
    "Chemical formula, (brutto, nomenclature according to Hill";
  String structureFormula "Chemical structure formula";
  Modelica.Media.Interfaces.Types.MolarMass molarMass "Molar mass";
  AbsolutePressure criticalPressure "Critical pressure";
end FluidConstants;
