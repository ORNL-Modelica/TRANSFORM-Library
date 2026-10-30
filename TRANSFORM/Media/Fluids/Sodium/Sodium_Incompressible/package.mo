within TRANSFORM.Media.Fluids.Sodium;
package Sodium_Incompressible "Sodium | Incompressible"
  extends Modelica.Media.Incompressible.TableBased(
  T_default=673.15,
  npol=1,
    mediumName="Sodium: Incompressible",
    T_min=273.15,
    T_max=1600,
    TinK=true,
    T0=273.15,
    tableDensity= [400,919.270700382029; 510,894.749847221324;
        620,869.881240419558; 730,844.633935129612; 840,818.972105275475; 950,792.85389235779;
        1060,766.229879724843; 1170,739.041031650064; 1280,711.215848143479; 1390,
        682.666336612332; 1500,653.28213695278],
    tableHeatCapacity=[400,1371.59642212103; 510,1330.10882636904;
        620,1295.92158276118; 730,1270.95754009594; 840,1255.95467003723; 950,1251.21267888756;
        1060,1256.83660163159; 1170,1272.86076088577; 1280,1299.34805204984; 1390,
        1336.48788993548; 1500,1384.70928828653],
    tableConductivity=[400,87.224272; 510,79.420329458; 620,
        72.514394224; 730,66.411896086; 840,61.018264832; 950,56.23893025; 1060,
        51.979322128; 1170,48.144870254; 1280,44.641004416; 1390,41.373154402; 1500,
        38.24675],
    tableViscosity=[400,0.000599188590151776; 510,0.000403091718772527;
        620,0.000307399608124831; 730,0.000251683212281201; 840,0.000215450007462544;
        950,0.000190045783652517; 1060,0.000171241394099074; 1170,0.000156742806230198;
        1280,0.000145204216822729; 1390,0.000135786434220139; 1500,0.000127939981840873],
    tableVaporPressure=[400,0.000180148926728154; 510,0.146178655003336;
        620,10.8142179680651; 730,215.952980163263; 840,1950.44032194506; 950,10507.1195722124;
        1060,39682.7097921993; 1170,116203.15925603; 1280,281833.767938015; 1390,
        592225.167743765; 1500,1113019.69603523]);

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
end Sodium_Incompressible;
