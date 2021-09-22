within TRANSFORM.HeatExchangers;
model CondensationConvectionHXsmooth
  "Condensing and convecting HX with smooth condensation"
  replaceable package Medium_1 =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);
  replaceable package Medium_2 =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);
  Modelica.Units.SI.Power Q_flow_condensation;
  Modelica.Units.SI.Power Q_flow_convection;
  input Real condensation_quality = 0 annotation (Dialog(tab="Condensation", group="Inputs"));
  TRANSFORM.HeatExchangers.Simple_HX convectionHX(
    redeclare package Medium_1 = Medium_1,
    redeclare package Medium_2 = Medium_2,
    nV=nV,
    V_1=V_convection1,
    V_2=V_convection2,
    UA=uAdT_lm.UA,
    CF=CF,
    ps_start_1=ps_start_convection1,
    use_Ts_start_1=false,
    hs_start_1=hs_start_convection1,
    m_flow_start_1=m_flow_start_convection1,
    ps_start_2=ps_start_convection2,
    Ts_start_2=Ts_start_convection2,
    m_flow_start_2=m_flow_start_convection2,
    R_1=R_convection1,
    R_2=R_convection2)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  TRANSFORM.HeatExchangers.UAdT_lm uAdT_lm(
    calcType="UA",
    Ts_h=Ts_h,
    Ts_c=Ts_c,
    Q_flow=Q_flow_nominal_convection)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Fluid.Interfaces.FluidPort_State           port_a1(redeclare package Medium =
        Medium_1)                         annotation (Placement(
        transformation(extent={{-110,30},{-90,50}}), iconTransformation(
          extent={{-110,30},{-90,50}})));
  Fluid.Interfaces.FluidPort_Flow           port_b2(redeclare package Medium =
        Medium_2)  annotation (Placement(
        transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(
          extent={{-110,-50},{-90,-30}})));
  Fluid.Interfaces.FluidPort_State           port_a2(redeclare package Medium =
        Medium_2)                         annotation (Placement(
        transformation(extent={{90,-50},{110,-30}}), iconTransformation(
          extent={{90,-50},{110,-30}})));
  Fluid.Interfaces.FluidPort_Flow           port_b1(redeclare package Medium =
        Medium_1)  annotation (Placement(
        transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,30},
            {110,50}})));

  parameter SI.AbsolutePressure p_start_condensation1
    "Pressure" annotation (Dialog(tab="Initialization", group="Condensation"));
  parameter SI.SpecificEnthalpy h_start_condensation1 "Specific enthalpy"
    annotation (Dialog(tab="Initialization", group="Condensation"));
  input Units.HydraulicResistance R_condensation1 "Hydraulic resistance"
    annotation (Dialog(tab="Condensation", group="Inputs"));
  parameter SI.Volume V_condensation1=0.0 "Volume"
    annotation (Dialog(tab="Condensation", group="Inputs"));

  parameter Units.HydraulicResistance R_condensation2 "Hydraulic resistance"
    annotation (Dialog(tab="Condensation", group="Inputs"));
  parameter SI.Volume V_condensation2=0.0 "Volume"
    annotation (Dialog(tab="Condensation", group="Inputs"));
  parameter SI.AbsolutePressure p_start_condensation2 "Pressure"
    annotation (Dialog(tab="Initialization", group="Condensation"));
  parameter SI.SpecificEnthalpy h_start_condensation2 "Specific enthalpy"
    annotation (Dialog(tab="Initialization", group="Condensation"));
  input SI.Temperature Ts_h[2] "Hot side temperature {inlet, outlet}"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  input SI.Temperature Ts_c[2] "Cold side temperature {inlet, outlet}"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  input SI.HeatFlowRate Q_flow_nominal_convection "Heat transfer rate (e.g., m__flow*cp*dT)"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  parameter Integer nV=2 "# of fluid volumes on each side"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  parameter SI.Volume V_convection1 "Fluid volume"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  parameter SI.Volume V_convection2 "Fluid volume"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  input Units.NonDim CF=1.0 "Correction factor"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  parameter Units.HydraulicResistance R_convection1
    "Hydraulic resistance"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  parameter Units.HydraulicResistance R_convection2 "Hydraulic resistance"
    annotation (Dialog(tab="Convection", group="LMTD HX"));
  parameter SI.AbsolutePressure ps_start_convection1[nV] "Pressure"
    annotation (Dialog(tab="Initialization", group="Convection"));
  parameter SI.SpecificEnthalpy hs_start_convection1[nV] "Specific enthalpy"
    annotation (Dialog(tab="Initialization", group="Convection"));
  parameter SI.MassFlowRate m_flow_start_convection1 "Mass flow rate"
    annotation (Dialog(tab="Initialization", group="Convection"));
  parameter SI.AbsolutePressure ps_start_convection2[nV] "Pressure"
    annotation (Dialog(tab="Initialization", group="Convection"));
  parameter SI.Temperature Ts_start_convection2[nV] "Temperature"
    annotation (Dialog(tab="Initialization", group="Convection"));
  parameter SI.MassFlowRate m_flow_start_convection2 "Mass flow rate"
    annotation (Dialog(tab="Initialization", group="Convection"));
  CondensationHXSmooth
                 condensationHXSmooth(
    redeclare package Medium_1 = Medium_1,
    redeclare package Medium_2 = Medium_2,
    T_range=T_range,
    condensation_quality=condensation_quality,
    Q_flow_condensation_max=Q_flow_condensation_max,
    p_start_condensation1=p_start_condensation1,
    h_start_condensation1=h_start_condensation1,
    R_condensation1=R_condensation1,
    V_condensation1=V_condensation1,
    R_condensation2=R_condensation2,
    V_condensation2=V_condensation2,
    p_start_condensation2=p_start_condensation2,
    h_start_condensation2=h_start_condensation2)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  input SI.TemperatureDifference T_range=5
    "Range of condensation smoothing"
    annotation (Dialog(tab="Condensation", group="Inputs"));
  input SI.HeatFlowRate Q_flow_condensation_max
    annotation (Dialog(tab="Condensation", group="Inputs"));
equation
  Q_flow_convection =convectionHX.Q_flow;
  Q_flow_condensation =condensationHXSmooth.Q_flow_condensation;

  connect(port_a2, convectionHX.port_a2) annotation (Line(points={{100,-40},{70,
          -40},{70,-4},{60,-4}}, color={0,127,255}));
  connect(port_b1, convectionHX.port_b1) annotation (Line(points={{100,40},{70,
          40},{70,4},{60,4}}, color={0,127,255}));
  connect(condensationHXSmooth.port_a1, port_a1) annotation (Line(points={{-60,
          4},{-86,4},{-86,40},{-100,40}}, color={0,127,255}));
  connect(condensationHXSmooth.port_b1, convectionHX.port_a1)
    annotation (Line(points={{-40,4},{40,4}}, color={0,127,255}));
  connect(condensationHXSmooth.port_a2, convectionHX.port_b2)
    annotation (Line(points={{-40,-4},{40,-4}}, color={0,127,255}));
  connect(condensationHXSmooth.port_b2, port_b2) annotation (Line(points={{-60,
          -4},{-86,-4},{-86,-40},{-100,-40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{0,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-100,60},{0,-60}},
          lineColor={0,0,0},
          fillColor={170,255,255},
          fillPattern=FillPattern.CrossDiag),
        Line(points={{-88,-40},{-60,-40},{-30,0},{0,-40},{30,0},{60,-40},{88,
              -40}},
            color={28,108,200},
          thickness=0.5),
        Line(points={{-88,40},{-30,40},{0,0},{30,40},{88,40}},     color={238,
              46,47},
          thickness=0.5),
        Text(
          extent={{-147,-68},{153,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
        graphics={                                                 Text(
          extent={{-80,-60},{-20,-80}},
          textColor={28,108,200},
          textString="Condensation zone"), Text(
          extent={{20,-60},{80,-80}},
          textColor={28,108,200},
          textString="Convection zone")}),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"));
end CondensationConvectionHXsmooth;
