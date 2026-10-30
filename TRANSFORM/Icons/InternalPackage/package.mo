within TRANSFORM.Icons;
partial package InternalPackage "Icon for an internal package (indicating that the package should not be directly utilized by user)"
annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
          100}}), graphics={
      Rectangle(
        lineColor={215,215,215},
        fillColor={255,255,255},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-100,-100},{100,100}},
        radius=25),
      Rectangle(
        lineColor={215,215,215},
        extent={{-100,-100},{100,100}},
        radius=25),
      Ellipse(
        extent={{-80,80},{80,-80}},
        lineColor={215,215,215},
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid),
      Ellipse(
        extent={{-55,55},{55,-55}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-60,14},{60,-14}},
        lineColor={215,215,215},
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid,
        rotation=45)}),
  Documentation(info="<html>

<p>
This icon shall be used for a package that contains internal classes not to be
directly utilized by a user.
</p>
</html>"));
end InternalPackage;
