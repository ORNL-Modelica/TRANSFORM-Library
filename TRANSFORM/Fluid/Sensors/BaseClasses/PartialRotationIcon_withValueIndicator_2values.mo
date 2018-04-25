within TRANSFORM.Fluid.Sensors.BaseClasses;
partial model PartialRotationIcon_withValueIndicator_2values

  extends TRANSFORM.Icons.RotationalSensor_2values;

  parameter Integer precision(min=0) = 0 "Number of decimals displayed";

  replaceable function iconUnit =
      TRANSFORM.Units.Conversions.Functions.BaseClasses.PartialConversion
    "Unit for icon display" annotation (choicesAllMatching=true);

  input Real var "Variable to be converted" annotation(Dialog(group="Inputs"));

  Real y = iconUnit(var) "Icon display";

  parameter Integer precision2(min=0) = 0 "Number of decimals displayed";

  replaceable function iconUnit2 =
      TRANSFORM.Units.Conversions.Functions.BaseClasses.PartialConversion
    "Unit for icon display" annotation (choicesAllMatching=true);

  input Real var2 "Variable to be converted" annotation(Dialog(group="Inputs"));

  Real y2 = iconUnit2(var2) "Icon display";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
            extent={{0,-50},{100,-20}},  textString=DynamicSelect("0.0", String(
               y, format="1." + String(precision) + "f"))),               Text(
            extent={{-100,-50},{0,-20}}, textString=DynamicSelect("0.0", String(
               y2, format="1." + String(precision) + "f")))}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialRotationIcon_withValueIndicator_2values;
