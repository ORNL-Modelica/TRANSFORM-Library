within TRANSFORM.HeatExchangers;
model UAdT_lm

  parameter String calcType = "U" "Variable to be calculated" annotation(choices(choice="U",choice="surfaceArea"));
  parameter Boolean counterCurrent = true "Specify if HX is counter (true) or parallel (false) current";

  input SI.Temperature Ts_h[2] "Hot side temperature {inlet, outlet}" annotation(Dialog(group="Input Variables"));
  input SI.Temperature Ts_c[2] "Cold side temperature {inlet, outlet}" annotation(Dialog(group="Input Variables"));
  input SI.HeatFlowRate Q_flow "Heat transfer rate (e.g., m__flow*cp*dT)" annotation(Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer U_input = 0 "Overall heat transfer coefficient" annotation(Dialog(group="Input Variables",enable=calcType=="surfaceArea"));
  input SI.Area surfaceArea_input = 0 "Reference heat transfer surface area" annotation(Dialog(group="Input Variables",enable=calcType=="U"));

  SI.TemperatureDifference dT_lm "Log-mean temperature difference";
  SI.TemperatureDifference dTs[2] "Temperature differences for dT_lm";

  SI.Area surfaceArea "Reference heat transfer surface area";
  SI.CoefficientOfHeatTransfer U "Overall heat transfer coefficient";
  SI.ThermalConductance UA "Overall heat transfer conductance";

equation

  if calcType == "U" then
    surfaceArea = surfaceArea_input;
  elseif calcType == "surfaceArea" then
    U = U_input;
  end if;

  abs(Q_flow) = U*surfaceArea*dT_lm;
  UA = U*surfaceArea;

  dT_lm = (dTs[2] - dTs[1])/log(dTs[2]/dTs[1]);
  // or (dTs[1] -  dTs[2])/log(dTs[1]/ dTs[2]);

  if counterCurrent then
    dTs[1] = Ts_h[1] - Ts_c[2];
    dTs[2] = Ts_h[2] - Ts_c[1];
  else
    dTs[1] = Ts_h[1] - Ts_c[1];
    dTs[2] = Ts_h[2] - Ts_c[2];
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,92},{140,52}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-40,10},{40,-10}},
          lineColor={0,0,0},
          textString="UA*dT_lm")}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UAdT_lm;
