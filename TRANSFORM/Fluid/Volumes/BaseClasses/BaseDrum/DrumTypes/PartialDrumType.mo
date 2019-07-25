within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.DrumTypes;
partial model PartialDrumType
  input TRANSFORM.Units.NonDim Vfrac_liquid
    "Fractional of total volume occupied by liquid";
  input SI.Volume V_liquid "Volume of liquid";
  input SI.Volume V_vapor "Volume of vapor";
  SI.Volume V_total "Total pressurizer volume";
  SI.Height level "Measured fluid level";
  Real Region "Liquid-Vapor surface location region identifier";
  SI.Area A_surfaceWTotal "Total inner wall surface area of pressurizer";
  SI.Area A_surfaceWL "Wall-Liquid interfacial area";
  SI.Area A_surfaceWV "Wall-Vapor interfacial area";
  SI.Area A_surfaceVL "Vapor-Liquid interfacial area";
  parameter SI.Volume V_total_parameter = 1 "Needs to be re-set by extending class";
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
      Documentation(info="<html>
<pre><span style=\"font-family: Courier New,courier; color: #006400;\">Calculations&nbsp;of&nbsp;liquid/vapor/metal&nbsp;volumes&nbsp;and&nbsp;surface&nbsp;areas</span>
<span style=\"font-family: Courier New,courier; color: #006400;\">The&nbsp;following&nbsp;references&nbsp;help&nbsp;describe&nbsp;the&nbsp;calculations</span>
<span style=\"font-family: Courier New,courier; color: #006400;\">-V_liquid:&nbsp;http://www.mathalino.com/reviewer/derivation-formulas/derivation-formula-volume-sphere-integration</span>
<span style=\"font-family: Courier New,courier; color: #006400;\">-A_surfaceVL:&nbsp;http://tutorial.math.lamar.edu/Classes/CalcI/MoreVolume.aspx</span>
<span style=\"font-family: Courier New,courier; color: #006400;\">-A_surfaceWL:&nbsp;https://en.wikipedia.org/wiki/Spherical_cap</span></pre>
</html>"));
end PartialDrumType;
