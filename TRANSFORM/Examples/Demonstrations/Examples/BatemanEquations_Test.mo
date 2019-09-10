within TRANSFORM.Examples.Demonstrations.Examples;
model BatemanEquations_Test
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.Examples.Demonstrations.Models.BatemanEquations
                                                        batemanEquations
    annotation (Placement(transformation(extent={{-40,-30},{40,30}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    printResult=false,
    n=4,
    x=batemanEquations.Ns)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000));
end BatemanEquations_Test;
