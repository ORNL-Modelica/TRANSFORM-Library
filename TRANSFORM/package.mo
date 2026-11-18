within ;
package TRANSFORM "TRANSFORM - TRANsient Simulation Framework Of Reconfigurable Models"
  extends TRANSFORM.Icons.TRANSFORMPackage;
import Modelica.Units.SI;
import SIadd = TRANSFORM.Units;
import SItf = TRANSFORM.Units;
import Modelica.Constants.pi;
import Modelica.Math;

annotation (
  uses(
    ModelicaServices(version="4.0.0"),
    Complex(version="4.0.0"),
    Modelica(version="4.0.0"),
    ExternalMedia(version="4.0.0"),
    SDF(version="0.4.5")),
  version="1.3.0",
  versionDate="2026-11-18",
  conversion(from(version={"0.5", "1.0", "1.1.0-dev", "1.1.0", "1.2.0-dev", "1.2.0", "1.3.0-dev"},
      script="modelica://TRANSFORM/Resources/Scripts/Conversion/ConvertTRANSFORM_from_1.2.0.mos")),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
</html>"));
end TRANSFORM;
