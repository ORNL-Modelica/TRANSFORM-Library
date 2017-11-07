within TRANSFORM.HeatExchangers.Utilities.Functions;
function LMTD
  "Calculation of the log mean temperature difference for a heat exchanger"
  extends Modelica.Icons.Function;

  input SI.Temperature T_hi "Hot stream inlet temperature";
  input SI.Temperature T_ho "Hot stream outlet temperature";
  input SI.Temperature T_ci "Cold stream inlet temperature";
  input SI.Temperature T_co "Cold stream outlet temperature";
  input Boolean counterCurrent "=true then flow counter current else parallel flow";

  output SI.TemperatureDifference dT_lm "Log mean temperature difference";
  output SI.TemperatureDifference dT_1 "Temperature difference 1 of LMTD";
  output SI.TemperatureDifference dT_2 "Temperature difference 2 of LMTD";

protected
  SI.TemperatureDifference dT_small = 1;
algorithm
  if counterCurrent then
    dT_1 :=T_hi - T_co;
    dT_2 :=T_ho - T_ci;
  else
    dT_1 :=T_hi - T_ci;
    dT_2 :=T_ho - T_co;
  end if;

   dT_lm :=smooth(1, if abs(dT_1 - dT_2) <= 1e-4 then 0
                    else (dT_1 - dT_2)/log(max(0.000001,dT_1/dT_2)));

  annotation (Documentation(info="<html>
</html>"));
end LMTD;
