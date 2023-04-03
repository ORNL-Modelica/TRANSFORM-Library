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
    Modelica(version="4.0.0")),
  version="0.5",
  conversion(from(version=0.4, script="modelica://TRANSFORM/Resources/Scripts/ConvertFromTRANSFORM_0.4.mos")),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
</html>"));
end TRANSFORM;
