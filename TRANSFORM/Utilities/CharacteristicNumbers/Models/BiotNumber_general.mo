within TRANSFORM.Utilities.CharacteristicNumbers.Models;
model BiotNumber_general
  parameter Boolean use_R_cond_int = false "= true to specify internal conduction resistance resistance";
  input SI.ThermalResistance R_conv "External convective heat transfer resistance" annotation(Dialog(group="Inputs"));
  input SI.Length L "Characteristic length" annotation(Dialog(group="Inputs",enable = not use_R_cond_int));
  input SI.ThermalConductivity lambda "Thermal conductivity (e.g., of the solid)" annotation(Dialog(group="Inputs",enable = not use_R_cond_int));
  input SI.Area surfaceArea "Heat transfer surface area" annotation(Dialog(group="Inputs",enable = not use_R_cond_int));
  input SI.ThermalResistance R_cond_int = L/(lambda*surfaceArea) "Internal conduction resistance" annotation(Dialog(group="Inputs",enable = use_R_cond_int));
  Units.NonDim Bi "Biot number";
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
algorithm
  Bi :=R_cond_int/R_conv;
  y:=Bi;
  annotation (defaultComponentName="biotNumber",
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{20,40},{100,-40}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{20,26},{100,-26}},
          lineColor={0,0,0},
          textString="Bi"),
        Text(
          extent={{-80,92},{200,52}},
          textString="%name",
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BiotNumber_general;
