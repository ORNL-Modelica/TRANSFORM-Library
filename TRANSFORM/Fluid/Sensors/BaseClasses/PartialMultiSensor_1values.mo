within TRANSFORM.Fluid.Sensors.BaseClasses;
partial model PartialMultiSensor_1values
  extends TRANSFORM.Icons.MultiSensor_1values;
  parameter Integer precision(min=0) = 0 "Number of decimals displayed";
  replaceable function iconUnit =
      TRANSFORM.Units.Conversions.Functions.BaseClasses.PartialConversion
    "Unit for icon display" annotation (choicesAllMatching=true);
  input Real var "Variable to be converted" annotation(Dialog(group="Inputs"));
  Real y = iconUnit(var) "Icon display";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
            extent={{-50,-16},{50,14}},  textString=DynamicSelect("0.0", String(
               y, format="1." + String(precision) + "f")))}),   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialMultiSensor_1values;
