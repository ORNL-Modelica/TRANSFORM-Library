within ;
package TRANSFORM "TRANSFORM - TRANsient Simulation Framework Of Reconfigurable Models"
  extends TRANSFORM.Icons.TRANSFORMPackage;
import Modelica.Units.SI;
import SIadd = TRANSFORM.Units;
import Modelica.Constants.pi;
import Modelica.Math;

annotation (
  uses(
    ModelicaServices(version="4.0.0"),
    Complex(version="4.0.0"),
    Modelica(version="4.0.0"),
    ExternalMedia(version="4.0.0")),
  version="1.1.0",
  versionDate="2026-11-03",
  conversion(noneFromVersion="0.5", noneFromVersion="1.0", noneFromVersion="1.1.0-dev"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
</html>"));
end TRANSFORM;
