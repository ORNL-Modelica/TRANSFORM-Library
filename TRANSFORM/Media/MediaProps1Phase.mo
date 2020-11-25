within TRANSFORM.Media;
record MediaProps1Phase

  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));

  //Medium.ThermodynamicState state "Medium state"; //<-causes error as does not update state variables
  SI.SpecificEnthalpy h "Fluid specific enthalpy";
  SI.Density d "Fluid density";
  SI.Temperature T "Fluid temperature";
  SI.Pressure p "Fluid pressure";
  Medium.DynamicViscosity mu "Dynamic viscosity";
  Medium.ThermalConductivity lambda "Thermal conductivity";
  Medium.SpecificHeatCapacity cp "Specific heat capacity";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MediaProps1Phase;
