within TRANSFORM.Utilities.CharacteristicNumbers.Models;
model DiffusiveMassTimeConstant

  input SI.Length L "Characteristic length" annotation(Dialog(group="Input Variables"));

  input SI.DiffusionCoefficient D_ab "Diffusion coefficient" annotation(Dialog(group="Input Variables"));

  SI.Time tau "Diffusive mass transfer time constant";

  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
algorithm
  tau := 0.25*L^2/D_ab;
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
end DiffusiveMassTimeConstant;
