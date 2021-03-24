within TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s;
function from_ft3_min "Volume Flow Rate: [ft^3/min] -> [m^3/s]"
  extends BaseClasses.from;
algorithm
    y := u*12*0.0254*12*0.0254*12*0.0254/60;
end from_ft3_min;
