within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1;
partial record DiffusivityRecord

  parameter SI.MolarEnergy Ea[nVs[1],nC] "Activation energy";
  parameter Real A[nVs[1],nC] "Pre-exponential factor";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DiffusivityRecord;
