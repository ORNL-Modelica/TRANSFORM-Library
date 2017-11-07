within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.VoidFraction;
partial model PartialVoidFraction

  // Parameters
  replaceable package Medium =
    Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium in the component"
    annotation(Dialog(tab="Internal Interface"));

  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState state
    "Thermodynamic state" annotation(Dialog(tab="Internal Interface"));

  Media.BaseProperties2Phase medium2(redeclare package Medium = Medium, state=
        state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Units.VoidFraction alphaV "Void fraction";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialVoidFraction;
