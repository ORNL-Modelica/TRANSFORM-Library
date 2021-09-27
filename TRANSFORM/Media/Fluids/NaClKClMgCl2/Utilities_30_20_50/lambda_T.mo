within TRANSFORM.Media.Fluids.NaClKClMgCl2.Utilities_30_20_50;
function lambda_T
  input SI.Temperature T;
  input Integer option=1;
  output SI.ThermalConductivity lambda;
algorithm
  if option == 1 then
    lambda:=0.39;
  elseif option == 2 then
    lambda := 7.151e-7*(T-273.15)^2-1.066e-3*(T-273.15)+0.811;
  else
    assert(true, "lambda error");
  end if;

end lambda_T;
