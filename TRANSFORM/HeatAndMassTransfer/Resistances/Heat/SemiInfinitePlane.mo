within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model SemiInfinitePlane "Transient semi-infinite solid conduction resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Area crossArea "Cross-sectional area perpendicular to heat flow" annotation(Dialog(group="Inputs"));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs"));
  input SI.ThermalDiffusivity alpha_d "Thermal diffusivity" annotation(Dialog(group="Inputs"));
  input SI.Time t = time "Time since the surface temperature changed" annotation(Dialog(group="Inputs"));
equation
  R = max(Modelica.Constants.eps,sqrt(Modelica.Constants.pi*alpha_d*t)/(lambda*crossArea));
  annotation (defaultComponentName="plane_semiInf",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-36,-100},{44,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Plane_Infinite.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Conduction into a semi-infinite solid after its surface temperature changes at once, while the heat has not yet reached the solid's far side. One port is at the surface temperature and the other at the solid's initial temperature; the resistance grows with the square root of <code>t</code>.</p>
</html>"));
end SemiInfinitePlane;
