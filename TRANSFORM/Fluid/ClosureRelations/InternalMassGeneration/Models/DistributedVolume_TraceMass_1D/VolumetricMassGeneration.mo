within TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D;
model VolumetricMassGeneration

  import TRANSFORM.Math.fillArray_1D;

  extends PartialInternalMassGeneration;

  input SI.Concentration mC_ppp[Medium.nC]=zeros(Medium.nC) "Molar concentration generation"  annotation(Dialog(group=
          "Input Variables"));
  input SI.Concentration mC_ppps[nV,Medium.nC]=fillArray_1D(mC_ppp, nV)
    "if non-uniform then set n_ppps"
    annotation (Dialog(group="Input Variables"));

equation

  for ic in 1:Medium.nC loop
    for i in 1:nV loop
      mC_flows[i, ic] = mC_ppps[i, ic]*Vs[i];
  end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VolumetricMassGeneration;
