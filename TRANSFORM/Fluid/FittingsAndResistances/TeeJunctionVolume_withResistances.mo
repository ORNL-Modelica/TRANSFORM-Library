within TRANSFORM.Fluid.FittingsAndResistances;
model TeeJunctionVolume_withResistances
  "Splitting/joining component with static balances for a dynamic control volume"
  import Modelica.Fluid.Types.Dynamics;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium properties" annotation (choicesAllMatching=true);
  // Inputs provided to the volume model
  input SI.Volume V(min=0) "Volume" annotation (Dialog(group="Inputs"));
  // Initialization
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  final parameter Dynamics substanceDynamics=massDynamics
    "Formulation of substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter SI.AbsolutePressure p_start=Medium.p_default "Pressure" annotation
    (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter Boolean use_T_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_start=Medium.T_default "Temperature" annotation (
      Evaluate=true, Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_T_start));
  parameter SI.SpecificEnthalpy h_start=Medium.specificEnthalpy_pTX(p_start,
      T_start, X_start) "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_T_start));
  parameter SI.MassFraction X_start[Medium.nX]=Medium.X_default "Mass fraction"
    annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SIadd.ExtraProperty C_start[Medium.nC]=fill(0, Medium.nC)
    "Mass-Specific value" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances",
      enable=Medium.nC > 0));

  Interfaces.FluidPort_Flow port_1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FluidPort_Flow port_2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Interfaces.FluidPort_Flow port_3(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  replaceable PressureLoss resistance_1(dp0(displayUnit="Pa") = 0.01)
    constrainedby BaseClasses.PartialResistance(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})),
      choicesAllMatching=true);
  replaceable PressureLoss resistance_2(dp0(displayUnit="Pa") = 0.01)
    constrainedby BaseClasses.PartialResistance(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{60,-10},{80,10}})),
      choicesAllMatching=true);
  replaceable PressureLoss resistance_3(dp0(displayUnit="Pa") = 0.01)
    constrainedby BaseClasses.PartialResistance(redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,70})), choicesAllMatching=true);
  TeeJunctionVolume volume(
    redeclare package Medium = Medium,
    V=V,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    traceDynamics=traceDynamics,
    p_start=p_start,
    use_T_start=use_T_start,
    T_start=T_start,
    h_start=h_start,
    X_start=X_start,
    C_start=C_start)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation

  connect(port_1, resistance_1.port_a)
    annotation (Line(points={{-100,0},{-77,0}}, color={0,127,255}));
  connect(port_3, resistance_3.port_b)
    annotation (Line(points={{0,100},{0,77}}, color={0,127,255}));
  connect(resistance_2.port_b, port_2)
    annotation (Line(points={{77,0},{100,0}}, color={0,127,255}));
  connect(resistance_1.port_b, volume.port_1)
    annotation (Line(points={{-63,0},{-10,0}}, color={0,127,255}));
  connect(volume.port_2, resistance_2.port_a)
    annotation (Line(points={{10,0},{63,0}}, color={0,127,255}));
  connect(volume.port_3, resistance_3.port_a)
    annotation (Line(points={{0,10},{0,63}}, color={0,127,255}));
  annotation (
    defaultComponentName="tee",
    Documentation(info="<html>
  This model introduces a mixing volume into a junction.
  This might be useful to examine the non-ideal mixing taking place in a real junction.</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-40,90},{40,40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-9,10},{11,-10}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end TeeJunctionVolume_withResistances;
