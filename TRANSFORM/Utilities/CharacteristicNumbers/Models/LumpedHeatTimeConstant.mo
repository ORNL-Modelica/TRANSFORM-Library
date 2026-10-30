within TRANSFORM.Utilities.CharacteristicNumbers.Models;
model LumpedHeatTimeConstant
  parameter Boolean use_C = false "= true, to specify thermal capacitance";
  input SI.ThermalResistance R "Total thermal resistance" annotation(Dialog(group="Inputs"));
  input SI.Density d "Density" annotation(Dialog(group="Inputs",enable = not use_C));
  input SI.SpecificHeatCapacity cp "Specific heat capacity" annotation(Dialog(group="Inputs",enable = not use_C));
  input SI.Volume V "Volume" annotation(Dialog(group="Inputs",enable = not use_C));
  input SI.HeatCapacity C = d*V*cp "Thermal capacitance" annotation(Dialog(group="Inputs",enable = use_C));
  SI.Time tau "Diffusive heat transfer time constant";
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
algorithm
  tau := R*C;
  y:=tau;
  annotation (defaultComponentName="tau_lumped",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{20,40},{100,-40}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{20,26},{100,-24}},
          lineColor={0,0,0},
          textString="tau"),
        Text(
          extent={{-80,92},{200,52}},
          textString="%name",
          lineColor={0,0,255})}),                    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LumpedHeatTimeConstant;
