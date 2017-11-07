within TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics;
partial function baseFun "Base class for valve characteristics"
  extends Modelica.Icons.Function;
  input Real pos(min=0, max=1)
      "Opening position (0: closed, 1: fully open)";
  output Real rc "Relative flow coefficient (per unit)";
  annotation (Documentation(info="<html>
<p>
This is a partial function that defines the interface of valve
characteristics. The function returns \"rc = valveCharacteristic\" as function of the
opening \"pos\" (in the range 0..1):
</p>

<blockquote><pre>
    dp = (zeta_TOT/2) * rho * velocity^2
m_flow =    sqrt(2/zeta_TOT) * Av * sqrt(rho * dp)
m_flow = valveCharacteristic * Av * sqrt(rho * dp)
m_flow =                  rc * Av * sqrt(rho * dp)
</pre></blockquote>

</html>"));
end baseFun;
