within TRANSFORM.Units.Conversions.Functions.CoefficientOfHeatTransfer_W_m2K;
function from_btu_hrft2degF
  "Coef. of Heat Transfer: [btu(IT)/(hr*ft^2*F)] -> [W/(m^2*K)]"
  extends BaseClasses.from;

algorithm
  y := u*5.678263398;
end from_btu_hrft2degF;
