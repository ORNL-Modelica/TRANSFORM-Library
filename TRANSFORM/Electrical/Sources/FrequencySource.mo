within TRANSFORM.Electrical.Sources;
model FrequencySource "Defines frequency variable for electrical power connector"

parameter Boolean use_port = false "= true to use input signal" annotation(choices(checkBox=true));
parameter SI.Frequency f = 60 "Frequency";

  Interfaces.ElectricalPowerPort_State port
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput f_input(unit="1/s") if use_port annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));

protected
  Modelica.Blocks.Interfaces.RealInput f_internal(unit="1/s");

equation
  connect(f_internal,f_input);
  if not use_port then
    f_internal = f;
  end if;

  port.f = f_internal;

   annotation (defaultComponentName="boundary",
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-150,106},{150,146}},
          lineColor={238,46,47},
          textString="%name"), Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/FrequencySource.jpg")}),
                                                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FrequencySource;
