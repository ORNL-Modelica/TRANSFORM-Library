within TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.Efficiency;
partial model PartialEfficiencyChar
  "Base class for pump efficiency characteristics."

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (Dialog(tab="Internal Interface"));

  input SI.VolumeFlowRate V_flow
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input Medium.ThermodynamicState state "Thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input Modelica.Units.NonSI.AngularVelocity_rpm N "Pump speed"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Length diameter "Impeller Diameter"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  parameter SI.VolumeFlowRate V_flow_start
    annotation (Dialog(tab="Internal Interface", group="Initialization"));

  parameter Modelica.Units.NonSI.AngularVelocity_rpm N_nominal
    "Pump speed" annotation (Dialog(tab="Internal Interface", group=
         "Nominal Operating Parameters"));
  parameter SI.Length diameter_nominal "Impeller Diameter" annotation (Dialog(
        tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.VolumeFlowRate V_flow_nominal "Nominal volumetric flow rate"
    annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));

  SI.Efficiency eta "Efficiency";
  Units.NonDim affinityLaw_flow=(N/N_nominal)*(diameter/diameter_nominal)^3
    "Affinity law for scaling";
  Units.NonDim affinityLaw_efficiency=1.0 "Affinity law for scaling";

  annotation (
    defaultComponentName="flowCurve",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,12},{64,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialEfficiencyChar;
