within TRANSFORM.Media.Solids.Examples;
model AlloyEnthalpy_FixedT
  "Enthalpy of the spline-based alloys at a fixed temperature"
  extends TRANSFORM.Icons.Example;
  package Mo = TRANSFORM.Media.Solids.Molybdenum;
  package W = TRANSFORM.Media.Solids.Tungsten;
  parameter SI.Temperature T = 1000 "Fixed temperature (a point of both cp tables)";
  // Expected, from the trapezoidal integral of each cp table from 1 K to 1000 K:
  // Mo 237265.10112 J/kg, W 126537.733635 J/kg. Before 1.2.0, Dymola returned 0 for
  // h_Mo, h_W and h_W_par without a warning. The baseline of unitTests.x checks the values;
  // an assert comparing them does not, because Dymola evaluated it with the right values.
  SI.SpecificEnthalpy h_Mo = Mo.specificEnthalpy(Mo.setState_T(T));
  SI.SpecificEnthalpy h_W = W.specificEnthalpy(W.setState_T(T));
  parameter SI.SpecificEnthalpy h_Mo_par = Mo.specificEnthalpy(Mo.setState_T(T));
  parameter SI.SpecificEnthalpy h_W_par = W.specificEnthalpy(W.setState_T(T));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={h_Mo,h_W,h_Mo_par,h_W_par})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AlloyEnthalpy_FixedT;
