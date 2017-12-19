within TRANSFORM.Controls;
model P_Control "Proportional controller: y = yb + Kc*e"

  extends Modelica.Blocks.Interfaces.SVcontrol;

  parameter Boolean directActing = true "=false reverse acting" annotation(Evaluate=true);
  parameter Real k(unit="1")=1 "Error gain";
  parameter Real yb = 0 "Output bias";

  parameter Real k_s= 1 "Scaling factor for setpoint: set = k_s*u_s";
  parameter Real k_m= 1 "Scaling factor for measurment: meas = k_m*u_m";

  Real Kc = k*(if directActing then +1 else -1);
  Real e = k_s*u_s-k_m*u_m "Setpoint - Measured error";
equation
  y = yb + Kc*e;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end P_Control;
