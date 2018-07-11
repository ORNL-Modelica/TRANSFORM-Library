within TRANSFORM.Fluid.FittingsAndResistances;
model Buoyancy_specifyFriction

  extends BaseClasses.PartialResistancenew;

  input SI.Length dimension = 1 "Characteristic dimension" annotation(Dialog(group="Inputs"));
  input SI.Length length = 1 "Characteristic length" annotation(Dialog(group="Inputs"));
  input SI.Angle angle = 0 "Inclination angle. -90 < x < 90" annotation(Dialog(group="Inputs"));
  input SIadd.NonDim f = 0.01 "Friction factor" annotation(Dialog(group="Inputs"));
  input SIadd.NonDim K = 0 "Minor losses" annotation(Dialog(group="Inputs"));
  input SI.Acceleration g_n = Modelica.Constants.g_n "Gravitational acceleration" annotation(Dialog(group="Inputs"));

  SI.Length dheight = length*sin(angle);
  SI.Density d_delta = Medium.density(state_b)-Medium.density(state_a);

equation

  m_flow = sqrt(2*Medium.density(state)*(0.25*Modelica.Constants.pi*dimension^2)^2*g_n*dheight*abs(d_delta)/(f*length/dimension+K))*noEvent(if d_delta >= 0 then +1 else -1);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Buoyancy_specifyFriction;
