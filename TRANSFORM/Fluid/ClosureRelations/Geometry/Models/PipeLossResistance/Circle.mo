within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance;
model Circle "Circle or characteristic average dimension"

  parameter Boolean use_Dimension=true
    "=true to specify characteristic dimension else cross-sectional area and wetted perimeter"
    annotation (Evaluate=true);

  input SI.Length dimension_avg=0.01
    "Characteristic dimension (e.g., hydraulic diameter)"
    annotation (Dialog(group="Inputs", enable=use_Dimension));
  input SI.Area crossArea_avg=0.25*Modelica.Constants.pi*dimension_avg*dimension_avg
    "Cross sectional area"
    annotation (Dialog(group="Inputs", enable=not use_Dimension));
  input SI.Length perimeter_avg=Modelica.Constants.pi*dimension_avg "Wetted perimeter"
    annotation (Dialog(group="Inputs", enable=not use_Dimension));

  input Units.NonDim k_lam = 1.0 "Laminar region geometric correction coefficient" annotation (Dialog(group="Inputs"));
  input Units.NonDim k_turb = 1.0 "Turbulent region geometric correction coefficient" annotation (Dialog(group="Inputs"));

  extends PartialGeometry(
    final dimension=if use_Dimension then dimension_avg else 4*crossArea/perimeter,
    final crossArea=if use_Dimension then 0.25*Modelica.Constants.pi*dimension*dimension else crossArea_avg,
    final perimeter=if use_Dimension then Modelica.Constants.pi*dimension else perimeter_avg);

equation
  ks[1] = k_lam;
  ks[2] = k_turb;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/Resistences_Geometry_PipeLoss_Circle.jpg\"/></p>
</html>"));
end Circle;
