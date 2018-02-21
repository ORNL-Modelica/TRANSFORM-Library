within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
partial model PartialGeometry

  input SI.Length dimension=0.01
    "Characteristic dimension (e.g., hydraulic diameter)" annotation (Dialog(group="Input Variables"));
  input SI.Area crossArea=0.25*Modelica.Constants.pi*dimension*dimension
    "Cross-sectional area" annotation (Dialog(group="Input Variables"));
  input SI.Length perimeter=Modelica.Constants.pi*dimension "Wetted perimeter" annotation (Dialog(group="Input Variables"));

  input SI.Length dlength=1.0 "Pipe length"
    annotation (Dialog(group="Input Variables"));
  input SI.Angle angle(min=-Modelica.Constants.pi/2-0.01,max=Modelica.Constants.pi/2+0.01)=0.0 "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
    annotation (Dialog(group="Input Variables: Elevation"));
  input SI.Length dheight= dlength*sin(angle)
    "Height change (port_b - port_a)"
    annotation (Dialog(group="Input Variables: Elevation"));
  input SI.Height roughness=2.5e-5 "Average height of surface asperities"
    annotation (Dialog(group="Input Variables"));

  Units.NonDim ks[2] "Geometric correction coefficients: {laminar, turbulent}";

  annotation (defaultComponentName="geometry",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialGeometry;
