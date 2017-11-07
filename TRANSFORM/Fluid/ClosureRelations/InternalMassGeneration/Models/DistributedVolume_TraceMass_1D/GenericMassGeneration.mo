within TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D;
model GenericMassGeneration

  import TRANSFORM.Math.fillArray_1D;

  extends PartialInternalMassGeneration;

  input SI.MassFlowRate mC_gen[Medium.nC]=zeros(Medium.nC) "Mole generation"  annotation(Dialog(group=
          "Input Variables"));
  input SI.MassFlowRate mC_gens[nV,Medium.nC]=fillArray_1D(mC_gen, nV)
    "if non-uniform then set n_gens"
    annotation (Dialog(group="Input Variables"));

equation

  for ic in 1:Medium.nC loop
    for i in 1:nV loop
      mC_flows[i, ic] =mC_gens[i, ic];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericMassGeneration;
