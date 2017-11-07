within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Head;
function head_quadraticCurve
  "Quadratic flow characteristic curve, including linear extrapolation"
  extends Icons.Function;
  import getCoeffs = TRANSFORM.Math.QuadraticCoefficients;

  input SI.VolumeFlowRate V_flow "Volumetric flow rate";
  input SI.VolumeFlowRate[3] V_flow_curve "Volume flow rate for three operating points (single pump)";
  input SI.Height[3] head_curve "Pump head for three operating points";

  output SI.Height head "Pump pressure head";

protected
  Real[3] c = getCoeffs(V_flow_curve,head_curve) "Coefficients of quadratic head curve";
  SI.VolumeFlowRate V_flow_min = min(V_flow_curve);
  SI.VolumeFlowRate V_flow_max = max(V_flow_curve);

algorithm
  assert(max(c[2].+2*c[3].*V_flow_curve) <= -Modelica.Constants.small,
         "Wrong pump curve -- head_curve must be monotonically decreasing with increasing V_flow_curve",
         level=AssertionLevel.warning);

   if V_flow < V_flow_min then
     head := max(head_curve) + (V_flow-V_flow_min)*(c[2]+2*c[3]*V_flow_min);
   elseif V_flow > V_flow_max then
     head := min(head_curve) + (V_flow-V_flow_max)*(c[2]+2*c[3]*V_flow_max);
   else
     // Flow equation: head  = c[1] + V_flow*c[2] + V_flow^2*c[3];
     head :=  c[1] + V_flow*(c[2] + V_flow*c[3]);
   end if;

//    if head < 0 then
//      head :=0;
//    end if;
//   head := noEvent(
//     if V_flow < V_flow_min then
//       max(head_curve) + (V_flow-V_flow_min)*(c[2]+2*c[3]*V_flow_min)
//     elseif V_flow > V_flow_max then
//       min(head_curve) + (V_flow-V_flow_max)*(c[2]+2*c[3]*V_flow_max)
//     else
//       c[1] + V_flow*(c[2] + V_flow*c[3]));

  annotation(Documentation(revisions="<html>
</html>"));
end head_quadraticCurve;
