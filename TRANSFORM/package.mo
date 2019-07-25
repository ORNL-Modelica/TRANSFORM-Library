within ;
package TRANSFORM "TRANSFORM - TRANsient Simulation Framework Of Reconfigurable Models"
  extends TRANSFORM.Icons.TRANSFORMPackage;
import SI = Modelica.SIunits;
import SIadd = TRANSFORM.Units;
import Modelica.Constants.pi;
import Modelica.Math;

annotation (
    uses(
    SDF(version="0.4.0"),
    ModelicaServices(version="3.2.2"),
    Modelica(version="3.2.3"),
    Complex(version="3.2.3"),
    UserInteraction(version="0.65")),
    version="1",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
</html>"));
end TRANSFORM;
