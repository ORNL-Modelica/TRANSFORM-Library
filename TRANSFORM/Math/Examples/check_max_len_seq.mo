within TRANSFORM.Math.Examples;
model check_max_len_seq
  extends TRANSFORM.Icons.Example;

  parameter Real bias = 0 "Bias from nominal middle value of signal";
  parameter Integer nBits = 3 "Sequence bit length";
  parameter Integer seed[nBits]=cat(1,{1},fill(0,nBits-2),{1})
    "Seed sequence array of 1 and 0, size(seed) = nBits";
  parameter Integer generator[nBits+1]={1,1,0,1} "Generator for sequence. size(generator) = nBits+1";

  final parameter Real y[integer(2^nBits - 1)]=
      TRANSFORM.Math.max_len_seq(seed,generator, bias);

  Utilities.ErrorAnalysis.UnitTests unitTests(n=7, x=y)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end check_max_len_seq;
