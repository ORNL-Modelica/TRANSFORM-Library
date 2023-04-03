within TRANSFORM.HeatAndMassTransfer.FinEfficiency;
model StraightParabolic
  extends TRANSFORM.HeatAndMassTransfer.FinEfficiency.BaseClasses.PartialFinEfficiency;
  parameter Boolean use_NonDimensional = false;
  input SI.CoefficientOfHeatTransfer alpha "Average heat transfer coefficient" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length th "Fin thickness" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length L "Fin length" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length W "Fin width" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input Units.NonDim mL = sqrt(2*alpha/(lambda*th))*L "Non-dimensional fin parameter" annotation(Dialog(group="Inputs",enable=use_NonDimensional));
  Units.NonDim c1 = sqrt(1+(th/L)^2);
  SI.Area surfaceArea=W*(c1*L + L^2/th*log(th/L + c1));
equation
  eta = 2/(sqrt(4*(mL)^2+1)+1);
  annotation (defaultComponentName="finEfficiency",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/StraightParabolic.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightParabolic;
