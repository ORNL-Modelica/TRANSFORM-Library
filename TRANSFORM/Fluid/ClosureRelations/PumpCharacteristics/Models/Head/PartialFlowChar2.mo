within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head;
partial model PartialFlowChar2
  "Base class for pump flow characteristics. Extending class solves for head."
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState state "Thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  SI.VolumeFlowRate V_flow(start=V_flow_start) "Flow rate";

  input SI.Conversions.NonSIunits.AngularVelocity_rpm N "Pump speed"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Length diameter "Impeller Diameter"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  parameter SI.Conversions.NonSIunits.AngularVelocity_rpm N_nominal
    "Pump speed" annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.Length diameter_nominal "Impeller Diameter" annotation (Dialog(
        tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.VolumeFlowRate V_flow_nominal "Nominal volumetric flow rate"
    annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.VolumeFlowRate V_flow_start
    annotation (Dialog(tab="Internal Interface", group="Initialization"));
  parameter SI.Height head_start;
  parameter Boolean checkValve "=true then no reverse flow" annotation (Dialog(tab="Internal Interface",group="Inputs"));
  parameter SI.Height head_nominal "Nominal head" annotation (Dialog(tab="Internal Interface",group="Nominal Operating Parameters"));
  input SI.Height head(start=head_start) "Pump pressure head" annotation (Dialog(tab="Internal Interface", group="Inputs"));
  Units.NonDim affinityLaw_flow = (N/N_nominal)*(diameter/diameter_nominal) "Affinity law for scaling";
  Units.NonDim affinityLaw_head = (N/N_nominal)^2*(diameter/diameter_nominal)^2 "Affinity law for scaling";

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
end PartialFlowChar2;
