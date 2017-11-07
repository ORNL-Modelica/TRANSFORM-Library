within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
model CircleSector

  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 2.8 - Circular correction factor for stabilized flow - Triangular

  // The three triangles have been condensed to 1 implementation due to the
  // relatively small variation between the three

  input SI.Length r0=0.01 "Sector radius"
    annotation (Dialog(group="Input Variables"));
  input SI.Angle theta=Modelica.SIunits.Conversions.from_deg(30) "Sector angle"
    annotation (Dialog(group="Input Variables"));

  extends PartialGeometry(
    final dimension=4*crossArea/perimeter,
    final crossArea=0.5*r0*r0*theta,
    final perimeter=2*r0 + r0*theta);

    SI.Angle beta = 0.5*theta "Sector half-angle";
protected
   Real data_deg[8]=Modelica.SIunits.Conversions.from_deg({0,10,20,30,40,60,80,90});
   Real data_lam[size(data_deg, 1)]={0.75,0.82,0.86,0.89,0.92,0.95,0.98,1.0} "Re < 2000";
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
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/Resistences_ Geometry_PipeLoss_CircleSector.jpg\"/></p>
<p>Source: perimeter definition: Approximation 3 - https://www.mathsisfun.com/geometry/ellipse-perimeter.html</p>
</html>"));
end CircleSector;
