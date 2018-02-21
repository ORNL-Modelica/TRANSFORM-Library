within TRANSFORM.Fluid.Pipes;
model TransportDelayPipe
  import TRANSFORM;

  extends TRANSFORM.Fluid.Pipes.BaseClasses.PartialTwoPortPipe(
    final allowFlowReversal=true,
    final exposeState_a=false,
    final exposeState_b=false);

  parameter SI.Area crossArea;
  parameter SI.Length length;
  //parameter SI.Density d;
  parameter SI.Acceleration g_n=Modelica.Constants.g_n;
  parameter SI.Height dheight=0;
  parameter SI.Height roughness=2.5e-5;
  parameter SI.MassFlowRate m_flow_smooth=0.001
    "Smoothing tolerance around zero flow rate"
    annotation (Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300
    "Laminar transition Reynolds number" annotation (Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000
    "Turbulent transition Reynolds number" annotation (Dialog(tab="Advanced"));

  input SI.NusseltNumber fRe2_lam=
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Laminar_Local_Developed_Circular(
       Re) "Laminar Friction factor"
    annotation (Dialog(group="Input Variables"));

  input SI.NusseltNumber fRe2_turb=
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Turbulent_Local_Developed_SwameeJain(
      Re,
      dimension,
      roughness) "Turbulent Friction factor"
    annotation (Dialog(group="Input Variables"));
  input TRANSFORM.Units.NonDim K_ab=0
    "Minor loss coefficients. Flow in direction a -> b"
    annotation (Dialog(group="Input Variables"));
  input TRANSFORM.Units.NonDim K_ba=0
    "Minor loss coefficients. Flow in direction b -> a"
    annotation (Dialog(group="Input Variables"));
  input SI.PressureDifference dp_add_ab=0
    "Additional pressure losses. Flow in direction a -> b"
    annotation (Dialog(group="Input Variables"));
  input SI.PressureDifference dp_add_ba=0
    "Additional pressure losses. Flow in direction b -> a"
    annotation (Dialog(group="Input Variables"));

  SI.Volume V=crossArea*length;

  Real u(unit="1/s");
  Real x;
  SI.PressureDifference dp;
  SI.Velocity v(start=0);
  SI.MassFlowRate m_flow;

  Medium.ThermodynamicState state_a;
  Medium.ThermodynamicState state_b;
  Medium.ThermodynamicState state;

  SI.Length dimension=2*(crossArea/Modelica.Constants.pi)^0.5;

  SI.PressureDifference dp_fg "Pressure drop between states";

  SI.PressureDifference dp_f "Frictional pressure drop";
  SI.PressureDifference dp_g "Gravitational pressure drop";

  SI.ReynoldsNumber Re;

  TRANSFORM.Units.NonDim fRe2;

  //SI.Time time_a;
  //SI.Time time_b;
  SI.Time tau=length/max(1e-3, v);

protected
  final parameter SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb)
    "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width=Re_turb - Re_center
    "Re smoothing transition width";

  // Dummy variables that are not used but if removed cause error (weird)
  Real Cin0=if Medium.nC > 0 then inStream(port_a.C_outflow[1]) else 0;
  Real Cin1=if Medium.nC > 0 then inStream(port_b.C_outflow[1]) else 0;
  Real Xin0=if Medium.nXi > 0 then inStream(port_a.Xi_outflow[1]) else 0;
  Real Xin1=if Medium.nXi > 0 then inStream(port_b.Xi_outflow[1]) else 0;

initial equation
  x = 0;

equation

  state_a = Medium.setState_phX(
    port_a.p,
    inStream(port_a.h_outflow),
    inStream(port_a.Xi_outflow));

  state_b = Medium.setState_phX(
    port_b.p,
    inStream(port_b.h_outflow),
    inStream(port_b.Xi_outflow));

  state = Medium.setSmoothState(
    m_flow,
    state_a,
    state_b,
    m_flow_smooth);

  Re = abs(m_flow)*dimension/(Medium.dynamicViscosity(state)*crossArea);

  fRe2 = TRANSFORM.Math.spliceTanh(
    fRe2_turb,
    fRe2_lam,
    Re - Re_center,
    Re_width);

  dp_f = 0.5*fRe2*length*Medium.dynamicViscosity(state)^2/(dimension*dimension*
    dimension*Medium.density(state))*noEvent(if v >= 0 then +1 else -1);

  dp_g = g_n*dheight*Medium.density(state);

  dp_fg = dp_f + dp_g + TRANSFORM.Math.spliceTanh(
    dp_add_ab + 0.5*K_ab*Medium.density(state)*v*v,
    -dp_add_ba - 0.5*K_ba*Medium.density(state)*v*v,
    m_flow,
    m_flow_smooth);

  m_flow = port_a.m_flow;
  v = m_flow/(Medium.density(state)*crossArea);

  dp = dp_fg;
  port_a.p - port_b.p = dp;

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  //Normalized speed of the fluid [1/s]
  u = port_a.m_flow/(Medium.density(state)*V);
  der(x) = u;

  //Spatial distribution transport functions
  (port_a.h_outflow,port_b.h_outflow) = spatialDistribution(
    inStream(port_a.h_outflow),
    inStream(port_b.h_outflow),
    x,
    noEvent(v >= 0),
    {0.0,1.0},
    {inStream(port_a.h_outflow),inStream(port_b.h_outflow)});

  for i in 1:Medium.nXi loop
    (port_a.Xi_outflow[i],port_b.Xi_outflow[i]) = spatialDistribution(
      inStream(port_a.Xi_outflow[i]),
      inStream(port_b.Xi_outflow[i]),
      x,
      noEvent(v >= 0),
      {0.0,1},
      {inStream(port_a.Xi_outflow[i]),inStream(port_b.Xi_outflow[i])});
  end for;

  for i in 1:Medium.nC loop
    (port_a.C_outflow[i],port_b.C_outflow[i]) = spatialDistribution(
      inStream(port_a.C_outflow[i]),
      inStream(port_b.C_outflow[i]),
      x,
      noEvent(v >= 0),
      {0.0,1},
      {inStream(port_a.C_outflow[i]),inStream(port_b.C_outflow[i])});
  end for;

  // Proposed method for determing time fluid is in pipe.
  // However, it is not bounded and perhaps not a good way
  //   (time_a,time_b) = spatialDistribution(
  //     time,
  //     time,
  //     x/length,
  //     noEvent(v >= 0),
  //     {0.0,1.0},
  //     {0.0,0.0});
  //
  //   tau = noEvent(if v >= 0 then time - time_b else time - time_a);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Line(points={{-80,-20}}, color={28,108,200}),
        Line(points={{-40,-20},{0,-20},{0,20},{40,20}}, color={0,0,0}),
        Line(points={{-58,18}}, color={28,108,200}),
        Line(
          points={{-40,-20},{6,-20},{6,20},{40,20}},
          color={255,0,0},
          pattern=LinePattern.Dash)}),
                                   Diagram(coordinateSystem(preserveAspectRatio=
           false)),
    Documentation(info="<html>
<p>Transport delay of enthalpy, species, and trace substances using the spatialDistriubtion() function which supports flow reversal. This is an ideal transport with no diffusion (i.e., step change in the input will see a step change in the outlet once the wave has propagated through the pipe).</p>
<p>Currently the initialization is set by the inStream() properties of the connected port. Future edits may change this to allow more user control.</p>
</html>"));
end TransportDelayPipe;
