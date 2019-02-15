within TRANSFORM.Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels;
model SquareSubChannel
  input SI.Length pitch = 2*rs_outer[end] + 0.01 "Distance between pin centers" annotation(Dialog(group="Inputs"));
  input SI.Length gap_PW = 0.5*pitch "Gap between pin center and wall" annotation(Dialog(group="Inputs",enable=if channelType=="Center" then false else true));
  extends
    TRANSFORM.Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Generic(
    final nPins = if channelType == "Center" then 1.0 elseif channelType == "Edge" then 0.5 else 0.25,
    final dimension = 4*crossArea/perimeter,
    final crossArea = crossArea_int,
    final perimeter = perimeter_int);
  parameter String channelType = "Center" "Flow channel type" annotation(choices(choice="Center",choice="Edge",choice="Corner"),Evaluate=true);
protected
  SI.Area crossArea_int;
  SI.Length perimeter_int;
equation
  if channelType == "Center" then
    //nPins = 1;
    crossArea_int = pitch^2 - pi*rs_outer[end]^2;
    perimeter_int = 2*pi*rs_outer[end];
  elseif channelType == "Edge" then
    //nPins = 0.5;
    crossArea_int = gap_PW*pitch - 0.5*pi*rs_outer[end]^2;
    perimeter_int = pitch + pi*rs_outer[end];
  elseif channelType == "Corner" then
    //nPins = 0.25;
    crossArea_int = gap_PW*gap_PW - 0.25*pi*rs_outer[end]^2;
    perimeter_int = 2*gap_PW + 0.5*pi*rs_outer[end];
  else
    assert(false,"Unknown channel type");
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SquareSubChannel;
