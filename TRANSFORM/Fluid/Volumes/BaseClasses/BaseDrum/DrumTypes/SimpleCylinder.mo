within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.DrumTypes;
model SimpleCylinder "Straight Cylinder"
  extends
    TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.DrumTypes.PartialDrumType(
    final V_total_parameter=pi*r_1^2*h_1);
  parameter SI.Length r_1 "Region 1 radius" annotation(Dialog(group="Region 1: Cylinder"));
  parameter SI.Height h_1 "Region 1 height" annotation(Dialog(group="Region 1: Cylinder"));
protected
  SI.Area A_1c = pi*r_1^2 "Region 1 cross liquid/vapor surface area";
  SI.Volume V_1 = A_1c*h_1 "Region 1 volume";
  SI.Area A_1w = 2*pi*r_1*h_1 "Region 1 total wall surface area";
algorithm
  V_total :=V_1;
  A_surfaceWTotal :=A_1w;
  level := V_liquid/A_1c;
  A_surfaceVL :=A_1c;
  A_surfaceWL :=2*pi*r_1*level;
  Region :=1;
  A_surfaceWV :=A_surfaceWTotal - A_surfaceWL;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(points={{-52,-18}}, color={0,0,0}),
        Rectangle(
          extent={{-50,100},{50,-100}},
          pattern=LinePattern.None,
          fillColor={193,105,3},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{0,-100},{0,100}},
          color={0,0,0},
          pattern=LinePattern.Dash)}));
end SimpleCylinder;
