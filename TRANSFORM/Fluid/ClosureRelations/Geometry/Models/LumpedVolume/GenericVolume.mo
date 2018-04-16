within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume;
model GenericVolume

  input SI.Volume V = 0.0 "Volume" annotation (Dialog(group="Inputs"));

  // Elevation
  input SI.Angle angle(min=-Modelica.Constants.pi/2-0.01,max=Modelica.Constants.pi/2+0.01)=0.0 "Vertical angle from the horizontal (-pi/2 <= x <= pi/2)"
    annotation (Dialog(group="Inputs Elevation"));
  input SI.Length dheight=0*sin(angle)  "Height(port_b) - Height(port_a)"
    annotation (Dialog(group="Inputs Elevation"));
  input SI.Length height_a=0
    "Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(group="Inputs Elevation"));
  output SI.Length height_b=height_a + dheight
    "Elevation at port_b: Reference value only. No impact on calculations."
    annotation (Dialog(group="Inputs Elevation", enable=false));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericVolume;
