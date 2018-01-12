within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_PUMP
  extends Icons.Record;

  import TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s.from_gpm;
  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_feet;
  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch;

  parameter SI.VolumeFlowRate capacity_P = from_gpm(8100) "Capacity of primary pump";
  parameter SI.Height head_P = from_feet(150) "Head at capacity of primary pump";
  parameter Real bypass_P = 0.1 "%Fraction of nominal flow bypassed from pump outlet to inlet to purge offgas";

  // Assume secondary pumps are the same as primary pumps.

end data_PUMP;
