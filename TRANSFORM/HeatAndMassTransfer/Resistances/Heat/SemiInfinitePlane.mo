within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model SemiInfinitePlane "Semi-Infinite plane"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Area crossArea "Cross-sectional area perpindicular to heat flow" annotation(Dialog(group="Inputs"));
  input SI.ThermalConductivity lambda "Thermal conductivity" annotation(Dialog(group="Inputs"));
  input SI.ThermalDiffusivity alpha_d "Thermal diffusivity (i.e., lambda/(d*cp))" annotation(Dialog(group="Inputs"));
  input SI.Time t = time "Time" annotation(Dialog(group="Inputs"));
equation
  R = max(Modelica.Constants.eps,sqrt(Modelica.Constants.pi*alpha_d*t)/(lambda*crossArea));
  annotation (defaultComponentName="plane_semiInf",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-36,-100},{44,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Plane_Infinite.jpg")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end SemiInfinitePlane;
