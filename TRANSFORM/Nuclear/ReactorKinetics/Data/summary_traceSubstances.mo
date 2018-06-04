within TRANSFORM.Nuclear.ReactorKinetics.Data;
model summary_traceSubstances
  extends TRANSFORM.Icons.Record;

  replaceable record Data_PG =
      TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_TRACEdefault
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.PartialPrecursorGroup
    "Precursor group information" annotation (choicesAllMatching=true);

  Data_PG data_PG;

  replaceable record Data_FP =
      TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_test
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.PartialFissionProduct
    "Fission product information" annotation (choicesAllMatching=true);

  Data_FP data_FP;

  replaceable record Data_TR =
      TRANSFORM.Nuclear.ReactorKinetics.Data.Tritium.FLiBe constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.Tritium.PartialTritium
    "Tritium information" annotation (choicesAllMatching=true);

  Data_TR data_TR;

  replaceable record Data_CP =
      TRANSFORM.Nuclear.ReactorKinetics.Data.CorrosionProducts.corrosionProduct_1_Cr
                                                                                              constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.CorrosionProducts.PartialCorrosionProduct
    "Corrosion Product information" annotation (choicesAllMatching=true);

  Data_CP data_CP;

  // Trace Substances
  constant String[:] extraPropertiesNames=cat(
      1,
      data_PG.extraPropertiesNames,
      data_FP.extraPropertiesNames,
      data_TR.extraPropertiesNames,
      data_CP.extraPropertiesNames)
    "Names of the additional (extra) transported properties";

  final constant Integer nC=size(extraPropertiesNames, 1)
    "Number of extra (outside of standard mass-balance) transported properties";
  constant Real C_nominal[nC]=cat(
      1,
      data_PG.C_nominal,
      data_FP.C_nominal,
      data_TR.C_nominal,
      data_CP.C_nominal)
    "Default for the nominal values for the extra properties";

  // Indexing of substance categories
  final constant Integer[2] iPG={1,data_PG.nC}
    "First and last index of precursors groups";
  final constant Integer[2] iFP={iPG[2] + 1,iPG[2] + data_FP.nC}
    "First and last index of fission products";
  final constant Integer[2] iTR={iFP[2] + 1,iFP[2] +data_TR.nC}  "First and last index of tritium contributors";
  final constant Integer[2] iCP={iTR[2] + 1,iTR[2] +data_CP.nC}  "First and last index of corrosion products";

  final constant Integer iH3=TRANSFORM.Utilities.Strings.index("1-H-3", extraPropertiesNames)
    "Index of tritium (1-H-3) in fission products array"
    annotation (Dialog(tab="Tritium Balance"));

  // Data for entire array of trace substances
  final parameter SIadd.InverseTime[nC] lambdas=cat(
      1,
      data_PG.lambdas,
      data_FP.lambdas,
      data_TR.lambdas,
      data_CP.lambdas) "Decay constant";

  final parameter SI.Energy w_near_decay[nC]=cat(
      1,
      data_PG.w_near_decay,
      data_FP.w_near_decay,
      data_TR.w_near_decay,
      data_CP.w_near_decay) "Decay (near-field) energy";

  final parameter SI.Energy w_far_decay[nC]=cat(
      1,
      data_PG.w_far_decay,
      data_FP.w_far_decay,
      data_TR.w_far_decay,
      data_CP.w_far_decay) "Decay (far-field) energy";

  constant Real[data_PG.nC,nC] p_PG=cat(
      2,
      data_PG.parents,
      fill(0,data_PG.nC,nC - data_PG.nC));
  constant Real[data_FP.nC,nC] p_FP=cat(
      2,
      fill(0,data_FP.nC,nC - data_FP.nC),data_FP.parents);
  constant Real p_TR[data_TR.nC,nC]=cat(
      2,
      fill(
        0,
        data_TR.nC,
        nC - data_TR.nC),
      data_TR.parents);
  constant Real[data_CP.nC,nC] p_CP=cat(
      2,
      fill(0,data_CP.nC,nC -data_CP.nC),data_CP.parents);
  constant Real[nC,nC] parents=cat(
      1,
      p_PG,
      p_FP,p_TR,
      p_CP);

  annotation (defaultComponentName="summary_data",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end summary_traceSubstances;
