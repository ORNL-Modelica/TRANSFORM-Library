within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume;
model PlateHX "Plate HX"
  import Modelica.Utilities.Strings.isEqual;
  parameter SI.Length H "Plate gap height" annotation(Dialog(group="General"));
  parameter SI.Length W "Plate width" annotation(Dialog(group="General"));
  parameter SI.Length L "Plate length" annotation(Dialog(group="General"));
  parameter Real nAreas_NoHT = 0 "Number of areas (e.g., top and bottom = 2) not participating in heat transfer" annotation(Dialog(group="General"));
  final parameter SI.Area crossAreap = H*W "Single plate cross sectional flow area";
  final parameter SI.Length perimeterp = 2*H + 2*W "Single plate wetted perimeter";
  final parameter SI.Area surfaceAreap = L*W*(2*nParallel-nAreas_NoHT)/nParallel "Single plate heat transfer area corrected with non participating heat transfer areas";
  extends TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.StraightPipe(
    final length=L,
    final use_Dimension=false,
    final dimension=4*crossAreap/perimeterp,
    final crossArea=crossAreap,
    final perimeter=perimeterp,
    final surfaceArea=surfaceAreap);
  annotation (defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PlateHX;
