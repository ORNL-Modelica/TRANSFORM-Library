within TRANSFORM.Media.Solids.ZircHX;
function thermalDiffusivity
  "Thermal diffusivity"
  input ThermodynamicState state "Thermodynamic state record";
  output Modelica.Units.SI.ThermalDiffusivity delta "Thermal diffusivity";
algorithm
  delta := (deltas[1]/(state.T+deltas[2]*(2-X)-deltas[3])-deltas[4])/1e4;
end thermalDiffusivity;
