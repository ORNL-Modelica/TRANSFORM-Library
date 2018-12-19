within TRANSFORM.Units.Conversions.Functions.CoefficientOfHeatTransfer_W_m2K;
function to_btu_hrft2degF
  "Coef. of Heat Transfer: [W/(m^2*K)] -> [btu(IT)/(hr*ft^2*F)]"
  extends BaseClasses.to;

algorithm
  y := u/5.678263398;
end to_btu_hrft2degF;
