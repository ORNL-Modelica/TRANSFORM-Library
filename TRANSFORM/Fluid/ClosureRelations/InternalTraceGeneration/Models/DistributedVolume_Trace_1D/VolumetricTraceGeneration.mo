within TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D;
model VolumetricTraceGeneration

  import TRANSFORM.Math.fillArray_1D;

  extends PartialInternalTraceGeneration;

  input SIadd.ExtraPropertyConcentration mC_ppp[Medium.nC]=zeros(Medium.nC) "Mass concentration generation"  annotation(Dialog(group=
          "Inputs"));
  input SIadd.ExtraPropertyConcentration mC_ppps[nV,Medium.nC]=fillArray_1D(mC_ppp, nV)
    "if non-uniform then set mC_ppps"
    annotation (Dialog(group="Inputs"));

equation

  for ic in 1:Medium.nC loop
    for i in 1:nV loop
      mC_flows[i, ic] = mC_ppps[i, ic]*Vs[i];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricTraceGeneration;
