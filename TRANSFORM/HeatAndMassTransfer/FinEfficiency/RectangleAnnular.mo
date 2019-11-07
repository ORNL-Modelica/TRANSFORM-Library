within TRANSFORM.HeatAndMassTransfer.FinEfficiency;
model RectangleAnnular
  import GSLfsf = GNU_ScientificLibrary.Functions.specfunc;
  extends
    TRANSFORM.HeatAndMassTransfer.FinEfficiency.BaseClasses.PartialFinEfficiency;
  parameter Boolean use_NonDimensional = false;
  input SI.CoefficientOfHeatTransfer alpha "Average heat transfer coefficient" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length r_inner "Fin inner radius" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length r_outer "Fin outer radius" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length th "Fin thickness" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input Units.NonDim mr_inner = sqrt(2*alpha/(lambda*th))*r_inner "Non-dimensional r_inner fin parameter" annotation(Dialog(group="Inputs",enable=use_NonDimensional));
  input Units.NonDim mr_outer = sqrt(2*alpha/(lambda*th))*r_outer "Non-dimensional r_outer fin parameter" annotation(Dialog(group="Inputs",enable=use_NonDimensional));
  input SI.Length pitch "Fin pitch" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  SI.Area surfaceArea= 2*Modelica.Constants.pi*(r_outer^2 - r_inner^2) + tipArea;
  SI.Area primeArea = 2*Modelica.Constants.pi*r_inner*(pitch);
  SI.Area baseArea = 2*Modelica.Constants.pi*r_inner*(th);
  SI.Area tipArea = 2*Modelica.Constants.pi*r_outer*(th);
  SI.Area totalArea = surfaceArea+primeArea-baseArea;
algorithm
  eta :=2*mr_inner/(mr_outer^2 - mr_inner^2)*(GSLfsf.bessel_Kn(1,mr_inner)*GSLfsf.bessel_In(1,mr_outer) - GSLfsf.bessel_In(1,mr_inner)*GSLfsf.bessel_Kn(1,mr_outer))/(GSLfsf.bessel_In(0,mr_inner)*GSLfsf.bessel_Kn(1,mr_outer) + GSLfsf.bessel_Kn(0,mr_inner)*GSLfsf.bessel_In(1,mr_outer));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/RectangularAnnular.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RectangleAnnular;
