within TRANSFORM.HeatExchangers.BaseClasses;
record Summary

  extends Icons.Record;

  input SI.ThermalResistance R_shell "Thermal resistance between shell and wall" annotation (Dialog(group="Inputs"));
  input SI.ThermalResistance R_tubeWall "Thermal resistance through the wall" annotation (Dialog(group="Inputs"));
  input SI.ThermalResistance R_tube "Thermal resistance between tube and wall" annotation (Dialog(group="Inputs"));

  annotation (
    defaultComponentName="summary",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Summary;
