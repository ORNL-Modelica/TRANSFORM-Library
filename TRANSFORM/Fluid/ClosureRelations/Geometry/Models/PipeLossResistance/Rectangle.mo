within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
model Rectangle
  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 2.6 - Non-circular correction factor for stabilized flow - Rectangle
  input SI.Length a0=0.02 "Major dimension"
    annotation (Dialog(group="Inputs"));
  input SI.Length b0=0.01 "Minor dimension"
    annotation (Dialog(group="Inputs"));
  extends PartialGeometry(
    final dimension=4*crossArea/perimeter,
    final crossArea=a0*b0,
    final perimeter=2*a0 + 2*b0);
  Real R_a0b0=a0/b0 "Ratio of major/minor dimension";
protected
  Real data_R[7]={0,0.1,0.2,0.4,0.6,0.8,1.0};
  Real data_lam[size(data_R, 1)]={1.50,1.34,1.20,1.02,0.94,0.90,0.89} "Re < 2000";
  Real data_turb[size(data_R, 1)]={1.10,1.08,1.06,1.04,1.02,1.01,1.0} "Re > 2000";
equation
  ks[1] = Math.interpolate_wLimit(
    data_R,
    data_lam,
    R_a0b0,
    useBound=true);
  ks[2] = Math.interpolate_wLimit(
    data_R,
    data_turb,
    R_a0b0,
    useBound=true);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/Resistences_ Geometry_PipeLoss_Rectangle.jpg\"/></p>
</html>"));
end Rectangle;
