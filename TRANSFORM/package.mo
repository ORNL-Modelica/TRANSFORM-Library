within ;
package TRANSFORM "TRANSFORM - TRANsient Simulation Framework Of Reconfigurable Models - version 0.1beta"

  extends TRANSFORM.Icons.TRANSFORMPackage;

import SI = Modelica.SIunits;
import SIadd = TRANSFORM.Units;
import Modelica.Constants.pi;
import Modelica.Math;
















annotation (
    uses(
    Modelica(version="3.2.2"),
    Complex(version="3.2.2"),
    UserInteraction(version="0.64"),
    SDF(version="0.4.0")),
    version="1",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Package <b>TRANSFORM</b> is a <b>standardized</b> and <b>free</b> package that is developed with the Modelica&reg; language, see <a href=\"https://www.Modelica.org\">https://www.Modelica.org</a>. It provides model components in many domains that are based on standardized interface definitions.</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\"><a href=\"modelica://TRANSFORM.UsersGuide.Contact\">Contact</a> lists the contributors of the library.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The <b>Examples</b> packages in the various libraries, demonstrate how to use the components of the corresponding sublibrary. </span></li>
</ul>
</html>"));
end TRANSFORM;
