within TRANSFORM.HeatAndMassTransfer.FinEfficiency;
model StraightTriangular
  extends
    TRANSFORM.HeatAndMassTransfer.FinEfficiency.BaseClasses.PartialFinEfficiency;

  parameter Boolean use_NonDimensional = false;

  input SI.CoefficientOfHeatTransfer alpha "Average heat transfer coefficient" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.Length th "Fin thickness" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.Length L "Fin length" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.Length W "Fin width" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));

  input Units.nonDim mL = sqrt(2*alpha/(lambda*th))*L "Non-dimensional fin parameter" annotation(Dialog(group="Input Variables",enable=use_NonDimensional));

  SI.Area surfaceArea = 2*W^sqrt(L^2 + (0.5*th)^2);
algorithm

  eta :=Math.BesselI(1,2,2*mL)/(mL*Math.BesselI(0,2*mL));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/StraightTriangular.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightTriangular;
