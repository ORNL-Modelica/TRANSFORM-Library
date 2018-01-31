within TRANSFORM.Fluid.Pipes;
model TraceSeparator2

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

//   constant Integer iC[:] = {2,3} "Index array of substances from Medium separated by Medium_carrier";
//   constant Integer nC = size(iC,1) "# of trace substances separated";
  constant Integer iC[:] = {2,3} "Index array of substances from Medium separated by Medium_carrier";
  constant Integer nC = size(iC,1) "# of trace substances separated";

  input SIadd.NonDim[nC] eta = fill(1,nC) "Separation efficiency" annotation(Dialog(group="Input Variables"));
  input SI.MassFlowRate m_flow_sepFluid = 0 "Mass flow rate of fluid removed with carrier fluid" annotation(Dialog(group="Input Variables"));

  SIadd.NonDim[Medium.nC] eta_sep = TRANSFORM.Math.replaceArrayValues(zeros(Medium.nC),iC,eta);
  SIadd.NonDim[Medium.nC] eta_notSep = TRANSFORM.Math.replaceArrayValues(fill(1,Medium.nC),iC,fill(1,nC)-eta);

  SI.MassFlowRate[Medium.nC] mC_flows "Flow rate of substances before separation";
  SI.MassFlowRate[Medium.nC] mC_flows_sep "Flow rate of substances separated";
  SI.MassFlowRate[Medium.nC] mC_flows_notSep "Flow rate of substances not separated";
  SI.MassFraction[Medium.nC] Cs_notSep "Concentration of substances after separation";

equation
  mC_flows = port_a.m_flow * actualStream(port_a.C_outflow);
  mC_flows_sep = eta_sep.*mC_flows;
  mC_flows_notSep = eta_notSep.*mC_flows;

  Cs_notSep = mC_flows_notSep./port_a.m_flow;

  port_a.p = port_b.p;
  //port_sepFluid.p = port_a.p;
  port_a_carrier.p = port_b_carrier.p;

  port_a.m_flow + port_b.m_flow + port_sepFluid.m_flow = 0;
  port_sepFluid.m_flow + m_flow_sepFluid = 0;
  port_a_carrier.m_flow + port_b_carrier.m_flow = 0;

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = Cs_notSep;

  port_a_carrier.h_outflow = inStream(port_b_carrier.h_outflow);
  port_b_carrier.h_outflow = inStream(port_a_carrier.h_outflow);
  port_a_carrier.Xi_outflow = inStream(port_b_carrier.Xi_outflow);
  port_b_carrier.Xi_outflow = inStream(port_a_carrier.Xi_outflow);
  port_a_carrier.C_outflow = inStream(port_b_carrier.C_outflow);
  port_b_carrier.C_outflow = {inStream(port_a_carrier.C_outflow[i]) + mC_flows_sep[iC[i]]/port_a_carrier.m_flow for i in 1:nC};

  port_sepFluid.h_outflow = port_b.h_outflow;
  port_sepFluid.Xi_outflow = port_b.Xi_outflow;
  port_sepFluid.C_outflow = Cs_notSep;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TraceSeparator2;
