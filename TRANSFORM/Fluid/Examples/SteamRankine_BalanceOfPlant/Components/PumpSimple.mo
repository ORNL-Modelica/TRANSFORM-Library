within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
model PumpSimple
  import Modelica.Fluid.Types.Dynamics;
  import Modelica.Media.Interfaces.Choices.IndependentVariables;
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);
  parameter Real eta = 0.8;
  parameter SI.Length diameter=diameter_nominal "Impeller diameter";
  parameter SI.Length diameter_nominal=0.1 "Impeller diameter" annotation (
      Dialog(group="Nominal Conditions for Affinity Laws: Single pump basis"));
  parameter SI.MassFlowRate m_flow_nominal "Mass flow rate" annotation (Dialog(
        group="Nominal Conditions for Affinity Laws: Single pump basis"));
  parameter SI.Volume V "Pump internal volume"
    annotation (Dialog(group="Geometry"));
  parameter SI.MassFlowRate m_flow_start=1
    "Mass flowrate start value (single pump)"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Pressure p_a_start "Inlet Pressure Start Value"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Pressure p_b_start "Outlet Pressure Start Value"
    annotation (Dialog(tab="Initialization"));
  parameter SI.SpecificEnthalpy h_start=1e5 "Fluid Specific Enthalpy Start Value"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Temperature T_start=Medium.temperature_phX(
      p_a_start,
      h_start,
      Medium.X_default) "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_T_start));
        final parameter SI.Density d_start = Medium.density_phX(
        p_b_start,
        h_start,
        Medium.X_default);
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Evaluate=true, Dialog(tab="Initialization", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Initialization", group="Dynamics"));
  parameter SI.Density d_nominal=1000 "Nominal Liquid Density"
    annotation (Dialog(group="Nominal operating point"));
  parameter SI.Conversions.NonSIunits.AngularVelocity_rpm N_nominal=1500
    "Nominal rotational speed"
    annotation (Dialog(group="Nominal operating point"));
  parameter Real etaMech(
    min=0,
    max=1) = 0.98 "Mechanical Efficiency";
  parameter SI.Time T_inertia=5 "Equivalent hydraulic time constant";
  parameter SI.VolumeFlowRate V_flow_nominal;
  parameter Boolean checkValve=true "Reverse flow stopped"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  constant SI.Acceleration g_n=Modelica.Constants.g_n;
  constant SI.Power W_eps=1e-8
    "Small coefficient to avoid numerical singularities";
  constant SI.Conversions.NonSIunits.AngularVelocity_rpm N_eps=1e-8
    "Small coefficient to avoid numerical singularities";
      parameter Real nParallel(min=1) = 1 "Number of pumps in parallel";
        SI.Conversions.NonSIunits.AngularVelocity_rpm N "Shaft r.p.m.";
  SI.MassFlowRate m_flow(start=m_flow_start) "Mass flowrate (single pump)";
  SI.VolumeFlowRate V_flow(start=m_flow_start/d_start) "Volume flow rate (single pump)";
  SI.PressureDifference dp "Pump characteristic pressure difference";
  SI.Height head "Pump head";
  SI.Power W "Power Consumption (single pump)";
  SI.Power W_total "Power Consumption";
  SI.Power W_hyd "Hydraulic power (single pump)";
    Medium.ThermodynamicState state_a=Medium.setState_phX(
      port_a.p,
      inStream(port_a.h_outflow),
      inStream(port_a.Xi_outflow));
        SI.Density d "Liquid density";
  SI.Temperature T "Liquid inlet temperature";
    SI.SpecificEnthalpy h(start=h_start) "Fluid specific enthalpy";
  Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium, p(start=
          p_a_start)) annotation (Placement(transformation(extent={{-110,-10},{-90,
            10}}, rotation=0), iconTransformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium, p(start=
          p_b_start)) annotation (Placement(transformation(extent={{90,-10},{110,
            10}}, rotation=0), iconTransformation(extent={{90,-10},{110,10}})));
  parameter Boolean use_N_input=false
    "Get the rotational speed from the input connector";
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_constant=N_nominal "Constant rotational speed"
    annotation (Dialog(enable=not use_N_input));
  Modelica.Blocks.Interfaces.RealInput N_input(unit="rev/min") if   use_N_input
    "Prescribed rotational speed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
protected
  Modelica.Blocks.Interfaces.RealInput N_internal(unit="rev/min")
    "Needed to connect to conditional connector";
  Boolean FlowOn(start=true);
initial equation
  // Mass Balance
  if massDynamics == Dynamics.FixedInitial then
    // if initialize_p then
    //   medium.p = p_start;
    // end if;
    m_flow = m_flow_start;
  elseif massDynamics == Dynamics.SteadyStateInitial then
    // if initialize_p then
    //   der(medium.p) = 0;
    // end if;
    der(m_flow) = 0;
  end if;
  // Energy Balance
  if energyDynamics == Dynamics.FixedInitial then
    /*
    if use_T_start then
      medium.T = T_start;
    else
      medium.h = h_start;
    end if;
    */
    if Medium.ThermoStates == IndependentVariables.ph or Medium.ThermoStates
         == IndependentVariables.phX then
      h = h_start;
    else
      T = T_start;
    end if;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    /*
    if use_T_start then
      der(medium.T) = 0;
    else
      der(medium.h) = 0;
    end if;
    */
    if Medium.ThermoStates == IndependentVariables.ph or Medium.ThermoStates
         == IndependentVariables.phX then
      der(h) = 0;
    else
      der(T) = 0;
    end if;
  end if;
equation
  connect(N_input, N_internal);
  if not use_N_input then
    N_internal = N_constant;
  end if;
  // Set N with a lower limit to avoid singularities at zero speed
  N = max(N_internal, 1e-3);
  head=dp/(d*g_n);
  port_a.m_flow + port_b.m_flow = 0;
  m_flow =port_a.m_flow/nParallel;
  V_flow = port_a.m_flow/d/nParallel;
  //FlowOn =m_flow > 0.0 or port_a.p - port_b.p + dp > 0;
  FlowOn = N > 0;
//   der(m_flow) =if (FlowOn) then (port_a.p - port_b.p + dp)*k_inertia/T_inertia
//      else 0.0;
  der(m_flow) = if (FlowOn) then (N/N_nominal*V_flow_nominal*d - m_flow)/T_inertia
     else -m_flow/T_inertia;
       //affinityLaw_dp = dp_nominal*(N/N_nominal)^2*(diameter/diameter_nominal)^2;
  dp =port_b.p - port_a.p;
  d = Medium.density(state_a);
  T = Medium.temperature(state_a);
  d*V*der(h) = port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*
    actualStream(port_b.h_outflow) + nParallel*W_hyd;
    W = (port_b.p - port_a.p)*V_flow/eta;
  W_total = W*nParallel;
  W_hyd =W*etaMech;
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  port_a.h_outflow = h;
  port_b.h_outflow = h;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-2,60},{80,0}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-80,30},{-40,-30}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
          Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-20,20},{-20,-22},{30,0},{-20,20}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PumpSimple;
