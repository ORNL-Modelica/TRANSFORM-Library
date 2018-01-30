within TRANSFORM.Fluid.Pipes;
model TraceSeparator

  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.He (
        extraPropertiesNames=fill("dummy",3)) constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium properties" annotation (
      choicesAllMatching=true);

  replaceable package Medium_carrier = Modelica.Media.IdealGases.SingleGases.He
      (extraPropertiesNames=fill("dummy",nC),
  C_nominal=fill(1e6,nC)) constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium properties" annotation (
      choicesAllMatching=true);

  Interfaces.FluidPort_Flow  port_a(redeclare package Medium = Medium,
  m_flow(min=0))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium,
  m_flow(max=0))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Interfaces.FluidPort_Flow port_a_carrier(redeclare package Medium =
        Medium_carrier, m_flow(min=0))
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Interfaces.FluidPort_Flow port_b_carrier(redeclare package Medium =
        Medium_carrier, m_flow(max=0))
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Interfaces.FluidPort_Flow port_sepFluid(redeclare package Medium = Medium,
      m_flow(max=0))
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));

  constant Integer iC[:] = {2,3} "Index array of substances from Medium separated by Medium_carrier";
  constant Integer nC = size(iC,1) "# of trace substances separated";
  parameter SIadd.NonDim[nC] eta = fill(1,nC) "Separation efficiency";
//   parameter Real x_toC[data_traceSubstances.nC] = TRANSFORM.Math.replaceArrayValues(zeros(Medium.nC),iOG,fill(x_pumpBypass,nOG)) "Fraction of each substance removed to off-gas based on PFL flowrate";
//   parameter Real x_toSepFluid[data_traceSubstances.nC] = TRANSFORM.Math.replaceArrayValues(fill(x_pumpBypass,data_traceSubstances.nC),iOG,fill(0,nOG)) "Fraction of each substance removed to drain tank based on PFL flowrate: Substances to off-gas are removed";
  //parameter Boolean bool_toOG[data_traceSubstances.nC] = {if i==iOG[i] then true else false for i in 1:data_traceSubstances.nC} "true is a removed substance false stays in system";

//   SI.MassFlowRate[data_traceSubstances.nC] mC_gen_pumpBowl={-
//       data_traceSubstances.lambdas[j]*pumpBowl_PFL.mC[j]*3 - mC_flows_toOG[j] -
//       mC_flows_toDrainTank[j] + pump_drainTank.port_b.C_outflow[j]*pump_drainTank.port_a.m_flow
//       + mC_flows_fromOG[j]
//       for j in 1:data_traceSubstances.nC};

  // TraceSubstance Calculations: Off-Gas and Drain Tank
  SI.MassFlowRate[nC] mC_flows_toC;// = x_toOG.*abs(port_a.m_flow).*pump_PFL.port_b.C_outflow "Flow rate leaving pump bowlto off-gas(+)";
//   SI.MassFlowRate m_flow_toDrainTank = data_OFFGAS.V_flow_sep_salt_total*Medium_PFL.density_ph(pump_PFL.port_b.p, pump_PFL.port_b.h_outflow) "Mass flow rate of salt to drain tank (+)";
//   SI.MassFlowRate[data_traceSubstances.nC] mC_flows_toDrainTank = x_toDT.*m_flow_toDrainTank.*pump_PFL.port_b.C_outflow "Flow rate leaving pump bowl going to draintank(+)";
//
//
//   SI.MassFlowRate[nOG] mC_gen_drainTank_gas={-data_traceSubstances.lambdas[iOG[j]]*drainTank_gas.mC[j] for j in 1:nOG};
//   SI.MassFlowRate[data_traceSubstances.nC] mC_gen_drainTank_liquid=-data_traceSubstances.lambdas.*drainTank_liquid.mC;
//
//   SI.MassFlowRate[data_traceSubstances.nC] mC_flows_fromOG;// = {mC_flows_fromOG[iOG[i]] for i in 1:nOG}x_toOG.*abs(pump_OffGas_bypass.port_b.m_flow).*pump_OffGas_bypass.port_b.C_outflow "Flow rate leaving pump bowlto off-gas(+)";


equation

  mC_flows_toC = {eta[i]*port_a.m_flow.*actualStream(port_a.C_outflow[iC[i]]) for i in 1:nC};


  port_a.p = port_b.p;
  port_a_carrier.p = port_b_carrier.p;

  port_a.m_flow + port_b.m_flow + port_sepFluid.m_flow = 0;
  port_a_carrier.m_flow + port_b_carrier.m_flow = 0;

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  port_a_carrier.h_outflow = inStream(port_b_carrier.h_outflow);
  port_b_carrier.h_outflow = inStream(port_a_carrier.h_outflow);
  port_a_carrier.Xi_outflow = inStream(port_b_carrier.Xi_outflow);
  port_b_carrier.Xi_outflow = inStream(port_a_carrier.Xi_outflow);
  port_a_carrier.C_outflow = inStream(port_b_carrier.C_outflow);
  port_b_carrier.C_outflow = inStream(port_a_carrier.C_outflow);

  port_sepFluid.p = port_a.p;
  port_sepFluid.h_outflow = port_b.h_outflow;
  port_sepFluid.Xi_outflow = port_b.Xi_outflow;
  port_sepFluid.C_outflow = port_b.C_outflow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TraceSeparator;
