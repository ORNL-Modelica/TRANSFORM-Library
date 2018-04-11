within TRANSFORM.HeatAndMassTransfer.FinEfficiency;
model StraightRectangular
  extends
    TRANSFORM.HeatAndMassTransfer.FinEfficiency.BaseClasses.PartialFinEfficiency;

  parameter Boolean use_NonDimensional = false;

  input SI.CoefficientOfHeatTransfer alpha "Average heat transfer coefficient" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length th "Fin thickness" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length L "Fin length" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length W "Fin width" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));

  input Units.NonDim mL = sqrt(2*alpha/(lambda*th))*L "Non-dimensional fin parameter" annotation(Dialog(group="Inputs",enable=use_NonDimensional));

  SI.Area surfaceArea = 2*W*L;
algorithm

  eta :=Modelica.Math.tanh(mL)/mL;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/StraightRectangular.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightRectangular;
