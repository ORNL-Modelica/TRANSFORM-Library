within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Flow;
function V_flow_quadraticCurve
  "Quadratic flow characteristic curve, including linear extrapolation"
  extends Icons.Function;
  import getCoeffs = TRANSFORM.Math.quadraticCoefficients;

  input SI.Height head "Pressure head";
  input SI.VolumeFlowRate[3] V_flow_curve "Volume flow rate for three operating points (single pump)";
  input SI.Height[3] head_curve "Pump head for three operating points";

  output SI.VolumeFlowRate V_flow "Volume flow rate";

protected
  Real[3] c = getCoeffs(head_curve,V_flow_curve) "Coefficients of quadratic head curve";
  SI.Height head_min = min(head_curve);
  SI.Height head_max = max(head_curve);

algorithm
  assert(max(c[2].+2*c[3].*head_curve) <= -Modelica.Constants.small,
         "Wrong pump curve -- V_flow_curve must be monotonically decreasing with increasing head_curve",
         level=AssertionLevel.warning);

   if head < head_min then
     V_flow := max(V_flow_curve) + (head-head_min)*(c[2]+2*c[3]*head_min);
   elseif head > head_max then
     V_flow := min(V_flow_curve) + (head-head_max)*(c[2]+2*c[3]*head_max);
   else
     // Flow equation: head  = c[1] + head*c[2] + head^2*c[3];
     V_flow :=  c[1] + head*(c[2] + head*c[3]);
   end if;

//    if head < 0 then
//      V_flow :=0;
//    end if;
//   V_flow := noEvent(
//     if head < head_min then
//       max(V_flow_curve) + (head-head_min)*(c[2]+2*c[3]*head_min)
//     elseif V_flow > head_max then
//       min(V_flow_curve) + (head-head_max)*(c[2]+2*c[3]*head_max)
//     else
//       c[1] + head*(c[2] + head*c[3]));

  annotation(Documentation(revisions="<html>
</html>"));
end V_flow_quadraticCurve;
