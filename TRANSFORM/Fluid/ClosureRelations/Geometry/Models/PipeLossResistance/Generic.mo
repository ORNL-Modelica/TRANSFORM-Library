within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
model Generic "Generic | No constraint between dimension, crossArea, and perimeter"

  extends PartialGeometry;

  input Units.NonDim k_lam = 1.0 "Laminar region geometric correction coefficient" annotation (Dialog(group="Inputs"));
  input Units.NonDim k_turb = 1.0 "Turbulent region geometric correction coefficient" annotation (Dialog(group="Inputs"));

equation
  ks[1] = k_lam;
  ks[2] = k_turb;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>There is no assumed constraint between the variables dimension, crossArea, and perimeter nor fixed equations for laminar or turbulent geometric correction coefficients (ks).</p>
<p>This model can therefore be used for any shape desired but it is upon the user to ensure that calculations using this geometry are applicable.</p>
</html>"));
end Generic;
