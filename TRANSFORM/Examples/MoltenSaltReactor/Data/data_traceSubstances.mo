within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_traceSubstances
  extends TRANSFORM.Icons.Record;

  replaceable record PrecursorGroups =
      TRANSFORM.Examples.MoltenSaltReactor.Data.PrecursorGroups.precursorGroups_6_description
    constrainedby
    TRANSFORM.Examples.MoltenSaltReactor.Data.PrecursorGroups.PartialPrecursorGroup
    "Precursor group information" annotation (choicesAllMatching=true);

  PrecursorGroups precursorGroups;

  replaceable record FissionProducts =
      TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts.fissionProducts_65_U235_Pu239
    constrainedby
    TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts.PartialFissionProduct
    "Fission product information" annotation (choicesAllMatching=true);

  FissionProducts fissionProducts;

  // Trace Substances
  constant String[:] extraPropertiesNames=cat(1,precursorGroups.extraPropertiesNames,fissionProducts.extraPropertiesNames)
    "Names of the additional (extra) transported properties";

  final constant Integer nC=size(extraPropertiesNames, 1)
    "Number of extra (outside of standard mass-balance) transported properties";
  constant Real C_nominal[nC]=cat(1,precursorGroups.C_nominal,fissionProducts.C_nominal)
    "Default for the nominal values for the extra properties";

  // Indexing of substance categories
  final constant Integer[2] iPG = {1,precursorGroups.nC} "First and last index of precursors groups";
  final constant Integer[2] iFP = {precursorGroups.nC+1,precursorGroups.nC + fissionProducts.nC} "First and last index of precursors groups";

  // Data for entire array of trace substances
  final parameter SIadd.InverseTime[nC] lambdas = cat(1,precursorGroups.lambdas,fissionProducts.lambdas) "Decay constant";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end data_traceSubstances;
