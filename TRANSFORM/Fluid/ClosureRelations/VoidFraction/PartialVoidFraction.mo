within TRANSFORM.Fluid.ClosureRelations.VoidFraction;
partial model PartialVoidFraction
  input Units.NonDim S=1.0 "Velocity slip ratio" annotation(Dialog(group="Inputs"));
  input SI.QualityFactor x_abs "Absolute mass quality of secondary phase" annotation(Dialog(tab="Internal Interface"));
  input SI.Density rho_p "Primary phase density (e.g., liquid density)" annotation(Dialog(tab="Internal Interface"));
  input SI.Density rho_s "Secondary phase density (e.g., vapor density)" annotation(Dialog(tab="Internal Interface"));
  Units.VoidFraction alphaV "Void fraction";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialVoidFraction;
