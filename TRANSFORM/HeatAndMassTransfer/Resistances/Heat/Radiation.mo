within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Radiation "Radiation heat transfer resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  import Modelica.Constants.sigma;
  parameter Boolean useExact = true "= true to use the exact form, false the T_bar approximation";
  input SI.Area surfaceArea "Heat transfer surface area" annotation(Dialog(group="Inputs"));
  input SI.Emissivity epsilon "Emissivity" annotation(Dialog(group="Inputs"));
//   input SI.Temperature Tsurf "Absolute surface temperature" annotation(Dialog(group="Inputs", enable=not useExact));
//   input SI.Temperature Tsur "Absolute surroundings temperature" annotation(Dialog(group="Inputs", enable=not useExact));
  SI.Temperature T_bar "Mean of the two port temperatures";
equation
  T_bar = 0.5*(port_a.T + port_b.T);
  if useExact then
    R = 1/(surfaceArea*sigma*epsilon*(port_a.T^2+port_b.T^2)*(port_a.T + port_b.T));
  else
    R = 1/(4*surfaceArea*sigma*epsilon*T_bar^3);
  end if;
  annotation (defaultComponentName="radiation",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Radiation.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Radiation heat transfer from a surface, as a resistance. The heat flow rate is <code>surfaceArea*sigma*epsilon*(port_a.T^4 - port_b.T^4)</code>, approximated about <code>T_bar</code> when <code>useExact=false</code>, so it has one emissivity and no view factor.</p>
</html>"));
end Radiation;
