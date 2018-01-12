within TRANSFORM.HeatExchangers;
model UAdT_lm

  parameter SI.Temperature Ts_h[2] "Hot side temperature {inlet, outlet}";
  parameter SI.Temperature Ts_c[2] "Cold side temperature {inlet, outlet}";

  SI.HeatFlowRate Q_flow "Heat transfer rate";
  parameter SI.MassFlowRate m_flow_h "Hot side mass flow rate";
  parameter SI.MassFlowRate m_flow_c "Cold side mass flow rate";

  parameter SI.SpecificHeatCapacity cp_h "Hot side specific heat capacity";
  parameter SI.SpecificHeatCapacity cp_c "Cold side specific heat capacity";

  parameter Boolean counterCurrent = true "Specify if HX is counter (true) or parallel (false) current";
  SI.TemperatureDifference dT_lm "Log-mean temperature difference";
  SI.TemperatureDifference dTs[2] "Temperature differences for dT_lm";
  SI.CoefficientOfHeatTransfer U "Overall heat transfer coefficient";
  parameter SI.Area surfaceArea_h "Hot side heat transfer surface area";
  parameter SI.Area surfaceArea_c "Hot side heat transfer surface area";

equation

  Q_flow = m_flow_h*cp_h*(Ts_h[2] - Ts_h[1]);
  // or Q_flow = m_flow_c*cp_c*(Ts_c[2] - Ts_c[1]);

  Q_flow = U*surfaceArea_h*dT_lm;
  // or Q_flow = U*surfaceArea_c*dT_lm;

  dT_lm = (dTs[2] - dTs[1])/log(dTs[2]/dTs[1]);
  // or (dTs[1] -  dTs[2])/log(dTs[1]/ dTs[2]);

  if counterCurrent then
    dTs[1] = Ts_h[1] - Ts_c[1];
    dTs[2] = Ts_h[2] - Ts_c[2];
  else
    dTs[1] = Ts_h[1] - Ts_c[2];
    dTs[2] = Ts_h[2] - Ts_c[1];
  end if;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UAdT_lm;
