within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant;
model SystemVariableHeatLoad
extends TRANSFORM.Icons.Example;
  extends
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.PartialBOPSystem(
    redeclare Components.SteamGeneratorVariableHeatLoad SG_1(circulationRatio=
          1.2),
    redeclare Components.SteamGeneratorVariableHeatLoad SG_2(circulationRatio=
          1.2),
    redeclare Components.SteamGeneratorVariableHeatLoad SG_3(circulationRatio=
          1.2));
  Modelica.Blocks.Sources.Constant const(each k=4.19348e8)
    annotation (Placement(transformation(extent={{-192,8},{-172,28}})));
  Modelica.Blocks.Sources.Constant const1(each k=4.19348e8)
    annotation (Placement(transformation(extent={{-192,-36},{-172,-16}})));
  Modelica.Blocks.Sources.Constant const2(each k=4.19348e8)
    annotation (Placement(transformation(extent={{-194,-86},{-174,-66}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(
    n=1,
    printResult=false,
    x={total_Q_MW})
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
equation
 total_Q_MW=sum(SG_1.riser.heatPort.Q_flow + SG_2.riser.heatPort.Q_flow + SG_3.riser.heatPort.Q_flow+SG_1.riser1.heatPort.Q_flow + SG_2.riser1.heatPort.Q_flow + SG_3.riser1.heatPort.Q_flow)*1e-6;
  connect(const.y, SG_1.Q_fromPHS) annotation (Line(points={{-171,18},{-91,18},
          {-91,17.4545}},color={0,0,127}));
  connect(const1.y, SG_2.Q_fromPHS) annotation (Line(points={{-171,-26},{-132,
          -26},{-132,-28.5455},{-91,-28.5455}},
                                           color={0,0,127}));
  connect(const2.y, SG_3.Q_fromPHS) annotation (Line(points={{-173,-76},{-134,
          -76},{-134,-70.5455},{-91,-70.5455}},
                                           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{140,100}})),
    experiment(StopTime=25000, Tolerance=1e-005));
end SystemVariableHeatLoad;
