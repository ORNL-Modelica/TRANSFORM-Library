within TRANSFORM.Utilities.CharacteristicNumbers.Models;
model BiotNumber

  input SI.CoefficientOfHeatTransfer alpha "Heat transfer coefficient" annotation(Dialog(group="Input Variables"));
  input SI.Length L "Characteristic length" annotation(Dialog(group="Input Variables"));
  input SI.ThermalConductivity lambda "Thermal conductivity (e.g., of the solid)" annotation(Dialog(group="Input Variables"));

  Units.NonDim Bi "Biot number";

  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
algorithm
  Bi :=alpha*L/lambda;
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
end BiotNumber;
