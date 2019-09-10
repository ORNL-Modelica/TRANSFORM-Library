within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger;
model PrintedCircuitHX
  // wall thickness is based of squishing the channels to rectangles and then
  // taking the average of the remaining heights
  input SI.Length length=1.0 "HX length"
    annotation (Dialog(group="Inputs"));
  input SI.Length th_tube=0.01 "Tube duct thickness"
    annotation (Dialog(group="Inputs"));
  input SI.Length th_shell=th_tube "Shell duct thickness"
    annotation (Dialog(group="Inputs"));
    input SI.Length r_tube=th_tube/2 "Radius of tube channel" annotation (Dialog(group="Inputs"));
    input SI.Length r_shell=th_shell/2 "Radius of shell channels" annotation (Dialog(group="Inputs"));
    input SI.Length pitch_tube = 2*r_tube "Distance between tube channels" annotation (Dialog(group="Inputs"));
    input SI.Length pitch_shell = 2*r_shell "Distance between shell channels" annotation (Dialog(group="Inputs"));
  extends StraightPipeHX(
    final nTubes=if plateStructure == "Tube-Shell-Tube" then 2
         elseif plateStructure == "Shell-Tube-Shell" then 1
         else 1,
    surfaceArea_tube={if i == 1 then (if plateStructure == "Tube-Shell-Tube" then perimeter_tube*
        length*(2*nTubes - 2)/nTubes elseif plateStructure == "Shell-Tube-Shell"
         then perimeter_tube*length*2 else perimeter_tube*length*(2*nTubes - 1)/nTubes) else 0 for i in 1:nSurfaces_tube},
    surfaceArea_shell={if i == 1 then (if plateStructure == "Shell-Tube-Shell" then perimeter_shell*
        length*(2*nShells - 2)/nShells elseif plateStructure == "Tube-Shell-Tube"
         then perimeter_shell*length*2 else perimeter_shell*length*(2*nShells - 1)/nShells) else 0 for i in 1:nSurfaces_shell},
    final dimension_tube=4*crossArea_tube/perimeter_tube,
    final crossArea_tube=0.5*Modelica.Constants.pi*r_tube^2,
    final perimeter_tube=(2*r_tube+Modelica.Constants.pi*r_tube),
    final length_tube=length,
    final dimension_shell=4*crossArea_shell/perimeter_shell,
    final crossArea_shell=0.5*Modelica.Constants.pi*r_shell^2,
    final perimeter_shell=(2*r_shell+Modelica.Constants.pi*r_shell),
    final length_shell=length,
    final th_wall=CF_th_wall*0.5*((th_tube - 0.5*Modelica.Constants.pi*r_tube^2/pitch_tube) + (th_shell - 0.5*Modelica.Constants.pi*r_shell^2/pitch_shell)),
    final drs=fill(th_wall/nR,nR,nV));
  parameter String plateStructure="Tube-Shell" annotation (choices(
      choice="Tube-Shell-Tube",
      choice="Tube-Shell",
      choice="Shell-Tube-Shell"));
  parameter SIadd.NonDim CF_th_wall = 1.0 "Correction factor for scaling tube thickness";
  final parameter Real nShells=if plateStructure == "Tube-Shell-Tube" then
      nTubes - 1 elseif plateStructure == "Shell-Tube-Shell" then nTubes + 1
       else nTubes "# of shell channels";
equation
  assert(pitch_tube >= 2*r_tube,"PlateCircuitHX pitch_tube is < r_tube");
  assert(pitch_shell >= 2*r_shell,"PlateCircuitHX pitch_shell is < r_shell");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/Geometry_PrintedCircuitHX.jpg\"/></p>
</html>"));
end PrintedCircuitHX;
