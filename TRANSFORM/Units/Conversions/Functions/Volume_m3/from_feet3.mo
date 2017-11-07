within TRANSFORM.Units.Conversions.Functions.Volume_m3;
function from_feet3 "Volume: [feet3] -> [m3]"
  extends BaseClasses.from;

algorithm
  y := u*12*0.0254*12*0.0254*12*0.0254;
end from_feet3;
