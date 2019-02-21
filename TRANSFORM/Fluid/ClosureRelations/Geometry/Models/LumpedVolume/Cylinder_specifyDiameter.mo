within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume;
model Cylinder_specifyDiameter
  import Modelica.Constants.pi;
  input SI.Length length = 1.0 "Cylinder length" annotation (Dialog(group="Inputs"));
  input SI.Length dimension = 0.0 "Hydraulic diameter" annotation (Dialog(group="Inputs"));
  SI.Area crossArea = 0.25*pi*dimension^2 "Cross sectional area";
  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume(
     final V=crossArea*length, dheight=length*sin(angle));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cylinder_specifyDiameter;
