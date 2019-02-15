within TRANSFORM.Math.Interpolation.Models;
block Interpolation_2D
  extends Modelica.Blocks.Interfaces.SI2SO;

  parameter String tablePath_u1="";
  parameter String tablePath_u2="";
  parameter String tablePath_y="";

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
