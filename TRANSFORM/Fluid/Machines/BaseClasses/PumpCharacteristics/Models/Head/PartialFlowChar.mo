within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Head;
partial model PartialFlowChar
  "Base class for pump flow characteristics. Extending class solves for head."
  extends PartialCharacteristic;
  input Boolean checkValve "=true then no reverse flow" annotation (Dialog(tab="Internal Interface",group="Inputs"));
  parameter SI.Height head_nominal "Nominal head" annotation (Dialog(tab="Internal Interface",group="Nominal Operating Parameters"));
  SI.Height head "Pump pressure head";
equation
  affinityLaw = (N/N_nominal)^2*(diameter/diameter_nominal)^2;
  annotation (defaultComponentName="flowCurve",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                             Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,12},{64,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFlowChar;
