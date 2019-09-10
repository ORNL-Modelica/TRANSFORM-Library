within TRANSFORM.Units.Conversions.Functions.ThermalConductivity_W_mK;
function from_btu_hrftdegF
  "Thermal Conductivity: [btu(IT)/(hr*ft*F)] -> [W/(m*K)]"
  extends BaseClasses.from;
algorithm
  y := u*1.7307346663714;
end from_btu_hrftdegF;
