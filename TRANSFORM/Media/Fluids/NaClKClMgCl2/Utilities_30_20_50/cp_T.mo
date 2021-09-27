within TRANSFORM.Media.Fluids.NaClKClMgCl2.Utilities_30_20_50;
function cp_T
  input SI.Temperature T;
  input Integer option=1;
  output SI.SpecificHeatCapacity cp;
algorithm
  if option == 1 then
    cp:=TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK.from_cal_gK(0.24);
  elseif option == 2 then
    cp := 1000*(1.284e-6*(T-273.15)^2-1.843e-3*(T-273.15) + 1.661);
  else
    assert(true, "cp error");
  end if;
end cp_T;
