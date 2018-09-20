within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger;
model CompactPlateHX

  input SI.Length height_tube=0.01 "Tube duct height"
    annotation (Dialog(group="Inputs"));
  input SI.Length height_shell=height_tube "Shell duct height"
    annotation (Dialog(group="Inputs"));
  input SI.Length width=0 "Duct width"
    annotation (Dialog(group="Inputs"));
  input SI.Length length=1.0 "Duct length"
    annotation (Dialog(group="Inputs"));

  extends StraightPipeHX(
    final nTubes=if plateStructure == "Tube-Shell-Tube" then 2
         elseif plateStructure == "Shell-Tube-Shell" then 1
         else 1,
    surfaceArea_tube={if i == 1 then (if plateStructure == "Tube-Shell-Tube" then width*
        length*(2*nTubes - 2)/nTubes elseif plateStructure == "Shell-Tube-Shell"
         then width*length*2 else width*length*(2*nTubes - 1)/nTubes) else 0 for i in 1:nSurfaces_tube},
    surfaceArea_shell={if i == 1 then (if plateStructure == "Shell-Tube-Shell" then width*
        length*(2*nShells - 2)/nShells elseif plateStructure == "Tube-Shell-Tube"
         then width*length*2 else width*length*(2*nShells - 1)/nShells) else 0 for i in 1:nSurfaces_shell},
    final dimension_tube=4*crossArea_tube/perimeter_tube,
    final crossArea_tube=width*height_tube,
    final perimeter_tube=2*width + 2*height_tube,
    final length_tube=length,
    final dimension_shell=4*crossArea_shell/perimeter_shell,
    final crossArea_shell=width*height_shell,
    final perimeter_shell=2*width + 2*height_shell,
    final length_shell=length);

  parameter String plateStructure="Tube-Shell" annotation (choices(
      choice="Tube-Shell-Tube",
      choice="Tube-Shell",
      choice="Shell-Tube-Shell"));
//   parameter Real nChannels(min=2) = 2
//     "# of overall channels (i.e., tube and shell)";

  final parameter Real nShells=if plateStructure == "Tube-Shell-Tube" then
      nTubes - 1 elseif plateStructure == "Shell-Tube-Shell" then nTubes + 1
       else nTubes "# of shell channels";

//   extends PartialHeatExchanger(
//     final nTubes=if plateStructure == "Tube-Shell-Tube" then ceil(nChannels/2)
//          elseif plateStructure == "Shell-Tube-Shell" then floor(nChannels/2)
//          else nChannels/2,
//     surfaceArea_tubeSide=if plateStructure == "Tube-Shell-Tube" then width*
//         length*(2*nTubes - 2)/nTubes elseif plateStructure == "Shell-Tube-Shell"
//          then width*length*2 else width*length*(2*nTubes - 1)/nTubes,
//     surfaceArea_shellSide=if plateStructure == "Shell-Tube-Shell" then width*
//         length*(2*nShells - 2)/nShells elseif plateStructure == "Tube-Shell-Tube"
//          then width*length*2 else width*length*(2*nShells - 1)/nShells,
//     final use_Dimension_tube=false,
//     final dimension_tube=4*crossArea_tube/perimeter_tube,
//     final crossArea_tube=width*height_tube,
//     final perimeter_tube=2*width + 2*height_tube,
//     final length_tube=length,
//     final use_Dimension_shell=false,
//     final dimension_shell=4*crossArea_shell/perimeter_shell,
//     final crossArea_shell=width*height_shell,
//     final perimeter_shell=2*width + 2*height_shell,
//     final length_shell=length);
//
//   final parameter Real nShells=if plateStructure == "Tube-Shell-Tube" then
//       nTubes - 1 elseif plateStructure == "Shell-Tube-Shell" then nTubes + 1
//        else nTubes "# of shell channels";
//
// equation
//   if plateStructure == "Tube-Shell-Tube" or plateStructure == "Shell-Tube-Shell"
//        then
//     assert(nChannels > 2, "For plateStructure='Tube-Shell-Tube' or 'Shell-Tube-Shell' , nChannels must be > 2");
//   elseif plateStructure == "Tube-Shell" then
//     assert(rem(nChannels, 2) == 0, "For plateStructure='Tube-Shell', rem(nChannels,2) must be zero");
//   end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CompactPlateHX;
