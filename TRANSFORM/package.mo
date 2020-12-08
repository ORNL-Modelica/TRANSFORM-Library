within ;
package TRANSFORM "TRANSFORM - TRANsient Simulation Framework Of Reconfigurable Models"
  extends TRANSFORM.Icons.TRANSFORMPackage;
import Modelica.Units.SI;
import SIadd = TRANSFORM.Units;
import Modelica.Constants.pi;
import Modelica.Math;

annotation (
    uses(
    ModelicaServices(version="3.2.2"),
    Complex(version="3.2.3"),
    SDF(version="0.4.1"),
      Modelica(version="4.0.0"),
      UserInteraction(version="0.70")),
    version="0.5",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
</html>"));
end TRANSFORM;
