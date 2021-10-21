within TRANSFORM.Media.Fluids.NaClKClMgCl2.Utilities_30_20_50;
function eta_T
  input SI.Temperature T;
  input Integer option=1;
  output SI.DynamicViscosity eta;
algorithm
  if option == 1 then
    eta := 1e-3*exp(3040/T - 2.96);
  elseif option == 2 then
    eta := 0.001*(0.689*exp(1224.73/(T)));
  else
    assert(true, "eta error");
  end if;
end eta_T;
