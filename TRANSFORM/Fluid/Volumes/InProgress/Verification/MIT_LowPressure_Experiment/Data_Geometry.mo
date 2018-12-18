within TRANSFORM.Fluid.Volumes.InProgress.Verification.MIT_LowPressure_Experiment;
record Data_Geometry
  extends Icons.Record;

  constant SI.Length mainTank_d_inner=
      Units.Conversions.Functions.Distance_m.from_in(7.625)
    "Inner diameter of the main (primary) tank";
  constant SI.Length mainTank_d_outer=
      Units.Conversions.Functions.Distance_m.from_in(8.625)
    "Outer diameter of the main (primary) tank";
  constant SI.Length mainTank_th = 0.5*(mainTank_d_outer - mainTank_d_inner) "Wall thickness of thee main (primary) tank";
  constant SI.Length mainTank_height=
      Units.Conversions.Functions.Distance_m.from_in(45)
    "Internal height of the main (primary) tank";
  constant SI.Volume mainTank_V = mainTank_height*0.25*pi*mainTank_d_inner^2 "Empty volume of the main (primary) tank (excludes ~negligible port/level indicator volumes)";
  constant SI.Volume wall_V = 0.25*pi*(mainTank_d_outer^2 - mainTank_d_inner^2)*mainTank_height "Wall volume";
  annotation (defaultComponentName="data",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Data_Geometry;
