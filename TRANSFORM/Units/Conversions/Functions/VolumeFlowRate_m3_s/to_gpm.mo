within TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s;
function to_gpm "Volume Flow Rate: [m^3/s] -> [gpm](US)"

  extends BaseClasses.to;

algorithm
  y := u*(264.172052*60);
end to_gpm;
