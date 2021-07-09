within TRANSFORM.Fluid.TraceComponents;
model TraceDecayAdsorberBed_sparseMatrix
  "Switch from parents to sparseMatrix data approach (i.e., l_lambdas)"
extends TRANSFORM.Icons.UnderConstruction;
  import TRANSFORM.Units.Conversions.Functions.Time_s.from_hr;
  import TRANSFORM.Math.linspace_1D;
  import Modelica.Fluid.Types.Dynamics;
  Interfaces.FluidPort_Flow  port_a(redeclare package Medium = Medium,
  m_flow(min=0))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium,
  m_flow(max=0))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.He (
        extraPropertiesNames=cat(1,data_PG.extraPropertiesNames,data_ISO.extraPropertiesNames)) constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium properties" annotation (
      choicesAllMatching=true);
  parameter Integer nV=1 "# of volumes";

  input SI.SpecificVolume K[Medium.nC]=fill(1e3, Medium.nC)
    "Dynamic adsorption coefficient"
    annotation (Dialog(group="Inputs"));
  input SI.Energy Qs_decay[Medium.nC]=fill(0, Medium.nC)
    "Energy released per decay" annotation (Dialog(group="Inputs"));
  parameter Boolean use_tau=true
    "=true to specify reference resident time else based on carbon mass";
  parameter Integer iC=1
    "Index of substance for basis of residence time (tau_res)"
    annotation (Dialog(enable=use_tau));
  input SI.Time tau_res=from_hr(1)
    "Specified residence time for chosen substance (iC) or mass of carbon"
    annotation (Dialog(group="Inputs", enable=use_tau));
  input SI.Mass mAdsorber=V_flow*tau_res/K[iC] "Specify total mass of adsorber"
    annotation (Dialog(group="Inputs", enable=not use_tau));
  input Units.HydraulicResistance R = 1 "Hydraulic resistance across adsorber bed" annotation(Dialog(group="Inputs"));

//   input SI.PressureDifference dp=1
//     "Pressure drop across adsorber bed (dp = port_a.p - port_b.p)"
//     annotation (Dialog(group="Inputs"));
  input SI.Density d_adsorber=500 "Density of adsorber bed"
    annotation (Dialog(group="Inputs"));
  input SI.SpecificHeatCapacity cp_adsorber=1000
    "Specific heat capacity of adsorber bed"
    annotation (Dialog(group="Inputs"));
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
//   parameter Dynamics traceDynamics=energyDynamics
//     "Formulation of trace substance balances"
//     annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter SI.Temperature Ts_start[nV]=linspace_1D(
      T_a_start,
      T_b_start,
      nV) "Temperature"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_a_start=Medium.T_default "Temperature at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_b_start=T_a_start "Temperature at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  SIadd.ExtraPropertyFlowRate mC_flows[nV + 1,Medium.nC]
    "Trace substance flow rate between volumes";
  SIadd.ExtraPropertyFlowRate mCs_decay[nV,Medium.nC]
    "Amount of substance decayed across each volume";
  SI.HeatFlowRate Qs_perC[nV,Medium.nC]
    "Heat released from decay per volume per substance";
  SI.HeatFlowRate Qs[nV] "Heat released from decay per volume";
  SI.PressureDifference dp "Pressure drop across adsorber bed (dp = port_a.p - port_b.p)";
  Medium.ThermodynamicState state_a "Thermodynamic state at port_a";
  Medium.ThermodynamicState state_b "Thermodynamic state at port_b";
  SI.MassFlowRate m_flow=port_a.m_flow "Mass flow rate of carrier fluid";
  SI.VolumeFlowRate V_flow=m_flow/Medium.density(state_a);
  SI.Time taus[Medium.nC]=K .* mAdsorber ./ V_flow;
  SI.Temperature Ts_adsorber[nV](start=Ts_start) "Temperature of adsorber";
  SI.EnthalpyFlowRate H_flows[nV + 1]
    "Enthalpy flow rate across volumes due to fluid flow";
  SI.Pressure ps[nV] "Pressure of volumes";
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  parameter Boolean use_HeatPort = false "=true to toggle heat port" annotation(Dialog(tab="Advanced"),Evaluate=true);
  HeatAndMassTransfer.Interfaces.HeatPort_State[nV] heatPorts(T=Ts_adsorber, Q_flow=
        Q_flows_internal) if use_HeatPort
    annotation (Placement(transformation(extent={{-10,50},{10,70}}),
        iconTransformation(extent={{-10,40},{10,60}})));
  //SIadd.ExtraPropertyExtrinsic mCs[nV,Medium.nC] "Trace substance extrinsic value";

  replaceable record Data_PG =
      TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_TRACEdefault
    constrainedby TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.PartialPrecursorGroup
    "Data" annotation (choicesAllMatching=true);
  Data_PG data_PG;

  replaceable record Data_ISO =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_null
    constrainedby TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.PartialIsotopes
    "Data" annotation (choicesAllMatching=true);
  Data_ISO data_ISO;

   SIadd.ExtraPropertyFlowRate mC_gens[nV,Medium.nC]
     "Generation rate of isotopes [atoms/s]";

  final parameter Integer l_lambdas_count_sum[data_ISO.nC]={sum(data_ISO.l_lambdas_count[1:j - 1])
      for j in 1:data_ISO.nC} annotation (Evaluate=true);

   Real thalf[data_PG.nC] = log(2)./data_PG.lambdas;//, log(2)./min(data_ISO.lambdas);
protected
  SI.HeatFlowRate[nV] Q_flows_internal;

initial equation
  // Energy Balance
  if energyDynamics == Dynamics.FixedInitial then
    Ts_adsorber = Ts_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    der(Ts_adsorber)=zeros(nV);
  end if;
equation
  if not use_HeatPort then
    Q_flows_internal = zeros(nV);
  end if;
  //Cout = Cin.*exp(-lambdas.*mCarbon.*K./V_flow); //Basic equation
  mC_flows[1, :] = m_flow*actualStream(port_a.C_outflow);

  for i in 2:nV + 1 loop

    for j in 1:data_PG.nC loop
    mC_flows[i, j] = mC_flows[i - 1, j] .* exp(-data_PG.lambdas[j]*tau_res/nV) + mC_gens[i-1,j];
    end for;

    for j in 1:data_ISO.nC loop
      mC_flows[i, j+data_PG.nC] = mC_flows[i - 1, j+data_PG.nC] .* exp(-data_ISO.lambdas[j]*tau_res/nV) + mC_gens[i-1,j+data_PG.nC];// sum(mCs_decay[i-1,:].*parents[j,:]);
    end for;

  end for;

///

   for i in 1:nV loop
      for j in 1:data_PG.nC loop
        mC_gens[i, j] = sum(mCs_decay[i,1:data_PG.nC].*data_PG.parents[j,:]);
      end for;

     for j in 1:data_ISO.nC loop
           mC_gens[i, j+data_PG.nC] = sum({data_ISO.l_lambdas[l_lambdas_count_sum[j] + k]*mCs_decay[i,
             data_ISO.l_lambdas_col[l_lambdas_count_sum[j] + k]] for k in 1:data_ISO.l_lambdas_count[j]});// - lambdas[j]*mCs[i, j];
     end for;
   end for;

///

  for i in 1:nV loop
    //der(mCs[i,:]) = mCs_decay[i, :]; to get accumulation of products use this with factor to who being born
    mCs_decay[i, :] = mC_flows[i, :] - mC_flows[i + 1, :];
    Qs_perC[i, :] = mCs_decay[i, :] .* Qs_decay;
    Qs[i] = sum(Qs_perC[i, :]);
  end for;
  ps = {port_a.p - (i-0.5)*dp/nV for i in 1:nV};
  H_flows[1] = semiLinear(
    port_a.m_flow,
    inStream(port_a.h_outflow),
    Medium.specificEnthalpy_pT(ps[1], Ts_adsorber[1]));
  for i in 2:nV loop
    H_flows[i] = semiLinear(
      m_flow,
      Medium.specificEnthalpy_pT(ps[i - 1], Ts_adsorber[i - 1]),
      Medium.specificEnthalpy_pT(ps[i], Ts_adsorber[i]));
  end for;
  H_flows[nV + 1] = -semiLinear(
    port_b.m_flow,
    inStream(port_b.h_outflow),
    Medium.specificEnthalpy_pT(ps[nV], Ts_adsorber[nV]));
  // Energy Balance
  if energyDynamics == Dynamics.SteadyState then
    for i in 1:nV loop
      0 = H_flows[i] - H_flows[i + 1] + Qs[i];
    end for;
  else
    for i in 1:nV loop
      mAdsorber/nV*cp_adsorber*der(Ts_adsorber[i]) = H_flows[i] - H_flows[i + 1] +
      Qs[i] + Q_flows_internal[i];
    end for;
  end if;
  port_a.m_flow*R = dp;
  port_a.m_flow + port_b.m_flow = 0;
  port_b.p = port_a.p - dp;
  state_a = Medium.setState_phX(
    port_a.p,
    inStream(port_a.h_outflow),
    inStream(port_a.Xi_outflow));
  state_b = Medium.setState_phX(
    port_b.p,
    inStream(port_b.h_outflow),
    inStream(port_b.Xi_outflow));
  // Stream variables balance
  port_a.h_outflow = Medium.specificEnthalpy_pT(port_a.p, Ts_adsorber[1]);
  port_b.h_outflow = Medium.specificEnthalpy_pT(port_b.p, Ts_adsorber[nV]);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = mC_flows[1, :] ./ m_flow;
  port_b.C_outflow = mC_flows[nV + 1, :] ./ m_flow;
  annotation (
    defaultComponentName="adsorberBed",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          visible=DynamicSelect(true,showDesignFlowDirection)),
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
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TraceDecayAdsorberBed_sparseMatrix;
