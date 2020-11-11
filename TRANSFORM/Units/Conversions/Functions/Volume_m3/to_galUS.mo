within TRANSFORM.Units.Conversions.Functions.Volume_m3;
function to_galUS "Volume: [m3] -> [galUS]"
  extends BaseClasses.to;
algorithm
  y := u/(0.00378541);
end to_galUS;
