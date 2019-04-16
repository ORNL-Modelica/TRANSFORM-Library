within TRANSFORM.Math.Interpolation.Models;
block Interpolation_2D
  extends Modelica.Blocks.Interfaces.SI2SO;
  parameter String tablePath_u1="" annotation (Dialog(
        loadSelector(filter="All files (*.*);;CSV files (*.csv)", caption="Open data file")));
  parameter String tablePath_u2="" annotation (Dialog(
        loadSelector(filter="All files (*.*);;CSV files (*.csv)", caption="Open data file")));
  parameter String tablePath_y="" annotation (Dialog(
        loadSelector(filter="All files (*.*);;CSV files (*.csv)", caption="Open data file")));
  final parameter String tablesPath=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_u1,tablePath_u2,tablePath_y},
      "|",
      3);
  replaceable function Method =
      TRANSFORM.Math.Interpolation.Bicubic.bicubic_eval
    constrainedby TRANSFORM.Math.Interpolation.PartialInterpolation
                                                                  annotation (
      choicesAllMatching=true);
equation
  y = Method(
    tablesPath,
    u1,
    u2);
  annotation (defaultcomponentName="interpolate");
end Interpolation_2D;
