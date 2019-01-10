within TRANSFORM.HeatExchangers.Sizing.Examples;
model CrossflowHX

  extends TRANSFORM.Icons.Example;

  EffectivenessNTU effectivenessNTU_HX(
    Ts_1={373.15,573.15},
    cp_1=1000,
    Ts_2={308.15,398.15},
    cp_2=4197,
    use_m_flow_1=false,
    m_flow=1,
    U=100,
    redeclare model EffectivenessNTU =
        ClosureRelations.Models.EffectivenessNTU_Relations.Crossflow)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  EffectivenessNTU effectivenessNTU_HX1(
    Ts_1={373.15,573.15},
    cp_1=1000,
    Ts_2={308.15,398.15},
    cp_2=4197,
    use_m_flow_1=false,
    m_flow=1,
    U=100,
    redeclare model EffectivenessNTU =
        ClosureRelations.Models.EffectivenessNTU_Relations.Crossflow (
          epsilonMethod=false, C_min_mixed=true))
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={
        effectivenessNTU_HX.surfaceArea,effectivenessNTU_HX1.surfaceArea})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model of a crossflow heat exchanger using the effectiveness NTU method.</p>
<p>Source:</p>
<p>Incropera, Frank P., David P. DeWitt, Theodore L. Bergman, and Adrienne S. Lavine, eds. Fundamentals of Heat and Mass Transfer. 6. ed. Hoboken, NJ: Wiley, 2007. </p>
<p>Example 11.3</p>
</html>"));
end CrossflowHX;
