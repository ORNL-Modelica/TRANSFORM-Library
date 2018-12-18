within TRANSFORM.Units.Conversions.Models.Examples;
model check_Conversion
  extends TRANSFORM.Icons.Example;

  parameter Real u = 1;


  Utilities.ErrorAnalysis.UnitTests unitTests(
    n=2,
    x={conversion.y,conversion1.y},
    x_reference={100,100})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Conversion conversion(redeclare function convert = Functions.Distance_m.to_cm)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Conversion conversion1(
    use_port=false,
    val=u,
    redeclare function convert = Functions.Distance_m.to_cm)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=u)
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
equation
  connect(realExpression.y, conversion.u)
    annotation (Line(points={{-29,10},{-12,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_Conversion;
