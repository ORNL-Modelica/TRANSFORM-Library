within TRANSFORM.Fluid.FittingsAndResistances;
model PipeLoss

  extends
    TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;

  //   parameter Boolean use_Dimension=true
  //     "=true to specify characteristic dimension else cross-sectional area and wetted perimeter"
  //     annotation (Evaluate=true);
  //
  //   input SI.Length dimension=0.01
  //     "Characteristic dimension (e.g., hydraulic diameter) at {port_a,port_b}"
  //     annotation (Dialog(group="Input Variables", enable=use_Dimension));
  //   input SI.Area crossArea=0.25*Modelica.Constants.pi*dimension*dimension
  //     "Cross sectional area at {port_a,port_b}"
  //     annotation (Dialog(group="Input Variables", enable=not use_Dimension));
  //   input SI.Length perimeter=Modelica.Constants.pi*dimension
  //     "Wetted perimeter at {port_a,port_b}"
  //     annotation (Dialog(group="Input Variables", enable=not use_Dimension));
  //   input SI.Length dlength=1.0 "Pipe length"
  //     annotation (Dialog(group="Input Variables"));
  //   input SI.Length dheight=0 "Height change (port_b - port_a)"
  //     annotation (Dialog(group="Input Variables"));
  // input SI.Height roughness=2.5e-5 "Average height of surface asperities"
  //   annotation (Dialog(group="Input Variables"));

  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance.Circle
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance.PartialGeometry
    annotation (choicesAllMatching=true);

  Geometry geometry annotation (Placement(transformation(extent={{-96,84},{-84,96}})));

  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(group="Input Variables"));
  input SIadd.nonDim K_ab=0 "Minor loss coefficient. Flow in direction a -> b"
    annotation (Dialog(group="Input Variables"));
  input SIadd.nonDim K_ba=0 "Minor loss coefficient. Flow in direction b -> a"
    annotation (Dialog(group="Input Variables"));
  input SIadd.nonDim CFs[2]={1.0,1.0}
    "Frictional loss correction factors: {Laminar, Turbulent}"
    annotation (Dialog(group="Input Variables"));

  SI.ReynoldsNumber Re "Reynolds number";

  SIadd.nonDim K "Minor loss coefficient";

  SI.Velocity v_a "Velocity at port_a";
  SI.Velocity v_b "Velocity at port_a";

  Real fRe2_lam;
  Real fRe2_turb;
  Real fRe2;
  SI.PressureDifference dp_K;
  SI.PressureDifference dp_f;
  SI.PressureDifference dp_g;

equation

  Re = 4.0*abs(m_flow)/(Modelica.Constants.pi*geometry.dimension*
    Medium.dynamicViscosity(state));
  K = smooth(0, noEvent(if m_flow >= 0 then K_ab else -K_ba));
  dp = dp_f + dp_K + dp_g;

  dp_K = K*m_flow^2/(2*Medium.density(state)*geometry.crossArea)^2;

  fRe2_lam =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Laminar_Local_Developed_Circular(
    Re);

  fRe2_turb =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Turbulent_Local_Developed_SwameeJain(
    Re,
    geometry.dimension,
    geometry.roughness);

  fRe2 = TRANSFORM.Math.spliceTanh(
    fRe2_turb,
    fRe2_lam,
    Re - Re_center,
    Re_width);

  dp_f = 0.5*fRe2*geometry.dlength*Medium.dynamicViscosity(state)^2/(geometry.dimension*
    geometry.dimension*geometry.dimension*Medium.density(state))*noEvent(if m_flow >= 0 then +1
     else -1);
  dp_g = g_n*geometry.dheight*Medium.density(state);

  v_a = abs(m_flow)/(Medium.density(state)*0.25*Modelica.Constants.pi*
    geometry.dimension^2);
  v_b = abs(m_flow)/(Medium.density(state)*0.25*Modelica.Constants.pi*
    geometry.dimension^2);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}), Line(points={{-90,0},{-42,0},{-36,18},{-24,
              -18},{-12,18},{0,-18},{12,18},{24,-18},{36,18},{42,0},{90,0}},
            color={0,0,0})}),                                    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PipeLoss;
