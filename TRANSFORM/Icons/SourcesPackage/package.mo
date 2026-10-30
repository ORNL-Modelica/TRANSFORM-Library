within TRANSFORM.Icons;
partial package SourcesPackage "Icon for packages containing sources"
  extends TRANSFORM.Icons.Package;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          lineColor={108,88,49},
          extent={{-84,-92},{96,88}},
        textString="BC",
        fontName="Bernard MT Condensed")}),
                            Documentation(info="<html>
<p>This icon indicates a package which contains sources.</p>
</html>"));
end SourcesPackage;
