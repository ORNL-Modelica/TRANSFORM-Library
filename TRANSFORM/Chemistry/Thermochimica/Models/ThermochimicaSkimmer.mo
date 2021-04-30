within TRANSFORM.Chemistry.Thermochimica.Models;
model ThermochimicaSkimmer "Off-gas separator based on Thermochimica-derived partial pressures"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);

  Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation (
      Placement(transformation(extent={{-120,-20},{-80,20}}, rotation=0), iconTransformation(extent={
            {-110,-10},{-90,10}})));
  Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)" annotation (
      Placement(transformation(extent={{80,-20},{120,20}}, rotation=0), iconTransformation(extent={{90,
            -10},{110,10}})));

  SI.Temperature T;

  parameter Boolean showName=true annotation (Dialog(tab="Visualization"));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1e-4
    "Regularization for zero flow:|m_flow| < m_flow_small" annotation (Dialog(tab="Advanced"));

  // Species tracked in the salt
  parameter Integer atomicNumbers[Medium.nC]=fill(1,Medium.nC);

  Boolean init;
  constant String filename="/home/max/proj/thermochimica/data/MSAX+CationVacancies.dat";
  constant String phaseNames[:]={"gas_ideal","LIQUsoln"};

  TRANSFORM.Chemistry.Thermochimica.BaseClasses.ThermochimicaOutput thermochimicaOutput=
      TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMolesFluid(
      filename,
      T,
      port_a.p,
      C_input,
      atomicNumbers,
      Medium.extraPropertiesNames,
      phaseNames,
      init) "Thermochimica-derived mole fractions";

  SIadd.ExtraProperty C_input[Medium.nC]={Modelica.Fluid.Utilities.regStep(
      port_a.m_flow,
      port_b.C_outflow[i],
      port_a.C_outflow[i],
      m_flow_small) for i in 1:Medium.nC} "Trace substance mass-specific value";

protected
  Medium.Temperature T_a_inflow "Temperature of inflowing fluid at port_a";
  Medium.Temperature T_b_inflow
    "Temperature of inflowing fluid at port_b or T_a_inflow, if uni-directional flow";
equation
  T_a_inflow = Medium.temperature(Medium.setState_phX(
    port_b.p,
    port_b.h_outflow,
    port_b.Xi_outflow));
  T_b_inflow = Medium.temperature(Medium.setState_phX(
    port_a.p,
    port_a.h_outflow,
    port_a.Xi_outflow));
  T = Modelica.Fluid.Utilities.regStep(
    port_a.m_flow,
    T_a_inflow,
    T_b_inflow,
    m_flow_small);

  if time > 1 then
    init = false;
  else
    init = true;
  end if;

  port_a.m_flow + port_b.m_flow = 0;
  port_a.p = port_b.p;
  port_a.C_outflow = thermochimicaOutput.C;
  port_b.C_outflow = thermochimicaOutput.C;
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end ThermochimicaSkimmer;
