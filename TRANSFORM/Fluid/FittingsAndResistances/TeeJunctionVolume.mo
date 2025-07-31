within TRANSFORM.Fluid.FittingsAndResistances;
model TeeJunctionVolume
  "Splitting/joining component with static balances for a dynamic control volume"
  extends TRANSFORM.Fluid.Volumes.BaseClasses.PartialVolume(
  mb=port_1.m_flow + port_2.m_flow + port_3.m_flow,
  Ub=port_1.m_flow*actualStream(port_1.h_outflow)
            + port_2.m_flow*actualStream(port_2.h_outflow)
            + port_3.m_flow*actualStream(port_3.h_outflow),
  mXib=port_1.m_flow*actualStream(port_1.Xi_outflow)
              + port_2.m_flow*actualStream(port_2.Xi_outflow)
              + port_3.m_flow*actualStream(port_3.Xi_outflow),
  mCb=port_1.m_flow*actualStream(port_1.C_outflow)
            + port_2.m_flow*actualStream(port_2.C_outflow)
            + port_3.m_flow*actualStream(port_3.C_outflow));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_2(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_3(
    redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

equation
  // Only one connection allowed to a port to avoid unwanted ideal mixing
  assert(cardinality(port_1) <= 1,"
port_1 of volume can at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections which is usually not the intention
of the modeller.
");
  assert(cardinality(port_2) <= 1,"
port_2 of volume can at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections which is usually not the intention
of the modeller.
");
  assert(cardinality(port_3) <= 1,"
port_3 of volume can at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections which is usually not the intention
of the modeller.
");
  // Boundary conditions
  port_1.h_outflow = medium.h;
  port_2.h_outflow = medium.h;
  port_3.h_outflow = medium.h;
  port_1.Xi_outflow = medium.Xi;
  port_2.Xi_outflow = medium.Xi;
  port_3.Xi_outflow = medium.Xi;
  port_1.C_outflow = C;
  port_2.C_outflow = C;
  port_3.C_outflow = C;
  // Momentum balance (suitable for compressible media)
  port_1.p = medium.p;
  port_2.p = medium.p;
  port_3.p = medium.p;
  annotation (defaultComponentName="tee",Documentation(info="<html>
  This model introduces a mixing volume into a junction.
  This might be useful to examine the non-ideal mixing taking place in a real junction.</html>"),
Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-40,90},{40,40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor=DynamicSelect({0,128,255}, if showColors then dynColor
               else {0,128,255})),
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor=DynamicSelect({0,128,255}, if showColors then dynColor
               else {0,128,255})),                  Ellipse(
          extent={{-9,10},{11,-10}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end TeeJunctionVolume;
