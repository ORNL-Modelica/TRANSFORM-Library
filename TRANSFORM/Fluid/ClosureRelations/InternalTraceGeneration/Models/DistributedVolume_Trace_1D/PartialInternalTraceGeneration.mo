within TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D;
partial model PartialInternalTraceGeneration
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));
  parameter Integer nV(min=1) = 1 "Number of discrete volumes"
    annotation (Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState[nV] states "Volume thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SIadd.ExtraProperty Cs[nV,Medium.nC] "Trace mass-specific value  in volumes"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Volume Vs[nV]
    "Volumes"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Diameter dimensions[nV]
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Area crossAreas[nV] "Volumes cross sectional area"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Length dlengths[nV]
    "Volumes length"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  // Variables defined by model
  output SIadd.ExtraPropertyFlowRate mC_flows[nV,Medium.nC] "Internal mass generation"
    annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-120,-100},{120,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/ClosureModel_Ngen.jpg")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialInternalTraceGeneration;
