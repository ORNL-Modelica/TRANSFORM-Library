within TRANSFORM.Units.Conversions.Functions.ThermalConductivity_W_mK;
function to_btu_hrftdegF
  "Thermal Conductivity: [W/(m*K)] -> [btu(IT)/(hr*ft*F)]"
  extends BaseClasses.to;

algorithm
  y := u*1/1.7307346663714;
end to_btu_hrftdegF;
