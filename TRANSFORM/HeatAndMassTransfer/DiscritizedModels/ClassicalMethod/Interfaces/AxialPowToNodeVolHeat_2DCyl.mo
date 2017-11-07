within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces;
model AxialPowToNodeVolHeat_2DCyl
  "Converts axial volumetrically divided power to nodal volumetric heat generation for 2D cylindrical"

  import Modelica.Constants.pi;

  parameter Real nParallel=1 "# of parallel elements for power scaling";
  parameter Integer nR(min=3) "Nodes in radial direction";
  parameter Integer nZ(min=3) "Nodes in axial direction";

  input SI.Length r_inner "Centerline/Inner radius of cylinder"
  annotation(Dialog(group="Input Variables"));
  input SI.Length r_outer "Outer radius of cylinder"
  annotation(Dialog(group="Input Variables"));
  input SI.Length length "length of cylinder"
  annotation(Dialog(group="Input Variables"));

  Modelica.Blocks.Interfaces.RealInput Power_in[nZ - 1]
    "Input Axial Power Distribution (volume approach)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput q_ppp[nR,nZ](unit="W/m3")
    "Volumetric heat source"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  SI.Volume volTotal = pi*(r_outer^2-r_inner^2)*length;
  SI.Volume volAxial=volTotal/(nZ - 1);
  Real q_ppp_vol[nZ - 1](unit="W/m3");

equation
q_ppp_vol =Power_in/(nParallel*volAxial);

  for i in 1:nR loop
  q_ppp[i,1] = q_ppp_vol[1];
    for j in 2:nZ - 1 loop
    q_ppp[i,j] = (q_ppp_vol[j-1] + q_ppp_vol[j])/2;
  end for;
    q_ppp[i, nZ] = q_ppp_vol[nZ - 1];
end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,34},{100,-34}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-43,-27},{-37,-33}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-103,-27},{-97,-33}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-43,33},{-37,27}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-103,33},{-97,27}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{37,-27},{43,-33}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{97,-27},{103,-33}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{37,33},{43,27}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{97,33},{103,27}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-100,30},{-40,30},{-40,-30},{-100,-30},{-100,30}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
        Line(
          points={{40,0},{100,0},{100,-30},{40,-30},{40,0}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
        Line(
          points={{40,0},{40,30},{100,30},{100,0}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
        Text(
          extent={{-98,30},{-42,-24}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Power"),
        Text(
          extent={{-18,18},{18,-18}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="TO"),
        Text(
          extent={{50,28},{94,0}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="q_ppp"),
        Text(
          extent={{50,2},{94,-26}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="q_ppp")}));
end AxialPowToNodeVolHeat_2DCyl;
