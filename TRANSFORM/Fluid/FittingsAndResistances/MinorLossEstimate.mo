within TRANSFORM.Fluid.FittingsAndResistances;
model MinorLossEstimate

  input SItf.NonDim K "Minor loss coefficients"
    annotation (Dialog(group="Inputs"));
  input SI.Density rho "Density" annotation (Dialog(group="Inputs"));
  input SI.Velocity v "Velocity" annotation (Dialog(group="Inputs"));

  SI.PressureDifference dp "Pressure loss";

equation

  dp = 0.5*K*rho*v*v;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/minorloss.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MinorLossEstimate;
