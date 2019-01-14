within TRANSFORM.HeatExchangers.ClosureRelations.Models.Examples;
model check_CrossFlow

  extends TRANSFORM.Icons.Example;

  // Values to add equation for testing
  parameter Real epsilon = 0.75;
  parameter Real NTU = 2.1;

  EffectivenessNTU_Relations.Crossflow returnEpsilon(C_1=4197, C_2=1889,
    u=NTU)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  EffectivenessNTU_Relations.Crossflow returnNTU(
    C_1=4197,
    C_2=1889,
    inputNTU=false,
    u=epsilon,
    epsilonMethod=false,
    C_min_mixed=true)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={returnEpsilon.epsilon,
        returnNTU.NTU})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end check_CrossFlow;
