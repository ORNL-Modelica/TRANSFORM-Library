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
      TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts.fissionProducts_test
    constrainedby
    TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts.PartialFissionProduct
    "Fission product information" annotation (choicesAllMatching=true);

  FissionProducts fissionProducts;

  replaceable record Tritium =
      TRANSFORM.Examples.MoltenSaltReactor.Data.Tritium.FLiBe
    constrainedby
    TRANSFORM.Examples.MoltenSaltReactor.Data.Tritium.PartialTritium
    "Tritium information" annotation (choicesAllMatching=true);

  Tritium tritium;

  // Trace Substances
  constant String[:] extraPropertiesNames=cat(
      1,
      precursorGroups.extraPropertiesNames,
      fissionProducts.extraPropertiesNames,
      tritium.extraPropertiesNames)
    "Names of the additional (extra) transported properties";

  final constant Integer nC=size(extraPropertiesNames, 1)
    "Number of extra (outside of standard mass-balance) transported properties";
  constant Real C_nominal[nC]=cat(
      1,
      precursorGroups.C_nominal,
      fissionProducts.C_nominal,
      tritium.C_nominal)
    "Default for the nominal values for the extra properties";

  // Indexing of substance categories
  final constant Integer[2] iPG={1,precursorGroups.nC}
    "First and last index of precursors groups";
  final constant Integer[2] iFP={iPG[2] + 1,iPG[2] + fissionProducts.nC} "First and last index of fission products";
  final constant Integer[2] iTR={iFP[2] + 1,iFP[2] + tritium.nC} "First and last index of tritium contributors";

  final constant Integer iH3 = TRANSFORM.Utilities.Strings.index("1-H-3",fissionProducts.extraPropertiesNames) "Index of tritium (1-H-3) in fission products array"
                                                                                                                                                                   annotation (Dialog(tab="Tritium Balance"));

  // Data for entire array of trace substances
  final parameter SIadd.InverseTime[nC] lambdas=cat(
      1,
      precursorGroups.lambdas,
      fissionProducts.lambdas,
      tritium.lambdas) "Decay constant";

  constant Real[precursorGroups.nC,nC] p_PG=cat(
      2,
      precursorGroups.parents,
      fill(
        0,
        precursorGroups.nC,
        nC - precursorGroups.nC));
  constant Real[fissionProducts.nC,nC] p_FP=cat(
      2,
      fill(
        0,
        fissionProducts.nC,
        nC - fissionProducts.nC),
      fissionProducts.parents);
  constant Real[tritium.nC,nC] p_Tr=cat(
      2,
      fill(
        0,
        tritium.nC,
        nC - tritium.nC),
      tritium.parents);
  constant Real[nC,nC] parents=cat(
      1,
      p_PG,
      p_FP,
      p_Tr);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end data_traceSubstances;
