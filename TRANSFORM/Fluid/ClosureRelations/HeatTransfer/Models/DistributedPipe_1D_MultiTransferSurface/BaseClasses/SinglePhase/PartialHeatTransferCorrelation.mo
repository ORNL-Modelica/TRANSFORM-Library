within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.SinglePhase;
partial model PartialHeatTransferCorrelation

  extends TRANSFORM.Icons.UnderConstruction;

  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));

  input SI.ReynoldsNumber Re "Reynolds number"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.PrandtlNumber Pr "Prandtl number"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input TRANSFORM.Media.MediaProps1Phase mediaProps "Fluid properties"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input Medium.ThermodynamicState state_wall
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  output SI.NusseltNumber Nu "Nusselt number"
    annotation (Dialog(tab="Internal Interface", group="Outputs"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransferCorrelation;
