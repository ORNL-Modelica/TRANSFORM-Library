within TRANSFORM.Media.Fluids.NaClKClMgCl2.Utilities_30_20_50;
function d_T
  input SI.Temperature T;
  input Integer option= 1;
  output SI.Density d;
algorithm
  if option == 1 then
  d:= 2260 - 0.778*(T-273.15);
  elseif option == 2 then
  d:= 1974-0.5878*(T-273.15);
  else
    assert(true,"d error");
  end if;
end d_T;
