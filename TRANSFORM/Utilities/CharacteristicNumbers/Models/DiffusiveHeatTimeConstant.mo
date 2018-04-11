within TRANSFORM.Utilities.CharacteristicNumbers.Models;
model DiffusiveHeatTimeConstant

  parameter Boolean use_alpha_d = false "= true, to specify thermal diffusivity";

  input SI.Length L "Characteristic length" annotation(Dialog(group="Inputs"));

  input SI.Density d "Density" annotation(Dialog(group="Inputs",enable = not use_alpha_d));
  input SI.SpecificHeatCapacity cp "Specific heat capacity" annotation(Dialog(group="Inputs",enable = not use_alpha_d));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs",enable = not use_alpha_d));
  input SI.ThermalDiffusivity alpha_d = lambda/(d*cp) "Thermal diffusivity" annotation(Dialog(group="Inputs",enable = use_alpha_d));

  SI.Time tau "Diffusive heat transfer time constant";

  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
algorithm
  tau := 0.25*L^2/alpha_d;
  y:=tau;

  annotation (defaultComponentName="tau_diff",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-80,92},{200,52}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{20,40},{100,-40}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{20,26},{100,-24}},
          lineColor={0,0,0},
          textString="tau")}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DiffusiveHeatTimeConstant;
