within TRANSFORM.Fluid.Machines.BaseClasses.TurbineMaps;
model PartialCharacteristic

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState state "Thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Conversions.NonSIunits.AngularVelocity_rpm N "Pump speed";

  output Real result;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end PartialCharacteristic;
