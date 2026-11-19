within TRANSFORM.Fluid.Machines;
model Pump_wShaft
  "Centrifugal pump with ideally controlled speed with mechanical shaft"
  extends TRANSFORM.Fluid.Machines.BaseClasses.PartialPump;
  SI.Angle phi(start=0) "Shaft angle";
  SI.AngularVelocity omega "Shaft angular velocity";
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
  annotation (Placement(transformation(extent={{-10,70},{10,90}}),
        iconTransformation(extent={{-10,70},{10,90}})));
equation
  phi = shaft.phi;
  omega = der(phi);
  N =max(1e-3, Modelica.Units.Conversions.to_rpm(omega));
  W = omega*shaft.tau;
  annotation (defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-11,6},{11,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164},
          origin={0,70},
          rotation=-90)}),
    Documentation(info="<html>
<p>A centrifugal pump driven through the mechanical flange <code>shaft</code>; the speed follows the shaft. With <code>nParallel</code> pumps, the shaft drives one of them: its power is <code>W</code>, and the group takes <code>W_total = nParallel*W</code>.</p>
</html>"));
end Pump_wShaft;
