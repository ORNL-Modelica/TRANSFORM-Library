within TRANSFORM.Units.Conversions.Functions.Volume_m3;
function to_ft3 "Volume: [m3] -> [ft3]"
  extends BaseClasses.to;
algorithm
  y := u/(12*0.0254*12*0.0254*12*0.0254);
end to_ft3;
