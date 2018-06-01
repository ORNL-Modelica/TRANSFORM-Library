within TRANSFORM.Fluid.ClosureRelations.VoidFraction.Functions;
function alphaV_Homogeneous_wSlipRatio
  "Volume void fraction with velocity slip ratio (i.e., S = 1 is homogenous model)"

  extends Modelica.Icons.Function;

  input SI.QualityFactor x_abs "Absolute mass quality of secondary phase";
  input SI.Density rho_p "Primary phase density (e.g., liquid density)";
  input SI.Density rho_s "Secondary phase density (e.g., vapor density)";
  input Units.NonDim S = 1 "Velocity slip ratio";

  output Units.VoidFraction alphaV "Void fraction";
algorithm
  alphaV := rho_p*x_abs/(S*rho_s*(1 - x_abs) + rho_p*x_abs);

  annotation (Documentation(info="<html>
<p>The homogeneous void fraction calculation with velocity slip ratio calculation.</p>
</html>"));
end alphaV_Homogeneous_wSlipRatio;
