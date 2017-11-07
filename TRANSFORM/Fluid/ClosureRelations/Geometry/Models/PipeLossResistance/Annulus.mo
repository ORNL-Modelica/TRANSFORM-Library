within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
model Annulus

  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 2.7 - Circular correction factor for stabilized flow - Concentric Annulus

  input SI.Length d0=0.01 "Small diameter"
    annotation (Dialog(group="Input Variables"));
  input SI.Length d1=0.02 "Large diameter"
    annotation (Dialog(group="Input Variables"));

  parameter Boolean use_e_abs=true
    "=true then use absolute eccentricity else relative";
  input SI.Length e_abs=0.0 "Absolute off-center distance"
    annotation (Dialog(group="Input Variables", enable=use_e_abs));
  input SIadd.nonDim e_rel(
    min=0.0,
    max=1.0) = 0.0 "Relative off-center distance, min = 0; max = 1.0"
    annotation (Dialog(group="Input Variables", enable=not use_e_abs));

  extends PartialGeometry(
    final dimension=4*crossArea/perimeter,
    final crossArea=0.25*Modelica.Constants.pi*(d1^2 - d0^2),
    final perimeter=Modelica.Constants.pi*(d1 + d0));

  SIadd.nonDim e_bar=if use_e_abs then 2*e_abs/(d1 - d0) else e_rel;
  Real R_d0d1=d0/d1 "Ratio of small/large (d0/d1) diameters";
protected
  Real data_R[11]={0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0};
  Real data_lam[size(data_R, 1)]={1.0,1.4,1.44,1.47,1.48,1.488,1.495,1.50,1.50,1.50,
      1.50} "Re < 2000";
  Real data_B[size(data_R, 1)]={0,0.65,0.90,1.10,1.22,1.30,1.39,1.43,1.45,1.47,1.48};
  Real B=Math.interpolate_wLimit(
      data_R,
      data_B,
      R_d0d1,
      useBound=true);
  Real CF_e_lam=1/(1 + B*e_bar)^2 "Laminar eccentricity correction factor";
  Real CF_e_turb=1 - 0.9*(1 - 2/3*e_bar)*e_bar^2
    "Laminar eccentricity correction factor";

equation

  ks[1] = CF_e_lam*Math.interpolate_wLimit(
    data_R,
    data_lam,
    R_d0d1,
    useBound=true);

  // Turbulent factor is taken from a regression of the average of Reynolds
  // values as a function of diameter ratios provided in the source table due to
  // the explicit equation depending on the friction factor which is a
  // difficult calculation and adds unnecessary computational burden.
  // This assumption is valid as the differences are small over large Re ranges.
  ks[2] = CF_e_turb*(1.065943 - 0.057142*(R_d0d1 - 1.0)^2);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/Resistences_ Geometry_PipeLoss_Annulus.jpg\"/></p>
<p>Source: perimeter definition: Approximation 3 - https://www.mathsisfun.com/geometry/ellipse-perimeter.html</p>
</html>"));
end Annulus;
