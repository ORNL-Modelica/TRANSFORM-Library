within TRANSFORM.Fluid.Volumes.InProgress.Verification.ThreeMileIsland_Unit2_PressurizerTransients;
model Data_Geometry
  extends Icons.Record;
  constant SI.Height height_overall=
      Units.Conversions.Functions.Distance_m.from_in(44*12 + 11.75)
    "Inner diameter of the pressurizer";
  constant SI.Length d_outer=Units.Conversions.Functions.Distance_m.from_in(
      96.375) "Outer diameter of the pressurizer";
  constant SI.Volume V_total=Units.Conversions.Functions.Volume_m3.from_ft3(570
       + 930) "Total inner volume of pressurizer";
  constant SI.Length th_wall=Units.Conversions.Functions.Distance_m.from_in(
      6.188) "Wall thickness of the pressurizer";
  // Assume from drawings that d_inner is constant in both the bottom and top hemispherical sections and cylindrical middle section.
  constant SI.Length d_inner = d_outer - 2*th_wall "Inner diameter";
  constant SI.Length r_inner = 0.5*d_inner "Inner radius";
  constant SI.Length r_outer = 0.5*d_outer "Outer radius";
  constant SI.Height height_inner = (V_total - 4/3*pi*r_inner^3)/(pi*r_inner^2) "Inner height";
  annotation (defaultComponentName="data",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Data_Geometry;
