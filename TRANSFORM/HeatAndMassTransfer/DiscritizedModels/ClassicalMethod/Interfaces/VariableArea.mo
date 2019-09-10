within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces;
model VariableArea
  "Balances Q_flow and T for a variable area (e.g., liquid/vapor) connected to a fixed area (e.g., wall)"
  parameter Integer nVar = 1 "# of variable nodal areas";
  parameter Integer nFixed = 1 "# of fixed nodal areas";
  input SI.Area[nVar] surfaceAreas_Var "Variable surface areas. sum(Var) = sum(Fixed)" annotation(Dialog(group="Inputs"));
  input SI.Area[nFixed] surfaceAreas_Fixed "Fixed surface areas. sum(Var) = sum(Fixed)" annotation(Dialog(group="Inputs"));
  Real[nVar,nFixed] fA "Weighted average area correction factors";
  Real[nVar,nFixed] f "Weighted area correction factors";
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPorts_Flow heatPorts_Var[nVar]
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={-100,0})));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPorts_Flow heatPorts_Fixed[nFixed]
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={100,0})));
algorithm
    (fA,f) :=Math.meanFactor(surfaceAreas_Var, surfaceAreas_Fixed);
equation
  assert(abs(sum(surfaceAreas_Var)-sum(surfaceAreas_Fixed)) < Modelica.Constants.eps, "Total variable and fixed surface areas must be equal");
  for i in 1:nVar loop
    heatPorts_Var[i].Q_flow + f[i,:]*heatPorts_Fixed[:].Q_flow = 0;
    heatPorts_Var[i].T = fA[i,:]*heatPorts_Fixed[:].T;
  end for;
  annotation (defaultComponentName="variableArea",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{0,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{0,70},{100,70}}, color={0,0,0}),
        Line(points={{0,26},{100,26}}, color={0,0,0}),
        Line(points={{0,-42},{100,-42}},          color={0,0,0}),
        Line(
          points={{-100,0},{-80,0},{-68,10},{-50,-12},{-34,10},{-20,0},{0,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Ellipse(
          extent={{-54,54},{-46,46}},
          fillColor={199,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-54,-46},{-46,-54}},
          fillColor={199,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{46,90},{54,82}},
          fillColor={199,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{46,52},{54,44}},
          fillColor={199,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{46,-6},{54,-14}},
          fillColor={199,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{46,-66},{54,-74}},
          fillColor={199,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));
end VariableArea;
