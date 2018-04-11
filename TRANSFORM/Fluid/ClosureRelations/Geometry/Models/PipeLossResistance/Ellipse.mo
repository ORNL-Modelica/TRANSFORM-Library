within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
model Ellipse

  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 2.6 - Non-circular correction factor for stabilized flow - Ellipse

  input SI.Length a0=0.01 "Major radial dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length b0=0.02 "Minor radial dimension"
    annotation (Dialog(group="Inputs"));

  extends PartialGeometry(
    final dimension=4*crossArea/perimeter,
    final crossArea=Modelica.Constants.pi*a0*b0,
    final perimeter=Modelica.Constants.pi*(a0+b0)*(1+3*(a0-b0)^2/(a0+b0)^2/(10+(4-3*(a0-b0)^2/(a0+b0)^2)^(0.5))));

equation
  ks[1] = 0.125*(dimension/b0)^2*(1+(b0/a0)^2);
  ks[2] = 1.0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/Resistences_ Geometry_PipeLoss_Ellipse.jpg\"/></p>
<p>Source: perimeter definition: Approximation 3 - https://www.mathsisfun.com/geometry/ellipse-perimeter.html</p>
</html>"));
end Ellipse;
