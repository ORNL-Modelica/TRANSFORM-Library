within TRANSFORM.HeatExchangers.Sizing.Examples;
model Sizing_CrossflowHX

  extends TRANSFORM.Icons.Example;

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={example_11_3.calcType.surfaceArea,
        example_11_4.calcType.T_1_cold})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Sizing_EffectivenessNTU example_11_3(
    redeclare record CalcType = Records.EffectivenessNTU_CalcType.Option2,
    redeclare model EffectivenessNTU =
        ClosureRelations.Models.EffectivenessNTU_Relations.Crossflow,
    inputNTU=false)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Sizing_EffectivenessNTU example_11_4(
    redeclare record CalcType = Records.EffectivenessNTU_CalcType.Option1,
    redeclare model EffectivenessNTU =
        ClosureRelations.Models.EffectivenessNTU_Relations.Crossflow,
    inputNTU=false)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model of a crossflow heat exchanger using the effectiveness NTU method.</p>
<p>Source:</p>
<p>Incropera, Frank P., David P. DeWitt, Theodore L. Bergman, and Adrienne S. Lavine, eds. Fundamentals of Heat and Mass Transfer. 6. ed. Hoboken, NJ: Wiley, 2007. </p>
<p>Example 11.3 and Example 11.4</p>
</html>"));
end Sizing_CrossflowHX;
