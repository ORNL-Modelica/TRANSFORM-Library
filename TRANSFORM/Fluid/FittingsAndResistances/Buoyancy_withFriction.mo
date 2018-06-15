within TRANSFORM.Fluid.FittingsAndResistances;
model Buoyancy_withFriction

  extends BaseClasses.PartialResistancenew;

  input SI.Length dimension = 1 "Characteristic dimension" annotation(Dialog(group="Inputs"));
  input SI.Length length = 1 "Characteristic length" annotation(Dialog(group="Inputs"));
  input SI.Angle angle = 0 "Inclination angle. -90 < x < 90" annotation(Dialog(group="Inputs"));
  input SIadd.NonDim K = 0 "Minor losses" annotation(Dialog(group="Inputs"));
  input SI.Length roughness = 2.5e-5 "Average height of surface asperities" annotation(Dialog(group="Inputs"));
  input SI.Acceleration g_n = Modelica.Constants.g_n "Gravitational acceleration" annotation(Dialog(group="Inputs"));

  SI.Length dheight = length*sin(angle);
  SI.Density d_delta = Medium.density(state_b)-Medium.density(state_a);

  SI.ReynoldsNumber Re "Reynolds number";

  SI.Velocity v "Velocity";

  Real fRe2_lam;
  Real fRe2_turb;
  Real fRe2;

equation

  Re = 4.0*abs(m_flow)/(Modelica.Constants.pi*dimension*Medium.dynamicViscosity(state));

  fRe2_lam =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Laminar_Local_Developed_Circular(
    Re);

  fRe2_turb =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Turbulent_Local_Developed_SwameeJain(
    Re,
    dimension,
    roughness);

  fRe2 = TRANSFORM.Math.spliceTanh(
    fRe2_turb,
    fRe2_lam,
    Re - Re_center,
    Re_width);

  (fRe2/Re^2*length/dimension + K)*0.5*Medium.density(state)*v^2 = g_n*dheight*d_delta;

  v = abs(m_flow)/(Medium.density(state)*0.25*Modelica.Constants.pi*dimension^2);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Buoyancy_withFriction;
