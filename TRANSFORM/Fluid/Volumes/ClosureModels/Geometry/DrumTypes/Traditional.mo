within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes;
model Traditional "Traditional: Cylinder with spherical caps"

  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes.PartialDrumType;

  parameter SI.Length r_1 "Region 1 radius" annotation(Dialog(group="Region 1: Bottom Spherical Cap"));

  parameter SI.Length r_2 "Region 2 radius" annotation(Dialog(group="Region 2: Middle Cylinder"));
  parameter SI.Height h_2 "Region 2 height" annotation(Dialog(group="Region 2: Middle Cylinder"));

  parameter SI.Length r_3 "Region 3 radius" annotation(Dialog(group="Region 3: Top Spherical Cap"));

  SI.Area A_2c = pi*r_2^2 "Region 2 cross liquid/vapor surface area";

  SI.Volume V_1 = 0.5*4/3*pi*r_1^3 "Region 1 volume";
  SI.Volume V_2 = A_2c*h_2 "Region 2 volume";
  SI.Volume V_3 = 0.5*4/3*pi*r_3^3 "Region 3 volume";

  SI.Area A_1w = 0.5*4*pi*r_1^2 "Region 1 total wall surface area";
  SI.Area A_2w = 2*pi*r_2*h_2 "Region 2 total wall surface area";
  SI.Area A_3w = 0.5*4*pi*r_3^2 "Region 3 total wall surface area";

  SI.Height  height_total = r_1 + h_2 + r_3 "Total vessel height";

algorithm
  V_total :=V_1 + V_2 + V_3;
  surfaceArea_Wall_total :=A_1w + A_2w + A_3w;

  crossArea_liquid :=1;
  crossArea_vapor :=1;

  level := smooth(1,noEvent(
             if V_liquid < V_1 then
               TRANSFORM.Math.cubicRoots_SingleReal(
                 a=-pi/3,
                 b=pi*r_1,
                 c=0,
                 d=-V_liquid,
                 u_min=-0.1,
                 u_max=r_1+0.1)
             elseif (V_liquid >= V_1 and V_liquid <= V_1+V_2) then
               (V_liquid - V_1)/A_2c + r_1
             else
               h_2 + r_1 + TRANSFORM.Math.cubicRoots_SingleReal(
                 a=-pi/3,
                 b=0,
                 c=pi*r_3^2,
                 d=V_1+V_2-V_liquid,
                 u_min=-0.1,
                 u_max=r_3+0.1)));

  level_vapor := height_total - level;

  surfaceArea_VL := smooth(1,noEvent(
             if V_liquid < V_1 then
               pi*(r_1^2 - (r_1 - level)^2)
             elseif (V_liquid >= V_1 and V_liquid <= V_1+V_2) then
               A_2c
             else
               pi*(r_3^2 - (level - h_2 - r_1)^2)));

  surfaceArea_WL := smooth(1,noEvent(
             if V_liquid < V_1 then
               2*pi*r_1*level
             elseif (V_liquid >= V_1 and V_liquid <= V_1+V_2) then
               A_1w + 2*pi*r_2*(level - r_1)
             else
               A_1w + A_2w + A_3w - 2*pi*r_3*(r_3 - (level - h_2 - r_1))));

  Region := noEvent(if level < r_1 then
                 1
               elseif (level >= r_1 and level <= h_2+r_1) then
                 2
               else
                 3);

  surfaceArea_WV :=surfaceArea_Wall_total - surfaceArea_WL;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
          extent={{50,0},{-50,-100}},
          fillColor={222,173,48},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{50,100},{-50,0}},
          fillColor={222,173,48},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-50,50},{50,-50}},
          pattern=LinePattern.None,
          fillColor={193,105,3},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{0,-100},{0,100}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Line(points={{-52,-18}}, color={0,0,0})}), Documentation(info="<html>
<p>A traditional pressurizer geometry with two spherical caps and a cylindrical middle body.</p>
<p>The surface area associated with the wall is calculated as the outer surface of the three regions. In other words,</p>
<p>if the radii are not the same, the calculation does not calculate the differences into the surface area calculation although</p>
<p>it is factored into the volume and therefore the liquid level calculation.</p>
</html>"));
end Traditional;
