within TRANSFORM.Utilities.Visualizers.Examples;
model IconColorMap_1D_Test
  extends TRANSFORM.Icons.Example;
  IconColorMap_1D iconColorMap_1D(
    n=3,
    val={time,0.5,1 - time},
    val_min=0,
    val_max=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=9, x=cat(
        1,
        iconColorMap_1D.dynColor[1, :],
        iconColorMap_1D.dynColor[2, :],
        iconColorMap_1D.dynColor[3, :]))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1),
    Documentation(info="<html>
<p>Each element of <code>IconColorMap_1D</code> is colored from its own value: element 1 sweeps the color map from 0 to 1, element 2 stays at 0.5 and element 3 sweeps from 1 to 0.</p>
</html>"));
end IconColorMap_1D_Test;
