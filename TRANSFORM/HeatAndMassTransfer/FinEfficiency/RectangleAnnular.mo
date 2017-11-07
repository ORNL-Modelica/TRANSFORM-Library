within TRANSFORM.HeatAndMassTransfer.FinEfficiency;
model RectangleAnnular "Requires GSL library"
  import GSLfsf = GNU_ScientificLibrary.Functions.specfunc;

  extends
    TRANSFORM.HeatAndMassTransfer.FinEfficiency.BaseClasses.PartialFinEfficiency;

  parameter Boolean use_NonDimensional = false;

  input SI.CoefficientOfHeatTransfer alpha "Average heat transfer coefficient" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.Length r_inner "Fin inner diameter" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.Length r_outer "Fin outer diameter" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));
  input SI.Length th "Fin thickness" annotation(Dialog(group="Input Variables",enable=not use_NonDimensional));

  input Units.nonDim mr_inner = sqrt(2*alpha/(lambda*th))*r_inner "Non-dimensional r_inner fin parameter" annotation(Dialog(group="Input Variables",enable=use_NonDimensional));
  input Units.nonDim mr_outer = sqrt(2*alpha/(lambda*th))*r_outer "Non-dimensional r_outer fin parameter" annotation(Dialog(group="Input Variables",enable=use_NonDimensional));

  SI.Area surfaceArea= 2^Modelica.Constants.pi*(r_outer^2 - r_inner^2);

algorithm

  eta :=2*mr_inner/(mr_outer^2 - mr_inner^2)*(GSLfsf.bessel_Kn(1,mr_inner)*GSLfsf.bessel_In(1,mr_outer) - GSLfsf.bessel_In(1,mr_inner)*GSLfsf.bessel_Kn(1,mr_outer))/(GSLfsf.bessel_In(0,mr_inner)*GSLfsf.bessel_Kn(1,mr_outer) + GSLfsf.bessel_Kn(0,mr_inner)*GSLfsf.bessel_In(1,mr_outer));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/RectangularAnnular.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RectangleAnnular;
