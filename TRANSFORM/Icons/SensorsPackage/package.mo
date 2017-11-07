within TRANSFORM.Icons;
partial package SensorsPackage "Icon for packages containing sensors"
  extends TRANSFORM.Icons.Package;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(origin={0.0,-30.0},
          fillColor={255,255,255},
          extent={{-90.0,-90.0},{90.0,90.0}},
          startAngle=20.0,
          endAngle=160.0),
        Ellipse(origin={0.0,-30.0},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-20.0,-20.0},{20.0,20.0}}),
        Line(origin={0.0,-30.0},
          points={{0.0,60.0},{0.0,90.0}}),
        Ellipse(origin={-0.0,-30.0},
          fillColor={64,64,64},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-10.0,-10.0},{10.0,10.0}}),
        Polygon(
          origin={-0.0,-30.0},
          rotation=-35.0,
          fillColor={64,64,64},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-7.0,0.0},{-3.0,85.0},{0.0,90.0},{3.0,85.0},{7.0,0.0}})}),
                            Documentation(info="<html>
<p>This icon indicates a package containing sensors.</p>
</html>"));
end SensorsPackage;
