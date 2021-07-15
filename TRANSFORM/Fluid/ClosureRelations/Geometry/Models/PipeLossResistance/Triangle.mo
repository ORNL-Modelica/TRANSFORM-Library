within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
model Triangle
  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 2.8 - Circular correction factor for stabilized flow - Triangular
  // The three triangles have been condensed to 1 implementation due to the
  // relatively small variation between the three
  input SI.Length h=0.01 "Triangle height"
    annotation (Dialog(group="Inputs"));
  input SI.Angle beta=Modelica.Units.Conversions.from_deg(  30) "Angle between center and hypotenuse"
    annotation (Dialog(group="Inputs"));
  extends PartialGeometry(
    final dimension=4*crossArea/perimeter,
    final crossArea=h*h*tan(beta),
    final perimeter=2*h*tan(beta)+2*h/cos(beta));
  SI.Length a = 2*h*tan(beta) "Base of triangle";
  SI.Length c = h/cos(beta) "Hypotenuse of triangle";
protected
   Real data_deg[8]=Modelica.Units.Conversions.from_deg(  {0,10,20,30,40,60,80,90});
   Real data_lam[size(data_deg, 1)]={0.75,0.81,0.82,0.83,0.82,0.80,0.75,0.78} "Re < 2000";
   Real data_turb[size(data_deg, 1)]={0.75,0.84,0.89,0.93,0.96,0.98,0.90,1.0};
equation
  ks[1] = Math.interpolate_wLimit(
     data_deg,
     data_lam,
     beta,
     useBound=true);
  ks[2] = Math.interpolate_wLimit(
     data_deg,
     data_turb,
     beta,
     useBound=true);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/Resistences_ Geometry_PipeLoss_Triangle.jpg\"/></p>
<p>Source: perimeter definition: Approximation 3 - https://www.mathsisfun.com/geometry/ellipse-perimeter.html</p>
</html>"));
end Triangle;
