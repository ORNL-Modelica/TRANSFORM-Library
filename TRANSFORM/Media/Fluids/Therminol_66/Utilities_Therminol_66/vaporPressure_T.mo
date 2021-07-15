within TRANSFORM.Media.Fluids.Therminol_66.Utilities_Therminol_66;
function vaporPressure_T
  input SI.Temperature T;
  output SI.Pressure psat;
algorithm
  psat :=exp(-9094.51/((T-273.15)+340) + 17.6371)*1e3;
end vaporPressure_T;
