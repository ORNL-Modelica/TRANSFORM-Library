within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.DrumTypes;
model Traditional_topcap "Traditional: Cylinder with only a top spherical cap"
  extends
    TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.DrumTypes.PartialDrumType(
    final V_total_parameter=pi*r_1^2*h_1+0.5*4/3*pi*r_2^3);
  parameter SI.Length r_1 "Region 1 radius" annotation(Dialog(group="Region 1: Cylinder"));
  parameter SI.Height h_1 "Region 1 height" annotation(Dialog(group="Region 1: Cylinder"));
  parameter SI.Length r_2 "Region 2 radius" annotation(Dialog(group="Region 2: Top Spherical Cap"));
protected
  SI.Area A_1c = pi*r_1^2 "Region 1 cross liquid/vapor surface area";
  SI.Volume V_1 = A_1c*h_1 "Region 1 volume";
  SI.Volume V_2 = 0.5*4/3*pi*r_2^3 "Region 2 volume";
  SI.Area A_1w = 2*pi*r_1*h_1 "Region 1 total wall surface area";
  SI.Area A_2w = 0.5*4*pi*r_2^2 "Region 2 total wall surface area";
algorithm
  V_total :=V_1 + V_2;
  A_surfaceWTotal :=A_1w + A_2w;
  level := smooth(1, noEvent(if V_liquid <= V_1 then V_liquid/A_1c
     else h_1 + TRANSFORM.Math.cubicRoots_SingleReal(
                a=-pi/3,
                b=0,
                c=pi*r_2^2,
                d=V_1 - V_liquid,
                u_min=-0.1,
                u_max=r_2 + 0.1)));
  A_surfaceVL :=smooth(1, noEvent(if V_liquid < V_1 then A_1c else pi*(r_2^2 - (
    level - h_1)^2)));
  A_surfaceWL :=smooth(1, noEvent(if V_liquid < V_1 then 2*pi*r_1*level else
    A_1w + A_2w - 2*pi*r_2*(r_2 - (level - h_1))));
  Region :=noEvent(if level < h_1 then 1 else 2);
  A_surfaceWV :=A_surfaceWTotal - A_surfaceWL;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(points={{-52,-18}}, color={0,0,0}),
        Ellipse(
          extent={{50,100},{-50,0}},
          fillColor={222,173,48},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-50,50},{50,-100}},
          pattern=LinePattern.None,
          fillColor={193,105,3},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{0,-100},{0,100}},
          color={0,0,0},
          pattern=LinePattern.Dash)}));
end Traditional_topcap;
