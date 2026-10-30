within TRANSFORM.Icons;
partial package MaterialPropertiesPackage "Icon for package containing property classes"
  extends TRANSFORM.Icons.Package;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
          lineColor={102,102,102},
          fillColor={204,204,204},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Sphere,
          extent={{-60.0,-60.0},{60.0,60.0}})}),
                            Documentation(info="<html>
<p>This icon indicates a package that contains properties</p>
</html>"));
end MaterialPropertiesPackage;
