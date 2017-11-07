within TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D;
partial model PartialInternalHeatGeneration

  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));

  parameter Integer nV(min=1) = 1 "Number of discrete volumes"
    annotation(Dialog(tab="Internal Interface"));

  input Medium.ThermodynamicState[nV] states "Volume thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));
  input SI.Volume Vs[nV]
    "Volumes"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));
  input SI.Diameter dimensions[nV]
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));
  input SI.Area crossAreas[nV] "Volumes cross sectional area"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));
  input SI.Length dlengths[nV]
    "Volumes length"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));

  // Variables defined by model
  output SI.HeatFlowRate Q_flows[nV] "Internal heat generated" annotation (
      Dialog(
      group="Output Variables",
      tab="Internal Interface",
      enable=false));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-120,-100},{120,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/ClosureModel_Qgen.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialInternalHeatGeneration;
