within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
model Trapezoid
  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 2.6 - Non-circular correction factor for stabilized flow - Trapezoid
  input SI.Length a1=0.01 "Small parallel dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length a2=0.02 "Large parallel dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length h=0.01 "Distance between a1 and a2"
    annotation (Dialog(group="Inputs"));
  input SI.Angle theta1=Modelica.Constants.pi/3 "Angle formed by a2 and side 1"
    annotation (Dialog(group="Inputs"));
  input SI.Angle theta2=Modelica.Constants.pi/3 "Angle formed by a2 and side 2"
    annotation (Dialog(group="Inputs"));
  extends PartialGeometry(
    final dimension=4*crossArea/perimeter,
    final crossArea=0.5*h*(a1+a2),
    final perimeter=a1+a2+h*(1/sin(theta1)+1/sin(theta2)));
  Real R_ah=0.5*(a1+a2)/h "Ratio of parallel sides/height";
protected
  Real data_R[7]={0,0.1,0.2,0.4,0.6,0.8,1.0};
  Real data_lam[size(data_R, 1)]={1.50,1.34,1.20,1.02,0.94,0.90,0.89} "Re < 2000";
  Real data_turb[size(data_R, 1)]={1.10,1.08,1.06,1.04,1.02,1.01,1.0} "Re > 2000";
equation
  ks[1] = Math.interpolate_wLimit(
    data_R,
    data_lam,
    R_ah,
    useBound=true);
  ks[2] = Math.interpolate_wLimit(
    data_R,
    data_turb,
    R_ah,
    useBound=true);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/Resistences_ Geometry_PipeLoss_Trapezoid.jpg\"/></p>
</html>"));
end Trapezoid;
