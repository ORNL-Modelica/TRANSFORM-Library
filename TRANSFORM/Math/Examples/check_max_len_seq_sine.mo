within TRANSFORM.Math.Examples;
model check_max_len_seq_sine
  extends TRANSFORM.Icons.Example;

  parameter Integer weights[:]={1,1,1,1,1,1,1};
  parameter Integer harmonics[size(weights, 1)]={1,2,4,8,16,32,64};
  final parameter Real y[integer(max(harmonics)^2)]=
      TRANSFORM.Math.max_len_seq_sine(weights, harmonics);

  Utilities.ErrorAnalysis.UnitTests unitTests(x={y[10]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end check_max_len_seq_sine;
