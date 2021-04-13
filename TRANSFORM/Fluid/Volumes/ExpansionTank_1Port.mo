within TRANSFORM.Fluid.Volumes;
model ExpansionTank_1Port "Expansion tank with cover gas"
   extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluid;
//    package Medium = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (extraPropertiesNames={"CO2"},
//          C_nominal={1.519E-1});
  import Modelica.Fluid.Types.Dynamics;
  parameter SI.Area A "Cross-sectional area";
  parameter SI.Volume V0=0 "Volume at zero level";
  input SI.Pressure p_surface=p_start "Liquid surface/gas pressure" annotation(Dialog(group="Inputs"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction"
    annotation (Dialog(tab="Advanced"));
  parameter SI.Pressure p_start = 1e5 annotation(Dialog(tab="Initialization"));
  parameter SI.Length level_start "Start level"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean use_T_start=false annotation (Dialog(tab="Initialization"));
  parameter SI.Temperature T_start=293.15
    annotation (Dialog(tab="Initialization",enable=use_T_start));
  parameter SI.SpecificEnthalpy h_start=1e5
    annotation (Dialog(tab="Initialization",enable=not use_T_start));
  parameter Dynamics massDynamics=Dynamics.DynamicFreeInitial
    "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
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
  constant Real g_n=Modelica.Constants.g_n;
  Medium.ThermodynamicState state_liquid "Thermodynamic state of the liquid";
  SI.Length level(start=level_start, stateSelect=StateSelect.prefer)
    "Liquid level";
  SI.Volume V "Liquid volume";
  SI.Mass m "Liquid mass";
  SI.InternalEnergy U "Liquid internal energy";
  Medium.SpecificEnthalpy h(start=if use_T_start then Medium.specificEnthalpy_pTX(p_start,T_start,X_start) else h_start, stateSelect=StateSelect.prefer)
    "Liquid specific enthalpy";
  Medium.AbsolutePressure p(start=p_start) "Bottom pressure";
  SI.Mass mXi[Medium.nXi] "Species mass";
  SIadd.ExtraPropertyExtrinsic mC[Medium.nC] "Trace substance extrinsic value";
  SI.MassFraction Xi[Medium.nXi](start=Medium.reference_X[1:Medium.nXi])
    "Structurally independent mass fractions";
  SIadd.ExtraProperty C[Medium.nC](stateSelect=StateSelect.prefer, start=C_start)
    "Trace substance mass-specific value";
  // Species Balance
  SI.MassFlowRate mXib[Medium.nXi]
    "Species mass flow rates source/sinks within volumes";
  // Trace Balance
  SIadd.ExtraPropertyFlowRate mCb[Medium.nC]
    "Trace flow rate source/sinks within volumes (e.g., chemical reactions, external convection)";
  TRANSFORM.Fluid.Interfaces.FluidPort_State port(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=h_start),
    p(start=Medium.density(Medium.setState_phX(
          p_start,
          h_start,
          X_start))*g_n*level_start + p_start))
    "Fluid connector a (positive design flow direction is into port)"
    annotation (Placement(transformation(extent={{-20,-100},{20,-60}}, rotation=
           0), iconTransformation(extent={{-10,-94},{10,-74}})));
  parameter Boolean use_HeatPort = false "=true to toggle heat port" annotation(Dialog(tab="Advanced",group="Heat Transfer"),Evaluate=true);
  input SI.HeatFlowRate Q_gen=0 "Internal heat generation" annotation(Dialog(tab="Advanced",group="Heat Transfer"));
  parameter Boolean use_TraceMassPort = false "=true to toggle trace mass port" annotation(Dialog(tab="Advanced",group="Trace Mass Transfer"),Evaluate=true);
  parameter Real MMs[Medium.nC]=fill(1, Medium.nC)
    "Conversion from fluid mass-specific value to moles (e.g., molar mass [kg/mol] or Avogadro's number [atoms/mol])"
    annotation (Dialog(tab="Advanced",group="Trace Mass Transfer", enable=use_TraceMassPort));
  input SIadd.ExtraPropertyFlowRate mC_gen[Medium.nC]=fill(0,Medium.nC) "Internal trace mass generation"
    annotation (Dialog(tab="Advanced",group="Trace Mass Transfer"));
  HeatAndMassTransfer.Interfaces.HeatPort_State heatPort(T=Medium.temperature(state_liquid), Q_flow=
        Q_flow_internal) if                                                                      use_HeatPort
    annotation (Placement(transformation(extent={{74,-10},{94,10}}),
        iconTransformation(extent={{74,-10},{94,10}})));
  HeatAndMassTransfer.Interfaces.MolePort_State traceMassPort(
    nC=Medium.nC,
    C=Cmolar_interface_gas,
    n_flow=mC_flow_internal ./ MMs) if                                                                                            use_TraceMassPort
    annotation (Placement(transformation(extent={{50,-70},{70,-50}}),
        iconTransformation(extent={{50,-68},{70,-48}})));
  // Visualization
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  parameter SI.Length dheight = 0 "Elevation change in addition to liquid level (e.g., pipe connected to port)";


  // Species tracked in the gas
  constant String extraPropertiesNames_gas[:]={"Li","LiF","Na","NaF","F2Na2","F3Na3","K","KF","K2F2","Cs"};
  constant Integer nC_gas=size(extraPropertiesNames_gas, 1) "Number of species";
  constant Integer speciesIndex[nC_gas]={1,2,3,4,5,6,7,8,9,10};
  // Species tracked in the salt
  constant String extraPropertiesNames_salt[:]={"Li","F","Na","K","Cs"};
  constant Integer nC_salt=size(extraPropertiesNames_salt, 1) "Number of species";
  constant Integer atomicNumbers[nC_salt]={3,9,11,19,55};

  // Method to relate gas species to salt species
  constant Real relationMatrix[nC_salt,nC_gas]=
  {
  {1,1,0,0,0,0,0,0,0,0},
  {0,1,0,1,2,3,0,1,2,0},
  {0,0,1,1,2,3,0,0,0,0},
  {0,0,0,0,0,0,1,1,2,0},
  {0,0,0,0,0,0,0,0,0,1}}
    "Element (row) to species (column) molar relation matrix";
  parameter Real partialPressureThermochimica_start[nC_gas] = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMoleFraction(T_start,p_start/1e5,C_start,atomicNumbers,speciesIndex) "Thermochimica-derived initial partial pressures";
  Real partialPressureThermochimica[nC_gas] = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMoleFraction(Medium.temperature(state_liquid),Medium.pressure(state_liquid)/1e5,C,atomicNumbers,speciesIndex) "Thermochimica-derived initial partial pressures";
  parameter SI.Concentration Cmolar_start_interface_gas[nC_salt]={p_start*
      sum(TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_atm(
      partialPressureThermochimica_start[:].*relationMatrix[i,:]))/(Modelica.Constants.R*T_start)
      for i in 1:nC_salt};
  SI.Concentration Cmolar_interface_gas[nC_salt](start=Cmolar_start_interface_gas)=
       {Medium.pressure(state_liquid)*
    sum(TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_atm(partialPressureThermochimica[
    :].*relationMatrix[i,:]))/(Modelica.Constants.R*Medium.temperature(state_liquid)) for i in 1:nC_salt};
  Real F_surplus = (2*C[2] - sum(C))/C[2];
  Real mc_der[nC_salt];
protected
  SI.HeatFlowRate Q_flow_internal;
  SIadd.ExtraPropertyFlowRate mC_flow_internal[Medium.nC];
initial equation
  if massDynamics == Dynamics.FixedInitial then
    if use_T_start then
      h = Medium.specificEnthalpy_pTX(
        p_start,
        T_start,
        X_start);
    else
      h = h_start;
    end if;
    level = level_start;
    Xi = X_start[1:Medium.nXi];
  elseif massDynamics == Dynamics.SteadyStateInitial then
    der(h) = 0;
    der(level) = 0;
    der(Xi) = zeros(Medium.nXi);
  end if;
  // Trace Balance
  if traceDynamics == Dynamics.FixedInitial then
    C = C_start;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mC) = zeros(Medium.nC);
  end if;
equation
  if not use_HeatPort then
    Q_flow_internal = 0;
  end if;
  if not use_TraceMassPort then
    mC_flow_internal = zeros(Medium.nC);
  end if;
  // Set liquid properties
  state_liquid = Medium.setState_phX(p_surface, h);
  V = V0 + A*level;
  m = V*Medium.density(state_liquid);
  U = m*Medium.specificInternalEnergy(state_liquid);
  p - p_surface = Medium.density(state_liquid)*g_n*level;
  mC = MMs.*C;
  if massDynamics == Dynamics.SteadyState then
    der(m) = 0;
    der(U) = 0;
  else
    der(m) =port.m_flow;
    der(U) =port.m_flow*actualStream(port.h_outflow) + Q_flow_internal + Q_gen;
  end if;
  // Species Balance
  if massDynamics == Dynamics.SteadyState then
    zeros(Medium.nXi) = mXib;
  else
    der(mXi) = mXib;
  end if;
  // Trace Balance
  if traceDynamics == Dynamics.SteadyState then
    zeros(Medium.nC) = mCb;
  else
    der(mC) = mCb;
  end if;
  for i in 1:Medium.nXi loop
    mXib[i] =port.m_flow*actualStream(port.Xi_outflow[i]);
  end for;
  when {F_surplus<0.001,F_surplus>-0.001} then
          for i in 1:Medium.nC loop
            mc_der[i] = port.m_flow*actualStream(port.C_outflow[i]) + mC_gen[i] + mC_flow_internal[i];
          end for;
        end when;
        if F_surplus<0.001 and F_surplus>-0.001 then
          for i in 1:Medium.nC loop
            mCb[i] = mc_der[i];
          end for;
        else
          for i in 1:Medium.nC loop
            mCb[i] = port.m_flow*actualStream(port.C_outflow[i]) + mC_gen[i] + mC_flow_internal[i];
          end for;
        end if;
  port.h_outflow = h;
  port.p = p + Medium.density(state_liquid)*g_n*dheight;
  for i in 1:Medium.nXi loop
    port.Xi_outflow[i] = Xi[i];
  end for;
  for i in 1:Medium.nC loop
    port.C_outflow[i] = C[i];
  end for;
  annotation (defaultComponentName="tank",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-85,85},{85,-85}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-85,-85},{85,85}},
          pattern=LinePattern.None,
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Sphere,
          startAngle=0,
          endAngle=180),
        Text(
          extent={{-151,134},{149,94}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),
                                     Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}})));
end ExpansionTank_1Port;
