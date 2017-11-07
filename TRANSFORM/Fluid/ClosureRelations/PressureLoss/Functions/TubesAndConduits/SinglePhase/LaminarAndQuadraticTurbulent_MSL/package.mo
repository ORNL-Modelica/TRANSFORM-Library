within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase;
package LaminarAndQuadraticTurbulent_MSL "Pipe wall friction for laminar and turbulent flow in circular tubes (simple characteristic)"

  import ln = Modelica.Math.log "Logarithm, base e";
  import Modelica.Math.log10 "Logarithm, base 10";
  import Modelica.Math.exp "Exponential function";
  import Modelica.Constants.pi;







  annotation (Documentation(info="<html>
<p>
This component defines the quadratic turbulent regime of wall friction:
dp = k*m_flow*|m_flow|, where \"k\" depends on density and the roughness
of the pipe and is no longer a function of the Reynolds number.
This relationship is only valid for large Reynolds numbers.
At Re=4000, a polynomial is constructed that approaches
the constant &lambda; (for large Reynolds-numbers) at Re=4000
smoothly and has a derivative at zero mass flow rate that is
identical to laminar wall friction.
</p>
</html>"));
end LaminarAndQuadraticTurbulent_MSL;
