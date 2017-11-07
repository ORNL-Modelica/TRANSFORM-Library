within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel;
model Cylinder

  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.GenericVolume(
      V_liquid(start=pi*r_inner^2*length/2),
      V_vapor(start=pi*r_inner^2*length/2),
      level(min=level_min,max=level_max));

  parameter SI.Length r_inner=0 "Internal radius"
    annotation (Dialog(group="Geometry"));
   parameter SI.Length r_outer=0 "External radius"
     annotation (Dialog(group="Geometry"));
  parameter SI.Length length=0 "Length" annotation (Dialog(group="Geometry"));
  parameter Integer DrumOrientation=0 "0: Horizontal; 1: Vertical"
    annotation (Dialog(group="Geometry"));
   final parameter SI.Length level_max=if DrumOrientation == 0 then r_inner
        else length/2 "Maximum possible level (relative to the centerline)";
   final parameter SI.Length level_min=if DrumOrientation == 0 then -r_inner
        else -length/2 "Minimum possible level (relative to the centerline)";
equation

   assert(DrumOrientation == 0 and level > -r_inner or DrumOrientation == 1 and
     level > -length/2, "Empty boiler drum: liquid level is too low.");
   assert(V_vapor > 0, "Full boiler drum:liquid level is too high");

  if DrumOrientation == 0 then
    V_liquid =length*(r_inner^2*acos(-level/r_inner) + level*sqrt(r_inner^2 -
      level^2))
      "Liquid volume";
    surfaceArea_WL = 2*V_liquid/length + 2*r_inner*acos(-level/r_inner)*length
      "Metal-liquid interface area";
    surfaceArea_VL = 2*sqrt(r_inner^2 - level^2)*length
      "Liquid-vapor interface area";
  else
    V_liquid =pi*r_inner^2*(level + length/2)
                                       "Liquid volume";
    surfaceArea_WL = pi*r_inner^2 + 2*pi*r_inner*(level + length/2)
      "Metal-liquid interface area";
    surfaceArea_VL = pi*r_inner^2 "Liquid-vapor interface area";
  end if;
  V_vapor =pi*r_inner^2*length - V_liquid
                                   "vapor volume";
  surfaceArea_WV = 2*pi*r_inner*length + 2*pi*r_inner^2 - surfaceArea_WL
    "Metal-vapor interface area";

  surfaceArea_Wall_total = 4*pi*r_inner^2 + 2*pi*r_inner*length;
  surfaceArea_WE = 2*pi*r_outer^2 + 2*pi*r_outer*length "External metal surface area"; // not sure if this is right: 4 pi

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cylinder;
