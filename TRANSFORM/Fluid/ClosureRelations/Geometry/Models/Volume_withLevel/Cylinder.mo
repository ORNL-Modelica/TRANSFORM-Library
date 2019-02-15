within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.Volume_withLevel;
model Cylinder
  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.Volume_withLevel.GenericVolume(
    V_liquid(start=pi*r_inner^2*length/2),
    level_0=if orientation == "Vertical" then length/2 else r_inner,
    level_meas_min=-level_0,
    level_meas_max=level_0);
  parameter String orientation="Vertical" "Orientation of volume" annotation(choices(choice="Vertical",choice="Horizontal"));
  parameter SI.Length length=0 "Length";
  parameter SI.Length r_inner=1 "Internal radius";
  parameter SI.Length th_wall=0 "Wall thickness";
  final parameter SI.Length r_outer = r_inner + th_wall "Outer radius of cylinder";
equation
   assert(level_meas > level_meas_min, "Empty cylinder: liquid measured level is too low.");
  V = pi*r_inner^2*length;
  surfaceArea = 2*pi*r_inner*length + 2*pi*r_inner^2;
  if orientation == "Vertical" then
    V =pi*r_inner^2*level;
    surfaceArea_WL = 2*pi*r_inner*level + pi*r_inner^2;
    surfaceArea_VL = pi*r_inner^2;
  elseif orientation == "Horizontal" then
    V = length*(r_inner^2*acos((r_inner-level)/r_inner) - (r_inner-level)*sqrt(level*(2*r_inner-level)));
    surfaceArea_WL = 2*V/length + noEvent(if level<=r_inner then 2*r_inner*acos((r_inner-level)/r_inner) else 2*r_inner*(pi - acos((level-r_inner)/r_inner)))*length;
    surfaceArea_VL = 2*sqrt(r_inner^2-abs(r_inner-level)^2)*length;
  else
    assert(false,"Unknown cylinder orientation");
  end if;
  V_wall = pi*(r_outer^2-r_inner^2)*length + 2*pi*r_outer^2*th_wall;
  surfaceArea_outer = 2*pi*r_outer*length + 2*pi*r_outer^2;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cylinder;
