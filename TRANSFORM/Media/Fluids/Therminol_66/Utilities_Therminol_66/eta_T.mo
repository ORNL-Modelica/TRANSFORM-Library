within TRANSFORM.Media.Fluids.Therminol_66.Utilities_Therminol_66;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta :=d_T(T-273.15)*exp((586.375/((T-273.15) + 62.5)) - 2.2809)*1e-6;
end eta_T;
