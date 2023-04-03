within TRANSFORM.HeatExchangers;
model Simple_HX
import TRANSFORM.Math.linspace_1D;
import TRANSFORM.Math.linspaceRepeat_1D;

  replaceable package Medium_1 = Modelica.Media.Interfaces.PartialMedium "Fluid 1 medium"
    annotation (choicesAllMatching=true);
  replaceable package Medium_2 = Modelica.Media.Interfaces.PartialMedium "Fluid 2 medium"
    annotation (choicesAllMatching=true);

    parameter Integer nV = 1 "# of fluid volumes on each side";

  // parallel flow not currently implmented
  parameter Boolean counterCurrent=true "Swap side 2 heatPort vector" annotation (Evaluate=true, enable=false);

  input SI.Volume V_1 "Fluid volume" annotation(Dialog(group="Inputs"));
  input SI.Volume V_2 "Fluid volume" annotation(Dialog(group="Inputs"));

  input SI.ThermalConductance UA "Overall heat transfer coefficient" annotation(Dialog(group="Inputs"));
  input SIadd.NonDim CF = if abs(T_a_start_1-T_b_start_1) <= Modelica.Constants.eps or abs(T_a_start_2-T_b_start_2) <= Modelica.Constants.eps then 1.0 else TRANSFORM.HeatExchangers.Utilities.Functions.logMean(T_a_start_1 -
    T_b_start_1, T_b_start_2 - T_a_start_2)/nV "Correction factor" annotation(Dialog(group="Inputs"));
  input SIadd.NonDim CFs[nV]=fill(
      CF,
      nV) "if non-uniform then set"  annotation(Dialog(group="Inputs"));

// Initialization: Fluid 1
  parameter SI.AbsolutePressure[nV] ps_start_1=linspace_1D(
      p_a_start_1,
      p_b_start_1,
      nV) "Pressure" annotation (Dialog(tab="Initialization: Fluid 1",
        group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_a_start_1=Medium_1.p_default
    "Pressure at port a" annotation (Dialog(tab="Initialization: Fluid 1", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start_1= p_a_start_1 + (if m_flow_start_1 > 0 then -1e3 elseif m_flow_start_1 < 0 then -1e3 else 0)
    "Pressure at port b" annotation (Dialog(tab="Initialization: Fluid 1", group="Start Value: Absolute Pressure"));
  parameter Boolean use_Ts_start_1=true
    "Use T_start if true, otherwise h_start" annotation (Evaluate=true, Dialog(
        tab="Initialization: Fluid 1", group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start_1[nV]=linspace_1D(
      T_a_start_1,
      T_b_start_1,
      nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Initialization: Fluid 1",
      group="Start Value: Temperature",
      enable=use_Ts_start_1));
  parameter SI.Temperature T_a_start_1=Medium_1.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Initialization: Fluid 1",
      group="Start Value: Temperature",
      enable=use_Ts_start_1));
  parameter SI.Temperature T_b_start_1=T_a_start_1
    "Temperature at port b" annotation (Dialog(
      tab="Initialization: Fluid 1",
      group="Start Value: Temperature",
      enable=use_Ts_start_1));
  parameter SI.SpecificEnthalpy[nV] hs_start_1=if not
      use_Ts_start_1 then linspace_1D(
      h_a_start_1,
      h_b_start_1,
      nV) else {Medium_1.specificEnthalpy_pTX(
      ps_start_1[i],
      Ts_start_1[i],
      Xs_start_1[i, 1:Medium_1.nX]) for i in 1:nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Initialization: Fluid 1",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_1));
  parameter SI.SpecificEnthalpy h_a_start_1=
      Medium_1.specificEnthalpy_pTX(
      p_a_start_1,
      T_a_start_1,
      X_a_start_1) "Specific enthalpy at port a" annotation (Dialog(
      tab="Initialization: Fluid 1",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_1));
  parameter SI.SpecificEnthalpy h_b_start_1=
      Medium_1.specificEnthalpy_pTX(
      p_b_start_1,
      T_b_start_1,
      X_b_start_1) "Specific enthalpy at port b" annotation (Dialog(
      tab="Initialization: Fluid 1",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_1));
  parameter SI.MassFraction Xs_start_1[nV,Medium_1.nX]=
      linspaceRepeat_1D(
      X_a_start_1,
      X_b_start_1,
      nV) "Mass fraction" annotation (Dialog(
      tab="Initialization: Fluid 1",
      group="Start Value: Species Mass Fraction",
      enable=Medium_1.nXi > 0));
  parameter SI.MassFraction X_a_start_1[Medium_1.nX]=Medium_1.X_default
    "Mass fraction at port a" annotation (Dialog(tab="Initialization: Fluid 1",
        group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start_1[Medium_1.nX]=X_a_start_1
    "Mass fraction at port b" annotation (Dialog(tab="Initialization: Fluid 1",
        group="Start Value: Species Mass Fraction"));
  parameter SIadd.ExtraProperty Cs_start_1[nV,Medium_1.nC]=
      linspaceRepeat_1D(
      C_a_start_1,
      C_b_start_1,
      nV) "Mass-Specific value" annotation (Dialog(
      tab="Initialization: Fluid 1",
      group="Start Value: Trace Substances",
      enable=Medium_1.nC > 0));
  parameter SIadd.ExtraProperty C_a_start_1[Medium_1.nC]=fill(0,
      Medium_1.nC) "Mass-Specific value at port a" annotation (Dialog(tab="Initialization: Fluid 1",
        group="Start Value: Trace Substances"));
  parameter SIadd.ExtraProperty C_b_start_1[Medium_1.nC]=C_a_start_1
    "Mass-Specific value at port b" annotation (Dialog(tab="Initialization: Fluid 1",
        group="Start Value: Trace Substances"));
  parameter SI.MassFlowRate m_flow_start_1=0 "Mass flow rate"
    annotation (Dialog(tab="Initialization: Fluid 1"));

// Initialization: Fluid 2
  parameter SI.AbsolutePressure[nV] ps_start_2=linspace_1D(
      p_a_start_2,
      p_b_start_2,
      nV) "Pressure" annotation (Dialog(tab="Initialization: Fluid 2",
        group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_a_start_2=Medium_2.p_default
    "Pressure at port a" annotation (Dialog(tab="Initialization: Fluid 2", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start_2= p_a_start_2 + (if m_flow_start_2 > 0 then -2e3 elseif m_flow_start_2 < 0 then -2e3 else 0)
    "Pressure at port b" annotation (Dialog(tab="Initialization: Fluid 2", group="Start Value: Absolute Pressure"));
  parameter Boolean use_Ts_start_2=true
    "Use T_start if true, otherwise h_start" annotation (Evaluate=true, Dialog(
        tab="Initialization: Fluid 2", group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start_2[nV]=linspace_1D(
      T_a_start_2,
      T_b_start_2,
      nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Initialization: Fluid 2",
      group="Start Value: Temperature",
      enable=use_Ts_start_2));
  parameter SI.Temperature T_a_start_2=Medium_2.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Initialization: Fluid 2",
      group="Start Value: Temperature",
      enable=use_Ts_start_2));
  parameter SI.Temperature T_b_start_2=T_a_start_2
    "Temperature at port b" annotation (Dialog(
      tab="Initialization: Fluid 2",
      group="Start Value: Temperature",
      enable=use_Ts_start_2));
  parameter SI.SpecificEnthalpy[nV] hs_start_2=if not
      use_Ts_start_2 then linspace_1D(
      h_a_start_2,
      h_b_start_2,
      nV) else {Medium_2.specificEnthalpy_pTX(
      ps_start_2[i],
      Ts_start_2[i],
      Xs_start_2[i, 1:Medium_2.nX]) for i in 1:nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Initialization: Fluid 2",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_2));
  parameter SI.SpecificEnthalpy h_a_start_2=
      Medium_2.specificEnthalpy_pTX(
      p_a_start_2,
      T_a_start_2,
      X_a_start_2) "Specific enthalpy at port a" annotation (Dialog(
      tab="Initialization: Fluid 2",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_2));
  parameter SI.SpecificEnthalpy h_b_start_2=
      Medium_2.specificEnthalpy_pTX(
      p_b_start_2,
      T_b_start_2,
      X_b_start_2) "Specific enthalpy at port b" annotation (Dialog(
      tab="Initialization: Fluid 2",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_2));
  parameter SI.MassFraction Xs_start_2[nV,Medium_2.nX]=
      linspaceRepeat_1D(
      X_a_start_2,
      X_b_start_2,
      nV) "Mass fraction" annotation (Dialog(
      tab="Initialization: Fluid 2",
      group="Start Value: Species Mass Fraction",
      enable=Medium_2.nXi > 0));
  parameter SI.MassFraction X_a_start_2[Medium_2.nX]=Medium_2.X_default
    "Mass fraction at port a" annotation (Dialog(tab="Initialization: Fluid 2",
        group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start_2[Medium_2.nX]=X_a_start_2
    "Mass fraction at port b" annotation (Dialog(tab="Initialization: Fluid 2",
        group="Start Value: Species Mass Fraction"));
  parameter SIadd.ExtraProperty Cs_start_2[nV,Medium_2.nC]=
      linspaceRepeat_1D(
      C_a_start_2,
      C_b_start_2,
      nV) "Mass-Specific value" annotation (Dialog(
      tab="Initialization: Fluid 2",
      group="Start Value: Trace Substances",
      enable=Medium_2.nC > 0));
  parameter SIadd.ExtraProperty C_a_start_2[Medium_2.nC]=fill(0,
      Medium_2.nC) "Mass-Specific value at port a" annotation (Dialog(tab="Initialization: Fluid 2",
        group="Start Value: Trace Substances"));
  parameter SIadd.ExtraProperty C_b_start_2[Medium_2.nC]=C_a_start_2
    "Mass-Specific value at port b" annotation (Dialog(tab="Initialization: Fluid 2",
        group="Start Value: Trace Substances"));
    parameter SI.MassFlowRate m_flow_start_2=0 "Mass flow rate"
    annotation (Dialog(tab="Initialization: Fluid 2"));
// End Initialization

  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a1(
    redeclare package Medium = Medium_1,
    m_flow(start=m_flow_start_1),
    p(start=volume_1[1].p_start),
    h_outflow(start=volume_1[1].h_start)) annotation (Placement(transformation(
          extent={{-110,30},{-90,50}}), iconTransformation(extent={{-110,30},{-90,
            50}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b1(redeclare package Medium =
        Medium_1, m_flow(start=-m_flow_start_1)) annotation (Placement(
        transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,
            30},{110,50}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a2(
    redeclare package Medium = Medium_2,
    m_flow(start=m_flow_start_2),
    p(start=volume_2[1].p_start),
    h_outflow(start=volume_2[1].h_start)) annotation (Placement(transformation(
          extent={{90,-50},{110,-30}}), iconTransformation(extent={{90,-50},{110,
            -30}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b2(redeclare package Medium =
        Medium_2, m_flow(start=-m_flow_start_2)) annotation (Placement(
        transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(
          extent={{-110,-50},{-90,-30}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume_1[nV](
    redeclare package Medium = Medium_1,
    each energyDynamics=energyDynamics_1,
    p_start=ps_start_1,
    each use_T_start=false,
    T_start=Ts_start_1,
    h_start=hs_start_1,
    X_start=Xs_start_1,
    C_start=Cs_start_1,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (
          each V=V_1/nV),
    each use_HeatPort=true)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_1[nV](
      redeclare package Medium = Medium_1, each R=R_1/nV)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume_2[nV](
    redeclare package Medium = Medium_2,
    each energyDynamics=energyDynamics_2,
    p_start=ps_start_2,
    each use_T_start=false,
    T_start=Ts_start_2,
    h_start=hs_start_2,
    X_start=Xs_start_2,
    C_start=Cs_start_2,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (
          each V=V_2/nV),
    each use_HeatPort=true)
    annotation (Placement(transformation(extent={{40,-30},{20,-50}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_2[nV](
      redeclare package Medium = Medium_2, each R=R_2/nV)
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a1(redeclare package Medium =
               Medium_1)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b1(redeclare package Medium =
               Medium_1)
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a2(redeclare package Medium =
               Medium_2)
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b2(redeclare package Medium =
               Medium_2)
    annotation (Placement(transformation(extent={{-60,-50},{-80,-30}})));
  HeatAndMassTransfer.Resistances.Heat.Specified_Resistance heatTransfer[nV](
      R_val=R_val)
                  annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  input Units.HydraulicResistance R_1=(p_a_start_1-p_b_start_1)/m_flow_start_1 "Hydraulic resistance"
    annotation (Dialog(group="Inputs"));
  input Units.HydraulicResistance R_2=(p_a_start_2-p_b_start_2)/m_flow_start_2  "Hydraulic resistance"
    annotation (Dialog(group="Inputs"));

  SI.Power Q_flow = sum(heatTransfer.port_a.Q_flow);

  parameter Modelica.Fluid.Types.Dynamics energyDynamics_1=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics_2=energyDynamics_1
    "Formulation of energy balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  input SI.ThermalResistance R_val[nV]={1/(UA/nV*CFs[i]) for i in 1:nV} "Thermal resistance"
    annotation (Dialog(group="Inputs"));
equation

  connect(heatTransfer.port_a, volume_1.heatPort);
  if counterCurrent then
      for i in 1:nV loop
      connect(heatTransfer[i].port_b, volume_2[nV - i + 1].heatPort);
      end for;
  else
    connect(heatTransfer.port_b, volume_2.heatPort);
  end if;

  connect(sensor_T_a1.port_b, volume_1[1].port_a);
  connect(volume_1[1].port_b, resistance_1[1].port_a);
  for i in 2:nV loop
    connect(resistance_1[i - 1].port_b, volume_1[i].port_a);
    connect(volume_1[i].port_b, resistance_1[i].port_a);
  end for;
  connect(resistance_1[nV].port_b, sensor_T_b1.port_a);

  connect(sensor_T_a2.port_b, volume_2[1].port_a);
  connect(volume_2[1].port_b, resistance_2[1].port_a);
  for i in 2:nV loop
    connect(resistance_2[i - 1].port_b, volume_2[i].port_a);
    connect(volume_2[i].port_b, resistance_2[i].port_a);
  end for;
  connect(resistance_2[nV].port_b, sensor_T_b2.port_a);

  connect(port_a1, sensor_T_a1.port_a)
    annotation (Line(points={{-100,40},{-80,40}}, color={0,127,255}));
  connect(sensor_T_b1.port_b, port_b1)
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(port_a2, sensor_T_a2.port_a)
    annotation (Line(points={{100,-40},{80,-40}}, color={0,127,255}));
  connect(sensor_T_b2.port_b, port_b2)
    annotation (Line(points={{-80,-40},{-100,-40}}, color={0,127,255}));
  annotation (
    defaultComponentName="lmtd_HX",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,-40},{-60,-40},{-30,0},{0,-40},{30,0},{60,-40},{88,-40}},
            color={28,108,200}),
        Line(points={{-88,40},{-30,40},{0,0},{30,40},{88,40}}, color={238,46,47}),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Assumption:</p>
<p>Side 1 is hot side (i.e,. if Q_flow &lt; 0 then heat is going from Side 1 to Side 2)</p>
</html>"));
end Simple_HX;
