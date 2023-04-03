within TRANSFORM.Utilities.Visualizers.Inputs;
model NumericInputIO
  parameter String label="";
  parameter Integer precision=3;
  parameter Real max=0;
  parameter Real min=0;
  Modelica.Blocks.Interfaces.RealOutput Value
    annotation (__Dymola_DDE, Placement(transformation(extent={{90,-10},{110,10}},
            rotation=0)));
  annotation (Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
      graphics={
        Rectangle(
          extent={{-100,-40},{100,40}},
          lineColor={192,192,192},
          fillColor={236,233,216},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Sunken),
        Text(extent={{-90,-46},{90,34}}, textString=DynamicSelect("0.0",
              realString(
                Value,
                1,
                integer(precision)))),
        Text(extent={{-100,40},{100,100}}, textString="%label")},
        interaction={OnMouseDownEditReal(Value,min,max)}),                                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),   graphics));
end NumericInputIO;
