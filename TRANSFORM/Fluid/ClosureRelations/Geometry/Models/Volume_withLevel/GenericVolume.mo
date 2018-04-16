within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.Volume_withLevel;
partial model GenericVolume

//   Real Region "Liquid-Vapor surface location region identifier";
//   SI.Area crossArea_liquid "Average liquid cross sectional area";
//   SI.Area crossArea_vapor "Average vapor cross sectional area";

  input SI.Volume V_liquid "Volume" annotation (Dialog(tab="Internal Interface",group="Inputs"));
  SI.Volume V "Total volume";
  SI.Volume V_wall "Wall volume";

  parameter SI.Length level_0(min=0) = 0 "Location of zero level for level_meas" annotation(Dialog(group="Parameters: Zero-level control"));
  parameter SI.Length level_meas_min "Minimum level" annotation(Dialog(group="Parameters: Zero-level control"));
  parameter SI.Length level_meas_max "Maximum level" annotation(Dialog(group="Parameters: Zero-level control"));

  SI.Length level "Liquid level";
  SI.Height level_meas = level - level_0 "Measured fluid level (level - level_0)";
  Units.NonDim level_meas_percentage = 100*(level_meas - level_meas_min)/(level_meas_max - level_meas_min) "Percentage full based on max/min level";

  SI.Area surfaceArea_WL "Wall-Liquid surface area";
  SI.Area surfaceArea_VL "Vapor-Liquid interfacial area";
  SI.Area surfaceArea "Internal wall transfer area";
  SI.Area surfaceArea_outer "Outer wall transfer area";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericVolume;
