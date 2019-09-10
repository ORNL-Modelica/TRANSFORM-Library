within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes;
partial model PartialDrumType
  input Units.NonDim Vfrac_liquid
    "Fractional of total volume occupied by liquid";
  input SI.Volume V_liquid "Volume of liquid";
  input SI.Volume V_vapor "Volume of vapor";
  SI.Volume V_total "Total drum volume";
  SI.Height level "Measured fluid level";
  SI.Height level_vapor "Distance from fluid to top of vessel (i.e., vapor level)";
  Real Region "Liquid-Vapor surface location region identifier";
  SI.Area crossArea_liquid "Average liquid cross sectional area";
  SI.Area crossArea_vapor "Average vapor cross sectional area";
  SI.Area surfaceArea_Wall_total "Total inner wall surface area of drum";
  SI.Area surfaceArea_WL "Wall-Liquid surface area";
  SI.Area surfaceArea_WV "Wall-Vapor area";
  SI.Area surfaceArea_VL "Vapor-Liquid interfacial area";
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
      Documentation(info="<html>
<pre><span style=\"font-family: Courier New,courier; color: #006400;\">Calculations&nbsp;of&nbsp;liquid/vapor/metal&nbsp;volumes&nbsp;and&nbsp;surface&nbsp;areas</span>
<span style=\"font-family: Courier New,courier; color: #006400;\">The&nbsp;following&nbsp;references&nbsp;help&nbsp;describe&nbsp;the&nbsp;calculations</span>
<span style=\"font-family: Courier New,courier; color: #006400;\">-V_liquid:&nbsp;http://www.mathalino.com/reviewer/derivation-formulas/derivation-formula-volume-sphere-integration</span>
<span style=\"font-family: Courier New,courier; color: #006400;\">-surfaceArea_VL:&nbsp;http://tutorial.math.lamar.edu/Classes/CalcI/MoreVolume.aspx</span>
<span style=\"font-family: Courier New,courier; color: #006400;\">-surfaceArea_WL:&nbsp;https://en.wikipedia.org/wiki/Spherical_cap</span></pre>
</html>"));
end PartialDrumType;
