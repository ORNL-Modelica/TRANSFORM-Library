within TRANSFORM.Math.Examples;
model check_max_len_seq_sine_time
  extends TRANSFORM.Icons.Example;

  parameter Real bias=0 "Bias from nominal middle value of signal";
  parameter Integer use_SetWeight=1
    "Select predefined weight or set weights manually";
  parameter Real weights[:]=if use_SetWeight == 1 then {1,1,1,1,1,1,1} elseif
      use_SetWeight == 2 then {1,-1,1,-1,1,-1,1} elseif use_SetWeight == 3
       then {0.5,1,1,1.2,1.8,1.8,2} else fill(0, 1) "Sequence weighting";
  parameter Integer harmonics[size(weights, 1)]={1,2,4,8,16,32,64}
    "Sequence harmonics. size(harmonics) = size(weights)";

  final parameter SI.Time y[:]=TRANSFORM.Math.max_len_seq__sine_time(
      weights,
      harmonics,
      bias);

  Utilities.ErrorAnalysis.UnitTests unitTests(x={y[10]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end check_max_len_seq_sine_time;
