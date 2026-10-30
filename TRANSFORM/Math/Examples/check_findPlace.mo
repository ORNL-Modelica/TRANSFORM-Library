within TRANSFORM.Math.Examples;
model check_findPlace
  extends TRANSFORM.Icons.Example;
  parameter Real e=5.5;
  parameter Real v[:]={1,3,5,7,9,11};
  final parameter Integer y=TRANSFORM.Math.findPlace(e,v);
  Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end check_findPlace;
