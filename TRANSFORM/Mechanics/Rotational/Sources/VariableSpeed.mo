within TRANSFORM.Mechanics.Rotational.Sources;
model VariableSpeed "Variable speed, not dependent on torque"
  extends Modelica.Mechanics.Rotational.Interfaces.PartialTorque;


  parameter Boolean use_port=false "=true then use input port"
    annotation (
    Evaluate=true,
    HideResult=true,
    choices(checkBox=true));
  parameter Modelica.SIunits.AngularVelocity w_fixed "Fixed speed"
    annotation (Dialog(enable=not use_port));

  Modelica.Blocks.Interfaces.RealInput w_ext(unit="rad/s") if use_port
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

protected
  Modelica.Blocks.Interfaces.RealInput w(unit="rad/s")
    "Angular velocity of flange with respect to support (= der(phi))";
equation
  connect(w, w_ext);
  if not use_port then
    w = w_fixed;
  end if;

  w = der(phi);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Line(points={{0,-100},{0,100}}, color={0,0,127}),
          Text(extent={{-116.0,-40.0},{128.0,-16.0}}, textString="%w_fixed")}),
      Documentation(info="<html>
<p>
Model of <b>fixed</b> angular velocity of flange, not dependent on torque.
</p>
</html>"));
end VariableSpeed;
