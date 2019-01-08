within TRANSFORM.Math.Examples;
model check_max_len_seq_ternary
  extends TRANSFORM.Icons.Example;

  parameter Real bias=0 "Bias from nominal middle value of signal";
  parameter Integer nBits=3 "Sequence bit length";
  parameter Integer seed[nBits]=cat(
      1,
      {-1},
      fill(1, nBits - 2),
      {0}) "Seed sequence array of -1, 1, and 0, size(seed) = nBits"
    annotation (Dialog(group="Sequence"));
  parameter Integer generator[nBits]={1,2,2}
    "Generator for sequence. size(generator) = nBits";

  final parameter Real y[integer(3^nBits - 1)]=
      TRANSFORM.Math.max_len_seq_ternary(
      seed,
      generator,
      bias);

  Utilities.ErrorAnalysis.UnitTests unitTests(x={y[10]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end check_max_len_seq_ternary;
