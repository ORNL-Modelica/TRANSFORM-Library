within TRANSFORM.Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels;
model Generic
  import Modelica.Constants.pi;
  parameter Integer nRegions = 1 "# of regions in solid media" annotation(Dialog(tab="Internal Interface"));
  parameter Integer nV=4 "# of discrete axial volumes";
  parameter Integer nSurfaces=1 "Number of transfer (heat/mass) surfaces for coolant channel";
  parameter Real nPins = 1 "# of solid media pins";
  parameter Real nPins_nonFuel = 0 "# of pins non-fueled pins (e.g., control rod guides)";
  parameter Integer nRs[nRegions]=fill(3,nRegions) "# nodes in each region's radial direction";
  input SI.Length dimension = 4*crossArea/perimeter "Characteristic dimension (e.g., hydraulic diameter)" annotation(Dialog(group="Inputs"));
  input SI.Area crossArea = pi*dimension*dimension/4 "Cross-sectional flow areas" annotation(Dialog(group="Inputs"));
  input SI.Length perimeter=4*crossArea/dimension "Wetted perimeters" annotation(Dialog(group="Inputs"));
  input SI.Length length = 1.0 "Pipe length" annotation(Dialog(group="Inputs"));
  input SI.Height roughness = 2.5e-5 "Average heights of surface asperities" annotation(Dialog(group="Inputs"));
  input SI.Area surfaceArea[nSurfaces]={2*pi*rs_outer[end]*length*nPins}
    "Area per transfer surface" annotation (Dialog(group="Inputs"));
  // Static head
  input SI.Angle angle=0.0 "Vertical angle from the horizontal (-pi/2 < x <= pi/2)"
    annotation (Dialog(group="Inputs Elevation"));
  input SI.Length dheight= length*sin(angle)
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(group="Inputs Elevation"));
  input SI.Length height_a=0
    "Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(group="Inputs Elevation"));
  input SI.Length rs_outer[nRegions]={if i == 1 then 0.01 else rs_outer[i-1] + 0.001 for i in 1:nRegions} "Outer radius of each region {r_outer[1],...,r_outer[n]}"
    annotation (Dialog(group="Inputs Solid Media"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Generic;
