within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Monitoring;
model PumpMonitoringNPSH "Monitor Net Positive Suction Head (NPSH)"
  extends PumpMonitoringBase(redeclare replaceable package Medium =
    Modelica.Media.Interfaces.PartialTwoPhaseMedium);
  Medium.Density rho_in = Medium.density(state_in)
    "Liquid density at the inlet port_a";
  SI.Length NPSHa=NPSPa/(rho_in*system.g)
    "Net Positive Suction Head available";
  SI.Pressure NPSPa=assertPositiveDifference(Medium.pressure(state_in), Medium.saturationPressure(Medium.temperature(state_in)),
                                             "Cavitation occurs at the pump inlet")
    "Net Positive Suction Pressure available";
  SI.Pressure NPDPa=assertPositiveDifference(Medium.pressure(state), Medium.saturationPressure(Medium.temperature(state)),
                                             "Cavitation occurs in the pump")
    "Net Positive Discharge Pressure available";
end PumpMonitoringNPSH;
