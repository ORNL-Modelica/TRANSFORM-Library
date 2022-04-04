within TRANSFORM.Fluid.TraceComponents;
model DecayBed_Simple
  import TRANSFORM.Math.linspace_1D;
  import TRANSFORM.Math.linspaceRepeat_1D;
  import Units;

  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);

  parameter Integer nV(min=1) = 1 "Number of volume nodes";
  input SI.Volume V = 0.0 "Total volume" annotation (Dialog(group="Inputs"));
  input SI.Volume Vs[nV] = fill(V/nV,nV) "Volume per element" annotation (Dialog(group="Inputs"));
  input Units.HydraulicResistance R[nV]=fill(0.00001, nV)
    "Hydraulic resistance" annotation (Dialog(group="Inputs"));

  parameter TRANSFORM.Units.InverseTime lambdas[Medium.nC]=fill(0,Medium.nC) "Species decay constant";

  parameter Boolean use_PtoD = true "=true to turn on parent to daughter generation";
  parameter Real parents[Medium.nC,Medium.nC]
    "Matrix of parent sources (sum(column) = 0 or 1) for each fission product 'daughter'. Row is daughter, Column is parent.";

  SIadd.ExtraPropertyFlowRate[nV,Medium.nC] mC_gens={{mC_decay[i, j]
  + (if use_PtoD then mC_gens_PtoD[i, j] else 0)
  for j in 1:Medium.nC} for i in 1:nV};
  SIadd.ExtraPropertyFlowRate[nV,Medium.nC] mC_decay = {{-lambdas[j]*volume[i].mC[j] for j in 1:Medium.nC} for i in 1:nV};
  SIadd.ExtraPropertyFlowRate[nV,Medium.nC] mC_gens_PtoD={{sum({lambdas[k]*volume[i].mC[k]*parents[j, k] for k in 1:Medium.nC}) for j in 1:Medium.nC} for i in 1:nV};

  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
   TRANSFORM.Fluid.Volumes.SimpleVolume volume[nV](
    redeclare package Medium = Medium,
    p_start=ps_start,
    each use_T_start=use_Ts_start,
    T_start=Ts_start,
    h_start=hs_start,
    X_start=Xs_start,
    C_start=Cs_start,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=Vs),
    mC_gen=mC_gens)
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance[nV](
    redeclare package Medium = Medium,
    R=R) annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));

  /* Initialization Tab*/
  parameter SI.AbsolutePressure[nV] ps_start=linspace_1D(
        p_a_start,
        p_b_start,nV)
    "Pressure" annotation (Dialog(tab="Initialization", group=
          "Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_a_start = Medium.p_default "Pressure at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start=p_a_start "Pressure at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));

  parameter Boolean use_Ts_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization", group=
          "Start Value: Temperature"));
  parameter SI.Temperature Ts_start[nV]=linspace_1D(
        T_a_start,
        T_b_start,nV)
    "Temperature" annotation (Evaluate=true, Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.SpecificEnthalpy[nV] hs_start=if not use_Ts_start then linspace_1D(
        h_a_start,
        h_b_start,nV)
             else {Medium.specificEnthalpy_pTX(
        ps_start[i],
        Ts_start[i],
        Xs_start[i, 1:Medium.nX]) for i in 1:nV} "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.Temperature T_a_start=Medium.T_default "Temperature at port a" annotation (
      Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.Temperature T_b_start=T_a_start "Temperature at port b" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.SpecificEnthalpy h_a_start=Medium.specificEnthalpy_pTX(
      p_a_start,
      T_a_start,
      X_a_start) "Specific enthalpy at port a" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.SpecificEnthalpy h_b_start=Medium.specificEnthalpy_pTX(
      p_b_start,
      T_b_start,
      X_b_start) "Specific enthalpy at port b" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));

  parameter SI.MassFraction Xs_start[nV,Medium.nX]=linspaceRepeat_1D(
        X_a_start,
        X_b_start,nV) "Mass fraction" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SI.MassFraction X_a_start[Medium.nX]=Medium.X_default
    "Mass fraction at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start[Medium.nX]=X_a_start
    "Mass fraction at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Species Mass Fraction"));

  parameter SIadd.ExtraProperty Cs_start[nV,Medium.nC]=linspaceRepeat_1D(
        C_a_start,
        C_b_start,nV) "Mass-Specific value" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances",
      enable=Medium.nC > 0));
  parameter SIadd.ExtraProperty C_a_start[Medium.nC]=fill(0, Medium.nC)
    "Mass-Specific value at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Trace Substances"));
  parameter SIadd.ExtraProperty C_b_start[Medium.nC]=C_a_start
    "Mass-Specific value at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Trace Substances"));

equation

  connect(port_a, volume[1].port_a);

  for i in 1:nV loop
    connect(volume[i].port_b, resistance[i].port_a);
  end for;

  for i in 1:nV-1 loop
    connect(resistance[i].port_b, volume[i + 1].port_a);
  end for;

  connect(port_b, resistance[nV].port_b);

  annotation (defaultComponentName="decayVolumes",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{20,-45},{60,-60},{20,-75},{20,-45}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-86,32},{-74,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-86,12},{-74,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-66,32},{-54,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-76,22},{-64,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-66,12},{-54,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-46,32},{-34,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-56,22},{-44,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-46,12},{-34,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-26,32},{-14,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-36,22},{-24,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-26,12},{-14,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-6,32},{6,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-16,22},{-4,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-6,12},{6,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{14,32},{26,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{4,22},{16,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{14,12},{26,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{34,32},{46,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{24,22},{36,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{34,12},{46,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{54,32},{66,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{44,22},{56,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{54,12},{66,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{74,32},{86,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{64,22},{76,10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{74,12},{86,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-76,-2},{-64,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-76,-22},{-64,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-56,-2},{-44,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-66,-12},{-54,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-56,-22},{-44,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-36,-2},{-24,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-46,-12},{-34,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-36,-22},{-24,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-16,-2},{-4,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-26,-12},{-14,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-16,-22},{-4,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{4,-2},{16,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-6,-12},{6,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{4,-22},{16,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{24,-2},{36,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{14,-12},{26,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{24,-22},{36,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{44,-2},{56,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{34,-12},{46,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{44,-22},{56,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{64,-2},{76,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{54,-12},{66,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{64,-22},{76,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{74,-12},{86,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Ellipse(
          extent={{-86,-12},{-74,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={203,203,203}),
        Rectangle(
          extent={{-88,40},{-90,-40}},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{90,40},{88,-40}},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{55,-60},{-60,-60}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DecayBed_Simple;
