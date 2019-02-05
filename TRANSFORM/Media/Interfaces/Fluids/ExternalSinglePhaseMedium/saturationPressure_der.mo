within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function saturationPressure_der "Return saturation pressure time derivative"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real T_der "Temperature derivative";
  output Real p_der "saturation pressure derivative";
  // Standard definition
algorithm
  p_der :=T_der/saturationTemperature_derp_sat(setSat_T(T));
  annotation(Inline = true);
end saturationPressure_der;
