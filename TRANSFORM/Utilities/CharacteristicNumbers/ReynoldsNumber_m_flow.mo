within TRANSFORM.Utilities.CharacteristicNumbers;
function ReynoldsNumber_m_flow "Return Reynolds number from m_flow, mu, D, A"
  extends Modelica.Icons.Function;
  input SI.MassFlowRate m_flow "Mass flow rate";
  input SI.DynamicViscosity mu "Dynamic viscosity";
  input SI.Length D
    "Characteristic dimension (e.g., hydraulic diameter)";
  input SI.Area A
    "Cross sectional area of flow";
  output SI.ReynoldsNumber Re "Reynolds number";
algorithm
  Re := abs(m_flow).*D./(A.*mu);
  annotation (Documentation(info="<html>
<p>Simplified calculation of Reynolds Number using the mass flow rate <code>m_flow</code> instead of the velocity <code>v</code> to express inertial forces. </p>
<pre>  Re = |m_flow|*diameter/(A*&mu;)
with
  m_flow = v*&rho;*A</pre>
<p>See also <a href=\"modelica://Modelica.Fluid.Pipes.BaseClasses.CharacteristicNumbers.ReynoldsNumber\">Pipes.BaseClasses.CharacteristicNumbers.ReynoldsNumber</a>. </p>
</html>"));
end ReynoldsNumber_m_flow;
