within TRANSFORM.Fluid.FittingsAndResistances;
model SharpEdgedAdaptor
  extends
    TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  parameter Boolean use_Dimension=true
    "=true to specify characteristic dimension else cross-sectional area and wetted perimeter"
    annotation (Evaluate=true);
  input SI.Length dimensions_ab[2]={0.01,0.02}
    "Characteristic dimension (e.g., hydraulic diameter) at {port_a,port_b}"
    annotation (Dialog(group="Inputs", enable=use_Dimension));
  input SI.Area crossAreas_ab[2]=0.25*Modelica.Constants.pi*dimensions_ab .*
      dimensions_ab "Cross sectional area at {port_a,port_b}"
    annotation (Dialog(group="Inputs", enable=not use_Dimension));
  input SI.Length perimeters_ab[2]=Modelica.Constants.pi*dimensions_ab
    "Wetted perimeter at {port_a,port_b}"
    annotation (Dialog(group="Inputs", enable=not use_Dimension));
  input Units.NonDim CFs[4]={1.0,1.0,1.0,1.0}
    "Expansion correction factors: {Laminar expansion, Turbulent expansion, Laminar contraction, Turbulent contraction}"
    annotation (Dialog(group="Inputs"));
  SI.ReynoldsNumber Re "Reynolds number";
  Units.NonDim K_ab "Minor loss coefficient if flow a->b";
  Units.NonDim K_ba "Minor loss coefficient if flow b->a";
  Units.NonDim K "Minor loss coefficient";
  SI.Velocity v_a "Velocity at port_a";
  SI.Velocity v_b "Velocity at port_a";
  SI.Length dimensions[2]=if use_Dimension then dimensions_ab else 4*
      crossAreas_ab ./ perimeters_ab
    "Characteristic dimension (e.g., hydraulic diameter)";
  SI.Area crossAreas[2]=if use_Dimension then 0.25*Modelica.Constants.pi*
      dimensions_ab .* dimensions_ab else crossAreas_ab "Cross-sectional area";
  SI.Length perimeters[2]=if use_Dimension then Modelica.Constants.pi*
      dimensions_ab else perimeters_ab "Wetted perimeter";
  Real crossAreaRatio=crossAreas[1]/crossAreas[2]
    "Ratio of crossArea_a/crossArea_b";
equation
  Re = 4.0*abs(m_flow)/(Modelica.Constants.pi*min(dimensions)*
    Medium.dynamicViscosity(state));
  K = smooth(0, noEvent(if m_flow >= 0 then K_ab else -K_ba));
  dp = K*m_flow^2/(2*Medium.density(state)*min(crossAreas)^2);
  K_ab =TRANSFORM.Math.spliceTanh(
    ClosureRelations.PressureLoss.Functions.Orifices.K_suddenContraction(
      crossAreas,
      Re,
      CFs[3:4]),
    ClosureRelations.PressureLoss.Functions.Orifices.K_suddenExpansion(
      crossAreas,
      Re,
      CFs[1:2]),
    crossAreaRatio - 1.0,
    0.01);
  K_ba =TRANSFORM.Math.spliceTanh(
    ClosureRelations.PressureLoss.Functions.Orifices.K_suddenExpansion(
      crossAreas,
      Re,
      CFs[1:2]),
    ClosureRelations.PressureLoss.Functions.Orifices.K_suddenContraction(
      crossAreas,
      Re,
      CFs[3:4]),
    crossAreaRatio - 1.0,
    0.01);
  v_a = abs(m_flow)/(Medium.density(state)*0.25*Modelica.Constants.pi*
    dimensions[1]^2);
  v_b = abs(m_flow)/(Medium.density(state)*0.25*Modelica.Constants.pi*
    dimensions[2]^2);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
            extent=DynamicSelect({{-90,22},{0,-22}}, {{-90,max(0.1, min(1,dimensions_ab[1]/max(dimensions_ab)))*60},{0,-max(0.1, min(1,dimensions_ab[1]/max(dimensions_ab)))*60}}),
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}), Rectangle(
            extent=DynamicSelect({{0,60},{90,-60}}, {{0,max(0.1, min(1,
                dimensions_ab[2]/max(dimensions_ab)))*60},{90,-max(0.1, min(
                1, dimensions_ab[2]/max(dimensions_ab)))*60}}),
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255})}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SharpEdgedAdaptor;
