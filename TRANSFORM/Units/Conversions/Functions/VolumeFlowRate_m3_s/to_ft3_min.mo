within TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s;
function to_ft3_min "Volume Flow Rate: [m^3/s] -> [ft^3/min]"
  extends BaseClasses.from;
algorithm
    y := u/(12*0.0254*12*0.0254*12*0.0254)*60;
end to_ft3_min;
