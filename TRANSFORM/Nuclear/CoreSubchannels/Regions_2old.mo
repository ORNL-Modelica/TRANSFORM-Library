within TRANSFORM.Nuclear.CoreSubchannels;
model Regions_2old
  "0-D point kinetics fuel channel model with two solid media regions"

  extends TRANSFORM.Icons.ObsoleteModel;

  import TRANSFORM.Math.linspace_1D;
  import TRANSFORM.Math.linspaceRepeat_1D;
  import Modelica.Fluid.Types.ModelStructure;
  import TRANSFORM.Fluid.Types.LumpedLocation;
  import Modelica.Fluid.Types.Dynamics;

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium,m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0)) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,
            10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow    port_b(redeclare package Medium
      =                                                                          Medium,m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0)) annotation (
      Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
            {110,10}})));

  parameter Real nParallel=1 "Number of identical parallel coolant channels";

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Coolant medium" annotation (choicesAllMatching=true);

  replaceable model Geometry =
      ClosureRelations.Geometry.Models.CoreSubchannels.Generic
    constrainedby ClosureRelations.Geometry.Models.CoreSubchannels.Generic
    "Geometry" annotation (Dialog(group="Geometry"),choicesAllMatching=true);

  Geometry geometry(final nRegions=2)
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

  replaceable model FlowModel =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
    "Coolant flow models (i.e., momentum, pressure loss, wall friction)"
    annotation (choicesAllMatching=true, Dialog(group="Pressure Loss"));

  replaceable model HeatTransfer =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.PartialHeatTransfer_setT
    "Coolant coefficient of heat transfer" annotation (choicesAllMatching=true,
      Dialog(group="Heat Transfer"));

  /* Kinetics */
  parameter Integer nI=6
    "Number of groups of the delayed-neutron precursors groups" annotation (
      Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter Units.NonDim beta_i[nI]={0.000169,0.000832,0.00264,0.00122,
      0.00138,0.000247} "Delayed neutron precursor fractions"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter Units.InverseTime lambda_i[nI]={3.87,1.40,0.311,0.115,0.0317,
      0.0127} "Decay constants for each precursor group"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter SI.Time Lambda=1e-5 "Prompt neutron generation time"
                                     annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter Units.TempFeedbackCoeff alpha_fuel=-2.5e-5
    "Doppler feedback coefficient"
    annotation (Dialog(tab="Kinetics", group="Reactivity Feedback Parameters"));
  parameter Units.TempFeedbackCoeff alpha_coolant=-20e-5
    "Moderator feedback coefficient"
    annotation (Dialog(tab="Kinetics", group="Reactivity Feedback Parameters"));
  parameter SI.Temperature Teffref_fuel "Fuel reference temperature"
                                 annotation (Dialog(tab="Kinetics", group="Reactivity Feedback Parameters"));
  parameter SI.Temperature Teffref_coolant "Coolant reference temperature"
                                    annotation (Dialog(tab="Kinetics", group="Reactivity Feedback Parameters"));

  input Real CR_reactivity = 0.0 "Control rod reactivity" annotation (Dialog(tab="Kinetics", group="Inputs"));
  input Real Other_reactivity = 0.0 "Additional non-classified reactivity" annotation (Dialog(tab="Kinetics", group="Inputs"));
  input SI.Power S_external = 0.0 "External heat source" annotation (Dialog(tab="Kinetics", group="Inputs"));

  replaceable package Material_1 =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
      annotation (__Dymola_choicesAllMatching=true);
  replaceable package Material_2 =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    annotation (__Dymola_choicesAllMatching=true);

  parameter Boolean use_DecayHeat=false
    "Include decay heat in power calculation" annotation(Dialog(group="Nominal Parameters"));
  parameter SI.Time T_op=360*24*3600 "Time since reactor startup"
    annotation (Dialog(group="Nominal Parameters", enable = use_DecayHeat));
  parameter SI.Power Q_nominal=1000e6 "Nominal thermal power rating (W)"
    annotation (Dialog(group="Nominal Parameters"));
  parameter Units.NonDim[geometry.nV] Q_shape=1/geometry.nV*ones(geometry.nV)
    "Per Node Fractional Power Profile. (i.e., sum(Power_shape) = 1"
    annotation (Dialog(group="Nominal Parameters"));

  parameter SI.Power[nI] C_i_start = {beta_i[i]/(lambda_i[i]*Lambda)*Q_nominal for i in 1:nI}
    "Delayed-neutron precursor concentrations power"
    annotation(Dialog(tab="Fuel Element Initialization",group="Start Value: Neutron Precursors"));

  parameter SI.Temperature T_start_1=Material_1.T_default
    annotation (Dialog(tab="Fuel Element Initialization",group="Reference Temperatures for Start Values"));
  parameter SI.Temperature T_start_2=Material_2.T_default
    annotation (Dialog(tab="Fuel Element Initialization",group="Reference Temperatures for Start Values"));

  parameter SI.Temperature Ts_start_1[geometry.nRs[1],geometry.nV]=fill(
      T_start_1,
      geometry.nRs[1],
      geometry.nV) "Fuel temperatures"     annotation (Dialog(tab="Fuel Element Initialization",
        group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start_2[geometry.nRs[2],geometry.nV]=[{
      Ts_start_1[end, :]}; fill(
      T_start_2,
      geometry.nRs[2] - 1,
      geometry.nV)] "Cladding temperatures" annotation (Dialog(tab="Fuel Element Initialization",
        group="Start Value: Temperature"));

      // Coolant Initialization
  parameter SI.AbsolutePressure[geometry.nV] ps_start=linspace_1D(
      p_a_start,
      p_b_start,
      geometry.nV) "Pressure" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_a_start=Medium.p_default
    "Pressure at port a" annotation (Dialog(tab="Coolant Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start=p_a_start + (if m_flow_a_start > 0 then -1e3 elseif m_flow_a_start < 0 then -1e3 else 0)
    "Pressure at port b" annotation (Dialog(tab="Coolant Initialization", group="Start Value: Absolute Pressure"));

  parameter Boolean use_Ts_start=true
    "Use T_start if true, otherwise h_start" annotation (Evaluate=true, Dialog(
        tab="Coolant Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start[geometry.nV]=linspace_1D(
      T_a_start,
      T_b_start,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Coolant Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.Temperature T_a_start=Medium.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.Temperature T_b_start=T_a_start
    "Temperature at port b" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));

  parameter SI.SpecificEnthalpy[geometry.nV] hs_start=if not
      use_Ts_start then linspace_1D(
      h_a_start,
      h_b_start,
      geometry.nV) else {Medium.specificEnthalpy_pTX(
      ps_start[i],
      Ts_start[i],
      Xs_start[i, 1:Medium.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.SpecificEnthalpy h_a_start=Medium.specificEnthalpy_pTX(
      p_a_start,
      T_a_start,
      X_a_start) "Specific enthalpy at port a" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.SpecificEnthalpy h_b_start=Medium.specificEnthalpy_pTX(
      p_b_start,
      T_b_start,
      X_b_start) "Specific enthalpy at port b" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));

  parameter SI.MassFraction Xs_start[geometry.nV,Medium.nX]=
      linspaceRepeat_1D(
      X_a_start,
      X_b_start,
      geometry.nV) "Mass fraction" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SI.MassFraction X_a_start[Medium.nX]=Medium.X_default
    "Mass fraction at port a" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start[Medium.nX]=X_a_start
    "Mass fraction at port b" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Species Mass Fraction"));

  parameter SI.MassFraction Cs_start[geometry.nV,Medium.nC]=
      linspaceRepeat_1D(
      C_a_start,
      C_b_start,
      geometry.nV) "Mass fraction" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Trace Substances Mass Fraction",
      enable=Medium.nC > 0));
  parameter SI.MassFraction C_a_start[Medium.nC]=fill(0, Medium.nC)
    "Mass fraction at port a" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Trace Substances Mass Fraction"));
  parameter SI.MassFraction C_b_start[Medium.nC]=C_a_start
    "Mass fraction at port b" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Trace Substances Mass Fraction"));

  parameter SI.MassFlowRate[geometry.nV + 1] m_flows_start=linspace(
      m_flow_a_start,
      -m_flow_b_start,
      geometry.nV + 1) "Mass flow rates" annotation (Evaluate=true, Dialog(tab="Coolant Initialization",
        group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_a_start=0 "Mass flow rate at port_a"
    annotation (Dialog(tab="Coolant Initialization", group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_b_start=-m_flow_a_start
    "Mass flow rate at port_b" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Mass Flow Rate"));

  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances {coolant}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics energyDynamics_fuel=Dynamics.DynamicFreeInitial
    "Formulation of energy balances {fuel}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics
    "Formulation of mass balances {coolant}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances {coolant}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics momentumDynamics=Dynamics.SteadyState "Formulation of momentum balances {coolant}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Advanced", group="Coolant"));
  parameter Boolean exposeState_a=true
    "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(tab="Advanced", group="Coolant"));
  parameter Boolean exposeState_b=false
    "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(tab="Advanced", group="Coolant"));
  parameter Boolean useLumpedPressure=false
    "=true to lump pressure states together"
    annotation (Dialog(tab="Advanced", group="Coolant"), Evaluate=true);
  parameter LumpedLocation lumpPressureAt=LumpedLocation.port_a
    "Location of pressure for flow calculations" annotation (Dialog(
      tab="Advanced",
      group="Coolant",
      enable=if useLumpedPressure and modelStructure <>
          ModelStructure.av_vb then true else false), Evaluate=true);
  parameter Boolean useInnerPortProperties=false
    "=true to take port properties for flow models from internal control volumes"
    annotation (Dialog(tab="Advanced", group="Coolant"), Evaluate=true);

  // Visualization
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  parameter Boolean showDesignFlowDirection = true annotation(Dialog(tab="Visualization"));

  Modelica.Blocks.Sources.RealExpression T_effective_fuel(y=fuelModel.region_1.solutionMethod.T_effective)
    "Effective fuel temperature"
    annotation (Placement(transformation(extent={{-54,38},{-40,46}})));

  PowerProfiles.GenericPowerProfile powerProfile(nNodes=geometry.nV, Q_shape=
        Q_shape)
    annotation (Placement(transformation(extent={{26,24},{12,38}})));

  ReactorKinetics.PointKinetics reactorKinetics(
    T_op=T_op,
    nI=nI,
    beta_i=beta_i,
    lambda_i=lambda_i,
    Lambda=Lambda,
    alpha_fuel=alpha_fuel,
    alpha_coolant=alpha_coolant,
    Teffref_fuel=Teffref_fuel,
    Teffref_coolant=Teffref_coolant,
    Q_nominal=Q_nominal,
    energyDynamics=energyDynamics,
    C_i_start=C_i_start)
    annotation (Placement(transformation(extent={{-14,43},{14,64}})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface
                                       coolantSubchannel(
    use_HeatTransfer=true,
    redeclare package Medium = Medium,
    p_a_start=p_a_start,
    p_b_start=p_b_start,
    nParallel=nParallel,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    allowFlowReversal=allowFlowReversal,
    redeclare model FlowModel = FlowModel,
    redeclare model HeatTransfer = HeatTransfer,
    useLumpedPressure=useLumpedPressure,
    lumpPressureAt=lumpPressureAt,
    useInnerPortProperties=useInnerPortProperties,
    use_Ts_start=use_Ts_start,
    T_a_start=T_a_start,
    T_b_start=T_b_start,
    Ts_start=Ts_start,
    h_a_start=h_a_start,
    h_b_start=h_b_start,
    hs_start=hs_start,
    ps_start=ps_start,
    Ts_wall(start={{fuelModel.Ts_start_2[end, i] for j in 1:coolantSubchannel.heatTransfer.nSurfaces} for i in 1:coolantSubchannel.nV}),
    Xs_start=Xs_start,
    Cs_start=Cs_start,
    X_a_start=X_a_start,
    X_b_start=X_b_start,
    C_a_start=C_a_start,
    C_b_start=C_b_start,
    m_flow_a_start=m_flow_a_start,
    m_flow_b_start=m_flow_b_start,
    m_flows_start=m_flows_start,
    exposeState_a=exposeState_a,
    exposeState_b=exposeState_b,
    energyDynamics=energyDynamics,
    traceDynamics=traceDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=geometry.nV,
        dimension=geometry.dimension,
        crossArea=geometry.crossArea,
        perimeter=geometry.perimeter,
        length=geometry.length,
        roughness=geometry.roughness,
        surfaceArea=geometry.surfaceArea,
        dheight=geometry.dheight,
        nSurfaces=geometry.nSurfaces,
        height_a=geometry.height_a,
        angle=geometry.angle))               annotation (Placement(
        transformation(
        extent={{-15,-13},{15,13}},
        rotation=0,
        origin={0,-14})));

  FuelModels.Regions_2_FD2DCyl fuelModel(
    energyDynamics=energyDynamics_fuel,
    length=geometry.length,
    nParallel=geometry.nPins*nParallel,
    nZ=geometry.nV,
    T_start_1=T_start_1,
    T_start_2=T_start_2,
    Ts_start_1=Ts_start_1,
    Ts_start_2=Ts_start_2,
    redeclare package Material_1 = Material_1,
    redeclare package Material_2 = Material_2,
    r_1_outer=geometry.rs_outer[1],
    r_2_outer=geometry.rs_outer[2],
    nR_1=geometry.nRs[1],
    nR_2=geometry.nRs[2])                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,10})));

  Modelica.Blocks.Sources.RealExpression T_effective_coolantSubchannel(y=
        coolantSubchannel.summary.T_effective) "Effective coolant temperature"
    annotation (Placement(transformation(extent={{-62,28},{-40,38}})));

  Modelica.Blocks.Sources.RealExpression CR_reactivity_input(y=CR_reactivity)
    annotation (Placement(transformation(extent={{-54,60},{-40,68}})));
  Modelica.Blocks.Sources.RealExpression Other_reactivity_input(y=
        Other_reactivity)
    annotation (Placement(transformation(extent={{-54,54},{-40,62}})));
  Modelica.Blocks.Sources.RealExpression S_external_input(y=S_external)
    annotation (Placement(transformation(extent={{-54,48},{-40,56}})));
equation

  connect(T_effective_fuel.y, reactorKinetics.Teff_fuel_in) annotation (Line(
        points={{-39.3,42},{-30,42},{-30,48.8734},{-12.565,48.8734}}, color={0,0,
          127}));
  connect(powerProfile.Q_totalshaped, fuelModel.Power_in) annotation (Line(
        points={{11.3,31},{2.22045e-015,31},{2.22045e-015,21}}, color={0,0,127}));
  connect(port_a, coolantSubchannel.port_a) annotation (Line(points={{-100,0},{-70,
          0},{-40,0},{-40,-14},{-15,-14}}, color={0,127,255}));
  connect(coolantSubchannel.port_b, port_b) annotation (Line(points={{15,-14},{40,
          -14},{40,0},{100,0}}, color={0,127,255}));
  connect(T_effective_coolantSubchannel.y, reactorKinetics.Teff_coolant_in)
    annotation (Line(points={{-38.9,33},{-24,33},{-24,44.3453},{-12.565,44.3453}},
        color={0,0,127}));
  connect(CR_reactivity_input.y, reactorKinetics.Reactivity_CR_in) annotation (
      Line(points={{-39.3,64},{-26,64},{-26,62.7203},{-12.565,62.7203}}, color={
          0,0,127}));
  connect(Other_reactivity_input.y, reactorKinetics.Reactivity_Other_in)
    annotation (Line(points={{-39.3,58},{-12.565,58},{-12.565,58.1266}}, color={
          0,0,127}));
  connect(S_external_input.y, reactorKinetics.S_external_in) annotation (Line(
        points={{-39.3,52},{-26,52},{-26,53.5328},{-12.565,53.5328}}, color={0,0,
          127}));
  connect(reactorKinetics.Q_total, powerProfile.Q_total) annotation (Line(
        points={{12.565,53.5328},{36,53.5328},{36,31},{27.4,31}}, color={0,0,127}));
  connect(coolantSubchannel.heatPorts[:, 1], fuelModel.heatPorts_b) annotation (
     Line(points={{0,-7.5},{0,-4},{0,-0.2},{0.1,-0.2}}, color={191,0,0}));
  annotation (defaultComponentName="coreSubchannel",
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),        Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={        Ellipse(
          extent={{-92,30},{-108,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a),
        Ellipse(
          extent={{108,30},{92,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b),    Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,24},{100,-24}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-65,5},{-55,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-5,5},{5,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{55,5},{65,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,40},{30,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Line(
          points={{-30,40},{-30,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName)),
        Polygon(
          points={{20,-45},{60,-60},{20,-75},{20,-45}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Polygon(
          points={{20,-50},{50,-60},{20,-70},{20,-50}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Line(
          points={{55,-60},{-60,-60}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=DynamicSelect(true,showDesignFlowDirection))}));
end Regions_2old;
