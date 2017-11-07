within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
partial model PartialPump

  import Modelica.Fluid.Types.Dynamics;
  import Modelica.Media.Interfaces.Choices.IndependentVariables;

  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);

  parameter Boolean use_EfficiencyChar = true
      "=true then use efficiency characteristic else power"
     annotation(Evaluate=true,Dialog(group="Characteristics: Based on single pump nominal conditions"));

//   replaceable function efficiencyCharacteristic =
//     Modelon.ThermoFluid.Pumps.PumpCharacteristics.constantEfficiency (  eta_nom=
//          0.8) constrainedby
//     Modelon.ThermoFluid.Pumps.PumpCharacteristics.Interfaces.baseEfficiency
//     "Efficiency vs. q_flow at nominal speed and density" annotation (Dialog(
//         group="Nominal pump characteristic", enable=use_EfficiencyChar),
//       choicesAllMatching=true);

  replaceable model EfficiencyChar =
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant
  constrainedby
    TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency.PartialEfficiencyChar
      "Efficiency vs. Volumetric flow rate"
    annotation(Dialog(group="Characteristics: Based on single pump nominal conditions",enable= use_EfficiencyChar), choicesAllMatching=true);

  EfficiencyChar efficiencyChar(
    redeclare final package Medium = Medium,
    final state=state_a,
    final V_flow_start=m_flow_start/d_start,
    final V_flow=m_flow/d,
    final V_flow_nominal=m_flow_nominal/d_nominal,
    final N=N,
    final diameter=diameter,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

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
  parameter SI.VolumeFlowRate V_flow_curve[:]={0.0,0.001,0.0015}
    "Volume flow rate for given operating points (single pump)"
    annotation (Dialog(group="Nominal pump characteristic"));

  parameter SI.Height head_curve[size(V_flow_curve, 1)]={60,30,0}
    "Pump head for given operating points"
    annotation (Dialog(group="Nominal pump characteristic"));
  parameter SI.Power W_curve[size(V_flow_curve, 1)]={800,1800,2000}
    "Power consumption for given operating points (single pump)" annotation (
      Dialog(enable=not use_EfficiencyChar, group="Nominal pump characteristic"));
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
  Real eta "Global Efficiency";

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

protected
  parameter Real k_inertia=V_flow_curve[2]/head_curve[2];
  Boolean FlowOn(start=true);
  Real ABC[3]=Modelica.Math.Matrices.leastSquares([{V_flow_curve[i]^2 for i in 1:size(V_flow_curve, 1)},
      V_flow_curve,ones(size(V_flow_curve, 1), 1)], head_curve);
  Real DEF[3]=if not use_EfficiencyChar then Modelica.Math.Matrices.leastSquares([N_nominal*N_nominal*
      V_flow_curve,N_nominal*{V_flow_curve[i]^2 for i in 1:size(V_flow_curve, 1)},
      N_nominal*N_nominal*ones(size(V_flow_curve, 1), 1)], W_curve) else {0,0,0};

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
  head=dp/(d*g_n);
  assert(size(V_flow_curve, 1) > 2, "Minimum three pump operating points are required.");

  port_a.m_flow + port_b.m_flow = 0;
  m_flow =port_a.m_flow/nParallel;
  V_flow = port_a.m_flow/d/nParallel;
  FlowOn =m_flow > 0.0 or port_a.p - port_b.p + dp > 0;

  der(m_flow) =if (FlowOn) then (port_a.p - port_b.p + dp)*k_inertia/T_inertia
     else 0.0;

       //affinityLaw_dp = dp_nominal*(N/N_nominal)^2*(diameter/diameter_nominal)^2;
  dp =(ABC[1]*V_flow*V_flow + ABC[2]*(N/N_nominal)*V_flow + ABC[3]*(N*
    N/(N_nominal*N_nominal)))*d*g_n;

  d = Medium.density(state_a);
  T = Medium.temperature(state_a);

  d*V*der(h) = port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*
    actualStream(port_b.h_outflow) + nParallel*W_hyd;

  if not use_EfficiencyChar then
    W = DEF[1]*(N*N)*(m_flow/d) + DEF[2]*N*((m_flow*m_flow/(d*d))) + DEF[3]*(N*
      N);
    eta =((port_b.p - port_a.p)*m_flow/d)/(W + W_eps);
  else
    eta =efficiencyChar.eta;
    W = (port_b.p - port_a.p)*V_flow/eta;

  end if;
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
end PartialPump;
