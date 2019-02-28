within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Power;
function power_quadraticCurve
  "Quadratic power characteristic curve, including linear extrapolation"
  extends Icons.Function;
  import getCoeffs = TRANSFORM.Math.quadraticCoefficients;
  input SI.VolumeFlowRate V_flow "Volumetric flow rate";
  input SI.VolumeFlowRate[3] V_flow_curve "Volume flow rate for three operating points (single pump)";
  input SI.Power[3] W_curve "Power consumption for three operating points";
  output SI.Power W "Pump power consumption";
  output Real[3] cs "Curve coefficients";
protected
  Real[3] c = getCoeffs(V_flow_curve,W_curve) "Coefficients of quadratic power consumption curve";
  SI.VolumeFlowRate V_flow_min = min(V_flow_curve);
  SI.VolumeFlowRate V_flow_max = max(V_flow_curve);
algorithm
 assert(max(c[2].+2*c[3].*V_flow_curve) >= -Modelica.Constants.small,
        "Wrong pump curve -- W_curve must be monotonically increasing with increasing V_flow_curve",
        level=AssertionLevel.warning);
   if V_flow < V_flow_min then
     W := min(W_curve) + (V_flow-V_flow_max)*(c[2]+2*c[3]*V_flow_max);
   elseif V_flow > V_flow_max then
     W := max(W_curve) + (V_flow-V_flow_min)*(c[2]+2*c[3]*V_flow_min);
   else
     // Flow equation: W  = c[1] + V_flow*c[2] + V_flow^2*c[3];
     W :=  c[1] + V_flow*(c[2] + V_flow*c[3]);
   end if;
   W := max(0.0, W);
   cs := c;
  annotation(Documentation(revisions="<html>
</html>"));
end power_quadraticCurve;
