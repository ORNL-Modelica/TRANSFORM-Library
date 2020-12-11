within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models;
partial model PartialCharacteristic
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState state "Thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.VolumeFlowRate V_flow(start=V_flow_start) "Mass flow rate"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input Modelica.Units.NonSI.AngularVelocity_rpm N "Pump speed"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Length diameter "Impeller Diameter"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  parameter Modelica.Units.NonSI.AngularVelocity_rpm N_nominal
    "Pump speed" annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.Length diameter_nominal "Impeller Diameter" annotation (Dialog(
        tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.VolumeFlowRate V_flow_nominal "Nominal volumetric flow rate"
    annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.VolumeFlowRate V_flow_start
    annotation (Dialog(tab="Internal Interface", group="Initialization"));
  Units.NonDim affinityLaw "Affinity law for scaling";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialCharacteristic;
