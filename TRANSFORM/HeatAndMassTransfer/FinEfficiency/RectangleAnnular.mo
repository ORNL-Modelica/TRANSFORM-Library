within TRANSFORM.HeatAndMassTransfer.FinEfficiency;
model RectangleAnnular
  import GSL = TRANSFORM.Math.GNU_ScientificLibrary.Functions.specfunc;
  extends TRANSFORM.HeatAndMassTransfer.FinEfficiency.BaseClasses.PartialFinEfficiency;
  parameter Boolean use_NonDimensional = false;
  input SI.CoefficientOfHeatTransfer alpha "Average heat transfer coefficient" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length r_inner "Fin inner radius" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length r_outer "Fin outer radius" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input SI.Length th "Fin thickness" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));
  input Units.NonDim mr_inner = sqrt(2*alpha/(lambda*th))*r_inner "Non-dimensional r_inner fin parameter" annotation(Dialog(group="Inputs",enable=use_NonDimensional));
  input Units.NonDim mr_outer = sqrt(2*alpha/(lambda*th))*r_outer "Non-dimensional r_outer fin parameter" annotation(Dialog(group="Inputs",enable=use_NonDimensional));
  input SI.Length pitch "Fin pitch" annotation(Dialog(group="Inputs",enable=not use_NonDimensional));

  SI.Area surfaceArea= 2*Modelica.Constants.pi*(r_outer^2 - r_inner^2) + surfaceArea_tip;
  SI.Area surfaceArea_tip = 2*Modelica.Constants.pi*r_outer*(th);
  SI.Area surfaceArea_pitch = 2*Modelica.Constants.pi*r_inner*(pitch);
  SI.Area surfaceArea_base = 2*Modelica.Constants.pi*r_inner*(th);
  SI.Area surfaceArea_total = surfaceArea+surfaceArea_pitch-surfaceArea_base;
  SI.Efficiency eta_overall "Efficiency of an array of fins";

algorithm
  eta :=2*mr_inner/(mr_outer^2 - mr_inner^2)*(GSL.bessel_Kn(1, mr_inner)*
    GSL.bessel_In(1, mr_outer) - GSL.bessel_In(1, mr_inner)*GSL.bessel_Kn(1,
    mr_outer))/(GSL.bessel_In(0, mr_inner)*GSL.bessel_Kn(1, mr_outer) +
    GSL.bessel_Kn(0, mr_inner)*GSL.bessel_In(1, mr_outer));
  eta_overall :=1 - surfaceArea/surfaceArea_total*(1 - eta);

  annotation (defaultComponentName="finEfficiency",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/RectangularAnnular.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RectangleAnnular;
