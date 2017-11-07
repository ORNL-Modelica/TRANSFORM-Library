within TRANSFORM.Media.Fluids.Incompressible;
package EngineOilUnused "Engine Oil: Generic | Unused"
  extends Modelica.Media.Incompressible.TableBased(
    mediumName="Engine Oil: Unused, Generic",
    T_min=260,
    T_max=400,
    TinK=true,
    T0=273.15,
    tableDensity=[260,908; 280,896; 300,884; 320,872;
                  340,860; 360,848; 380,836; 400,824],
    tableHeatCapacity=[260,1760; 280,1830; 300,1910; 320,1990;
                  340,2080; 360,2160; 380,2250; 400,2340],
    tableConductivity=[260,0.149; 280,0.146; 300,0.144; 320,0.141;
                  340,0.139; 360,0.137; 380,0.136; 400,0.134],
    tableViscosity=[260,12.23; 280,2.17; 300,0.486; 320,0.141;
                  340,0.053; 360,0.025; 380,0.014; 400,0.009],
    tableVaporPressure=[160,3; 180,10; 200,40; 220,100; 240,300;
                  260,600; 280,1600; 300,3e3; 320,5.5e3]);
//tableVaporPressure is a dummy for now to suppress warnings. Replace with real values.
    annotation (Documentation(info="<html>
<p>Table units:</p>
<p>Temperature: K</p>
<p>Density: kg/m^2</p>
<p>Constant Pressure Specific Heat Capacity: J/(kg-K)</p>
<p>Dynamic Viscosity: N-s/m^2</p>
<p>Thermal Conductivity: W/(m-K)</p>
<p><br><br>Source:</p>
<p>Thermal-Fluids Central: Engine Oil, Unused</p>
<p>URL:https://www.thermalfluidscentral.org/encyclopedia/index.php/Thermophysical_Properties:_Engine_Oil,_Unused</p>
<p>Data references:</p>
<ol>
<li><span style=\"font-family: sans-serif; background-color: #ffffff;\">Bejan, A., 2004, Convection Heat Transfer, 3rd ed., John Wiley &AMP; Sons, New York, NY.</span></li>
<li><span style=\"font-family: sans-serif; background-color: #ffffff;\">Faghri Amir , Zhang Yuwen , Howell John, 2010, Advanced Heat and Mass Transfer, Global Digital Press, Columbia, MO</span></li>
</ol>
</html>"));
end EngineOilUnused;
