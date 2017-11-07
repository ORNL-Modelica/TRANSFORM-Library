within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Efficiency;
function eta_quadraticCurve
  "Quadratic efficiency characteristic curve, including linear extrapolation"
  extends Icons.Function;
  import getCoeffs = TRANSFORM.Math.QuadraticCoefficients;

  input SI.VolumeFlowRate V_flow "Volumetric flow rate";
  input SI.VolumeFlowRate[3] V_flow_curve "Volume flow rate for three operating points (single pump)";
  input SI.Efficiency[3] eta_curve "Pump efficiency for three operating points";

  output SI.Efficiency eta "Pump efficiency";

protected
  Real[3] c = getCoeffs(V_flow_curve,eta_curve) "Coefficients of quadratic efficiency curve";

algorithm

   eta :=  c[1] + V_flow*(c[2] + V_flow*c[3]);

  annotation(Documentation(revisions="<html>
</html>"));
end eta_quadraticCurve;
