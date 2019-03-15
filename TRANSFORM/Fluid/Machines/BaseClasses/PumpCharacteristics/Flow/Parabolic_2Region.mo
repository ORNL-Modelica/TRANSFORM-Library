within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow;
model Parabolic_2Region
  "Parabolic | 2 regions"
  extends PartialFlowChar;

  parameter Real cs[3]
    "Coefficients defining the equation: head = cs[1]*V_flow^2+cs[2]*V_flow+cs[3]";

protected
  constant SI.Height unit_head=1;
  constant SI.VolumeFlowRate unit_V_flow=1;

  final parameter Real x0=-0.5*cs[2]/cs[1]
    "x-position at which dhead/dV_flow = 0";
  final parameter Real y0=cs[1]*x0^2 + cs[2]*x0 + cs[3]
    "y-Position at which dhead/dV_flow = 0";

  Real x=head/affinityLaw_head;
  Real y=V_flow/affinityLaw_flow;

  Real x_low;
  Real x_high;
  Real sqroot;

equation

  sqroot = sqrt(cs[2]^2 - 4*cs[1]*(cs[3] - x));

  x_high = (-cs[2] - sqroot)/2*cs[1];
  x_low = (-cs[2] + sqroot)/2*cs[1];


  if x > (y0 - 0.01) then
    y = x0;
  else
    if y < x0 then
      y = x_low;
    else
      y = x_high;
    end if;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Parabolic_2Region;
