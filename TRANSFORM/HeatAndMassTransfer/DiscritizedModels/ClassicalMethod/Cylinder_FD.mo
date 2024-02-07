within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod;
model Cylinder_FD
  "This model allows the use of a replaceable solution for all cylindrical finite difference conduction models"
  replaceable model SolutionMethod_FD =
      TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.SolutionMethods.NodeCentered_2D
    constrainedby TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.BaseClasses.Partial_FDCond_Cylinder
    "Finite Difference Solution Method"
      annotation (choicesAllMatching=true);
  extends TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.BaseClasses.Partial_BaseFDCond_Cylinder;
  SolutionMethod_FD solutionMethod(
    redeclare final package Material = Material,
    final use_q_ppp=use_q_ppp,
    final r_inner=r_inner,
    final r_outer=r_outer,
    final rs=rs,
    final zs=zs,
    final length=length,
    final nR=nR,
    final nZ=nZ,
    final energyDynamics=energyDynamics,
    final Tref=Tref,
    final Ts_start=Ts_start);
equation
  connect(q_ppp_input,solutionMethod.q_ppp_input);
  connect(heatPorts_bottom,solutionMethod.heatPorts_bottom);
  connect(heatPorts_top,solutionMethod.heatPorts_top);
  connect(heatPorts_outer,solutionMethod.heatPorts_outer);
  connect(heatPorts_inner,solutionMethod.heatPorts_inner);
  annotation (defaultComponentName="cylinder",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={
        Line(
          points={{-80,-80},{-20,-80}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-80,-80},{-80,-20}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-104,-18},{-78,-40}},
          lineColor={0,0,0},
          textString="z"),
        Text(
          extent={{-42,-76},{-16,-98}},
          lineColor={0,0,0},
          textString="r"),
      Text(
        extent={{-12,-4},{12,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j"),
      Ellipse(
        extent={{4,4},{-4,-4}},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Ellipse(
        extent={{64,4},{56,-4}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{-56,4},{-64,-4}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{4,64},{-4,56}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{4,-56},{-4,-64}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Text(
        extent={{42,-4},{82,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i+1, j"),
      Text(
        extent={{-18,58},{18,40}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j+1"),
      Text(
        extent={{-18,-62},{18,-80}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j-1"),
      Text(
        extent={{-78,-4},{-38,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i-1, j")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
        graphics={
        Rectangle(
          extent={{-50,54},{52,-52}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),                                                             Text(
          extent={{54,-56},{146,-100}},
          lineColor={28,108,200},
          textString="%name"),
      Ellipse(
        extent={{2,2},{-2,-2}},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Ellipse(
        extent={{2,-38},{-2,-42}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
        Text(
          extent={{-30,-46},{-22,-52}},
          lineColor={0,0,0},
          textString="r"),
        Line(
          points={{-42,-44},{-22,-44}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-50,-24},{-44,-30}},
          lineColor={0,0,0},
          textString="z"),
        Line(
          points={{-42,-44},{-42,-24}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
      Ellipse(
        extent={{42,2},{38,-2}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{2,42},{-2,38}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{-38,2},{-42,-2}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
        Line(
          points={{20,-20},{20,0},{20,20},{-20,20},{-20,-20},{20,-20}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5)}));
end Cylinder_FD;
