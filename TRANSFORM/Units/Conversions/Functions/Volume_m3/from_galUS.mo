within TRANSFORM.Units.Conversions.Functions.Volume_m3;
function from_galUS "Volume: [galUS] -> [m3]"
  extends BaseClasses.from;
algorithm
  y := u*0.00378541;
end from_galUS;
