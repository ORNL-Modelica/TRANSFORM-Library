within TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s;
function from_gpm "Volume Flow Rate: [gpm](US) -> [m^3/s]"

  extends BaseClasses.from;

algorithm
  y := u/(264.172052*60);
end from_gpm;
