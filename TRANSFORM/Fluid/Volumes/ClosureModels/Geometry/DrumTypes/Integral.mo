within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes;
model Integral "Integral: Two cylinders with a spherical cap"

  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes.PartialDrumType;

  parameter SI.Length r_1 "Region 1 radius" annotation(Dialog(group="Region 1: Bottom Cylinder"));
  parameter SI.Height h_1 "Region 2 height" annotation(Dialog(group="Region 1: Bottom Cylinder"));

  parameter SI.Length r_2 "Region 2 radius" annotation(Dialog(group="Region 2: Middle Cylinder"));
  parameter SI.Height h_2 "Region 2 height" annotation(Dialog(group="Region 2: Middle Cylinder"));

  parameter SI.Length r_3 "Region 3 radius" annotation(Dialog(group="Region 3: Top Spherical Cap"));

  SI.Area A_1c = pi*r_1^2 "Region 1 cross liquid/vapor surface area";
  SI.Area A_2c = pi*r_2^2 "Region 2 cross liquid/vapor surface area";

  SI.Volume V_1 = A_1c*h_1 "Region 1 volume";
  SI.Volume V_2 = A_2c*h_2 "Region 2 volume";
  SI.Volume V_3 = 0.5*4/3*pi*r_3^3 "Region 3 volume";

  SI.Area A_1w = 0 "Region 3 total wall surface area"; //2*pi*r_1*h_1
  SI.Area A_2w = 2*pi*r_2*h_2 "Region 2 total wall surface area";
  SI.Area A_3w = 0.5*4*pi*r_3^2 "Region 3 total wall surface area";

  SI.Height  height_total = h_1 + h_2 + r_3 "Total vessel height";
algorithm
  V_total :=V_1 + V_2 + V_3;
  surfaceArea_Wall_total :=A_1w + A_2w + A_3w;

  crossArea_liquid :=1;
  crossArea_vapor :=1;

  level :=smooth(1, noEvent(if V_liquid < V_1 then V_liquid/A_1c elseif (
    V_liquid >= V_1 and V_liquid <= V_1 + V_2) then (V_liquid - V_1)/A_2c
     + h_1 else h_2 + h_1 + TRANSFORM.Math.cubicRoots_SingleReal(
          a=-pi/3,
          b=0,
          c=pi*r_3^2,
          d=V_1 + V_2 - V_liquid,
          u_min=-0.1,
          u_max=r_3 + 0.1)));

  level_vapor := height_total - level;

  surfaceArea_VL :=smooth(1, noEvent(if V_liquid < V_1 then A_1c elseif (
    V_liquid >= V_1 and V_liquid <= V_1 + V_2) then A_2c else pi*(r_3^2
     - (level - h_2 - r_1)^2)));

  surfaceArea_WL :=smooth(1, noEvent(if V_liquid < V_1 then 0 elseif (
    V_liquid >= V_1 and V_liquid <= V_1 + V_2) then 0 + 2*pi*r_2*(level
     - h_1) else 0 + A_2w + A_3w - 2*pi*r_3*(r_3 - (level - h_2 - r_1))));

  Region :=noEvent(if level < h_1 then 1 elseif (level >= h_1 and level
     <= h_2 + h_1) then 2 else 3);

  surfaceArea_WV :=surfaceArea_Wall_total - surfaceArea_WL;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-30,-40},{30,-100}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={222,173,48},
          fillPattern=FillPattern.Solid),
        Line(points={{-52,-18}}, color={0,0,0}),
        Ellipse(
          extent={{50,100},{-50,0}},
          fillColor={222,173,48},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-50,50},{50,-40}},
          pattern=LinePattern.None,
          fillColor={193,105,3},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{0,-100},{0,100}},
          color={0,0,0},
          pattern=LinePattern.Dash)}), Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">An integral pressurizer geometry with one spherical caps and middle and bottom cylindrical sections.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Neither the wall surface area in the bottom cylinder nor the bottom area of middle cylinder contribute to</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">the overall wall surface area. This is because as it currently stands, the model that uses this assumes that</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">there is no heat transfer at these surfaces. The surface area is therefore only the area that contributes</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">to heat exchange.</span></p>
</html>"));
end Integral;
