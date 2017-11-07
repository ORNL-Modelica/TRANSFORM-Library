within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Radiation "Radiation"

  extends
    TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;

  import Modelica.Constants.sigma;

  parameter Boolean useExact = true "=false to use average temperature approximation Tbar^3";
  input SI.Area surfaceArea "Heat transfer surface area" annotation(Dialog(group="Input Variables"));
  input SI.Emissivity epsilon "Emissivity" annotation(Dialog(group="Input Variables"));
//   input SI.Temperature Tsurf "Absolute surface temperature" annotation(Dialog(group="Input Variables", enable=not useExact));
//   input SI.Temperature Tsur "Absolute surroundings temperature" annotation(Dialog(group="Input Variables", enable=not useExact));

  SI.Temperature T_bar "Average temperature";

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
        coordinateSystem(preserveAspectRatio=false)));
end Radiation;
