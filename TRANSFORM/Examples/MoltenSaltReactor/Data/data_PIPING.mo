within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_PIPING
  extends Icons.Record;

  import TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s.from_gpm;
  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_feet;
  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch;

  // Assume distance for all looops is the same. Assume out of allignmnent is negligble and ignore elbows
  // Pump is at same elevation as PHX

  parameter SI.Length length_pumpToPHX = from_inch(240) "Distance from pump outlet to PHX inlet";
  parameter SI.Length length_PHXToRCTR = from_inch(684) "Distance from PHX outlet to inlet reactor tee";
  parameter SI.Length height_pumpToPHX = 0 "Elevation difference (pump - PHX)";
  parameter SI.Length height_PHXToRCTR = from_inch(324) "Elevation difference (PHX - RCTR)";

  parameter SI.Length D_PFL = from_inch(12) "Diameter of PFL piping";

  // Distances in primary coolant loop are taken as rough guesses based on the assumption
  // that the steam generator/SHX are in the same building as the PHX as in the MSBR. Very rough guesses.
  parameter SI.Length length_pumpToSHX = from_inch(96) "Distance from pump outlet to SHX inlet";
  parameter SI.Length length_SHXToPHX = from_inch(252) "Distance from SHX outlet to PHX inlet";
  parameter SI.Length length_PHXsToPump = from_inch(180) "Distance from PHX shell outlet to PCL pump";
  parameter SI.Length height_pumpToSHX = -from_inch(45) "Elevation difference (SHX - pump)";
  parameter SI.Length height_SHXToPHX = -from_inch(83) "Elevation difference (PHX - SHX)";
  parameter SI.Length height_SHXToPump = from_inch(42) "Elevation difference (SHX - PHX)";

  parameter SI.Length D_SFL = from_inch(12) "Diameter of SFL piping";

end data_PIPING;
