within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
partial model PartialSinglePhase_modelBased
  extends PartialSinglePhase;

protected
  TRANSFORM.Media.MediaProps1Phase mediaProps_internal[nHT](
    redeclare each package Medium = Medium,
    h=mediaProps.h,
    d=mediaProps.d,
    T=mediaProps.T,
    p=mediaProps.p,
    mu=mediaProps.mu,
    lambda=mediaProps.lambda,
    cp=mediaProps.cp);
    //state=states,

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialSinglePhase_modelBased;
