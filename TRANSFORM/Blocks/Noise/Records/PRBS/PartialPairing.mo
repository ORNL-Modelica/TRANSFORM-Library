within TRANSFORM.Blocks.Noise.Records.PRBS;
partial record PartialPairing

  extends TRANSFORM.Icons.Record;

  parameter Integer nBits;
  parameter Integer generator[nBits+1];

  annotation (defaultComponentName="bitPairing",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPairing;
