within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Power;
partial model PartialPowerChar
  "Base class for pump power characteristics."
  extends PartialCharacteristic;
  parameter SI.Power W_nominal "Power consumption" annotation (Dialog(
        tab="Internal Interface", group="Nominal Operating Parameters"));
  input SI.MassFlowRate m_flow;
  SI.Power W "Power consumption";
equation
    affinityLaw = (N/N_nominal)^3*(diameter/diameter_nominal)^3;
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
end PartialPowerChar;
