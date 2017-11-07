within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel;
partial model GenericVolume
//
//    input Units.nonDim Vfrac_liquid
//      "Fractional of total volume occupied by liquid"  annotation (Dialog(group="Input Variables"));
  //input SI.Volume V = V_liquid + V_vapor "Volume" annotation (Dialog(group="Input Variables"));
  input SI.Volume V_liquid "Volume" annotation (Dialog(group="Input Variables"));
  SI.Volume V_vapor "Volume" annotation (Dialog(group="Input Variables"));

  // Elevation
//   input SI.Angle angle(min=-Modelica.Constants.pi/2-0.01,max=Modelica.Constants.pi/2+0.01)=0.0 "Vertical angle from the horizontal (-pi/2 <= x <= pi/2)"
//     annotation (Dialog(group="Input Variables: Elevation"));
//   input SI.Length dheight=0*sin(angle)  "Height(port_b) - Height(port_a)"
//     annotation (Dialog(group="Input Variables: Elevation"));
//   input SI.Length height_a=0
//     "Elevation at port_a: Reference value only. No impact on calculations."
//     annotation (Dialog(group="Input Variables: Elevation"));
//   output SI.Length height_b=height_a + dheight
//     "Elevation at port_b: Reference value only. No impact on calculations."
//     annotation (Dialog(group="Input Variables: Elevation", enable=false));

  SI.Volume V = V_liquid + V_vapor "Volume" annotation (Dialog(group="Input Variables"));

  SI.Height level "Measured fluid level";
  //SI.Height level_vapor "Distance from fluid to top of vessel (i.e., vapor level)";

//   Real Region "Liquid-Vapor surface location region identifier";

//   SI.Area crossArea_liquid "Average liquid cross sectional area";
//   SI.Area crossArea_vapor "Average vapor cross sectional area";

  SI.Area surfaceArea_Wall_total "Total inner wall surface area of drum";
  SI.Area surfaceArea_WL "Wall-Liquid surface area";
  SI.Area surfaceArea_WV "Wall-Vapor area";
  SI.Area surfaceArea_VL "Vapor-Liquid interfacial area";
  SI.Area surfaceArea_WE "Wall-Exterior surface area";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericVolume;
