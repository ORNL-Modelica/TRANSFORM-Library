within TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D;
model GenericTraceGeneration

  import TRANSFORM.Math.fillArray_1D;

  extends PartialInternalTraceGeneration;

  input SIadd.ExtraPropertyFlowRate mC_gen[Medium.nC]=zeros(Medium.nC) "Mass generation"  annotation(Dialog(group=
          "Inputs"));
  input SIadd.ExtraPropertyFlowRate mC_gens[nV,Medium.nC]=fillArray_1D(mC_gen, nV)
    "if non-uniform then set mC_gens"
    annotation (Dialog(group="Inputs"));

equation

  for ic in 1:Medium.nC loop
    for i in 1:nV loop
      mC_flows[i, ic] =mC_gens[i, ic];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericTraceGeneration;
