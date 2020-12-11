within TRANSFORM.Fluid.TraceComponents;
model SimpleSeparator
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium properties" annotation (
      choicesAllMatching=true);

  Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium, m_flow(
        min=0))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium, m_flow(
        max=0))
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));

  input SIadd.NonDim[Medium.nC] eta=fill(0, Medium.nC) "Separation efficiency"
    annotation (Dialog(group="Inputs"));

  SIadd.ExtraPropertyFlowRate[Medium.nC] mC_flows
    "Flow rate of substances before separation";
  SIadd.ExtraPropertyFlowRate[Medium.nC] mC_flows_sep "Flow rate of substances separated";
   SIadd.ExtraPropertyFlowRate[Medium.nC] mC_flows_notSep
     "Flow rate of substances not separated";
  SIadd.ExtraProperty[Medium.nC] Cs_notSep
     "Concentration of substances after separation";
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

equation
  mC_flows = port_a.m_flow*actualStream(port_a.C_outflow);
//   for i in 1:Medium.nC loop
//   mC_flows_notSep[i] = (1.0-eta[i])* mC_flows[i];
//   end for;
  mC_flows_notSep + mC_flows_sep = mC_flows;
  mC_flows_sep = eta .* mC_flows;
  Cs_notSep.*port_a.m_flow = mC_flows_notSep;

  port_a.p = port_b.p;
  port_a.m_flow + port_b.m_flow = 0;

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = Cs_notSep;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-90,20},{90,-20}},
          lineColor={28,108,200},
          fillColor={0,110,220},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,132},{151,92}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName)),
        Polygon(
          points={{-90,80},{-90,80}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,-34},{-2,-50},{-10,-34}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,110,220},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,26},{0,26},{0,-14},{8,-14},{-2,-34},{-12,-14},{-4,-14},{
              -4,26}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,202,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SimpleSeparator;
