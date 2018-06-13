within TRANSFORM.Blocks.Noise.Records.PRBS;
record Bits_2

  extends TRANSFORM.Blocks.Noise.Records.PRBS.PartialPairing(final nBits = 2, final generator={1,1,1});

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Bits_2;
