within TRANSFORM.HeatAndMassTransfer.FinEfficiency;
model SpineRectangular
  extends
    TRANSFORM.HeatAndMassTransfer.FinEfficiency.BaseClasses.PartialFinEfficiency;

  parameter Boolean use_NonDimensional = false;

  input SI.CoefficientOfHeatTransfer alpha "Average heat transfer coefficient" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.Length D "Fin diameter" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.Length L "Fin length" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));

  input Units.NonDim mL = sqrt(2*alpha/(lambda*D))*L "Non-dimensional fin parameter" annotation(Dialog(group="Input Variables",enable=use_NonDimensional));

  SI.Area surfaceArea= Modelica.Constants.pi*D*L;

algorithm

  eta :=Modelica.Math.tanh(mL)/mL;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/SpineRectangular.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SpineRectangular;
