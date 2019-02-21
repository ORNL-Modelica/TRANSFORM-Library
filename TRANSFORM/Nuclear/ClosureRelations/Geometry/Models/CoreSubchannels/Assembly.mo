within TRANSFORM.Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels;
model Assembly
  input SI.Length width_FtoF_inner = 0.1 "Inner flat to flat distance" annotation(Dialog(group="Inputs"));
  input SI.Length D_wireWrap = 0 "Wire wrap diameter" annotation(Dialog(group="Inputs"));
  extends
    TRANSFORM.Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Generic(
  final dimension = 4*crossArea/perimeter,
  final crossArea = crossArea_empty - pi*rs_outer[end]^2*(nPins+nPins_nonFuel) - 0.25*pi*D_wireWrap^2*nPins,
  final perimeter = perimeter_empty + 2*pi*rs_outer[end]*(nPins+nPins_nonFuel) + pi*D_wireWrap*nPins,
  surfaceArea={2*pi*rs_outer[end]*length*nPins});
  parameter String assemblyType = "Square" "Assembly type" annotation(choices(choice="Square",choice="Hexagonal"),Evaluate=true);
protected
  SI.Area crossArea_empty;
  SI.Length perimeter_empty;
equation
  if assemblyType == "Square" then
    crossArea_empty = width_FtoF_inner^2;
    perimeter_empty = 4*width_FtoF_inner;
  elseif assemblyType == "Hexagonal" then
    crossArea_empty = 0.5*3*sqrt(3)*(width_FtoF_inner/sqrt(3))^2;
    perimeter_empty = 6*(width_FtoF_inner/sqrt(3));
  else
    assert(false,"Unknown channel type");
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Assembly;
