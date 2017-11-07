within TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models;
model ArrheniusEquation "Arrhenius equation y = A*exp(-(Ea/RT)^b)"
  extends PartialMassDiffusionCoefficient;

  parameter Boolean use_RecordData=true "=true then use predefined data";

  parameter Integer iTable[nC]=fill(1, nC)
    "Index of pre-defined values in data table: See Info page."
    annotation (Dialog(enable=use_RecordData));

  parameter SI.DiffusionCoefficient D_ab0=0 "Pre-exponential factor"
    annotation (Dialog(enable=not use_RecordData));
  parameter SI.DiffusionCoefficient D_abs0[nC]=fill(D_ab0, nC)
    "if non-uniform then set" annotation (Dialog(enable=not use_RecordData));

  parameter SI.MolarEnergy Ea=0 "Activation energy"
    annotation (Dialog(enable=not use_RecordData));
  parameter SI.MolarEnergy Eas[nC]=fill(Ea, nC) "if non-uniform then set"
    annotation (Dialog(enable=not use_RecordData));

  parameter SI.MolarHeatCapacity R=Modelica.Constants.R
    "Universal gas constant";

  parameter Real beta=1.0 "Correction factor";
  parameter Real betas[nC]=fill(beta, nC) "if non-uniform then set";

  TRANSFORM.Blocks.DataTable data(table=[9.3e-07,42000; 8.25e-07,49700; 6.32e-07,
        47800; 1.7e-07,37600; 1.36e-07,37700; 4.62e-08,36800; 1.11e-07,37200; 1.43e-07,
        34400; 2.26e-07,29300; 7.43e-07,44100; 6.63e-07,44900; 9e-05,270000; 2e-08,
        16000; 3e-08,4300; 1e-07,13200; 2e-07,49300; 7e-07,39500; 1e-06,38500; 8e-07,
        45300; 4e-08,22300; 9e-07,30100; 0.0006,103000; 6e-07,24700; 5.6e-08,23600;
        3e-11,18300]) "Col 1 = D_ab0; Col 2 = Ea"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  if use_RecordData then
    for i in 1:nC loop
      D_abs[i] = data.table[iTable[i], 1]*exp(-(data.table[iTable[i], 2]/(R*T))^
        betas[i]);
    end for;
  else
    for i in 1:nC loop
      D_abs[i] = D_abs0[i]*exp(-(Eas[i]/(R*T))^betas[i]);
    end for;
  end if;

  annotation (
    defaultComponentName="massDiffusionCoeff",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model returns the coefficient D_abs using the equation:</p>
<p>D_abs = D_ab0*exp(-Ea/(R*T)^b)</p>
<p>If pre-defined data parameters are to be used then specify the row number of the desired substance(s).</p>
<p>Below is the definition associated with each entry of the dataTable:</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Index</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Description</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">D_ab0 [m2/s]</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Ea [J/mol]</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Source</span></b></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">T2_LiFBeF2</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">9.30E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.20E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1. Eq. 2.15, pg. 74</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_304SS</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">8.25E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.97E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_316SS</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">6.32E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.78E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">4</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_YUS170</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.70E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.76E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">5</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Inconel600</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.36E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.77E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">6</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_InconelX</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.62E-08</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.68E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">7</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Nichrom</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.11E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.72E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">8</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Monel</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.43E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.44E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">9</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Cu</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.26E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.93E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">10</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Ni</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">7.43E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.41E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">11</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_gammaFe</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">6.63E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.49E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">12</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Graphite</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">9.00E-05</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.70E+05</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">13</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Aluminum</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.00E-08</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.60E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">14</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Vanadium</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.00E-08</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.30E+03</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">15</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_RAFM_Steels</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.00E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.32E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">16</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Austenitic_StainlessSteel</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.00E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.93E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">17</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Nickel</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">7.00E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.95E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">18</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Copper</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.00E-06</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.85E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">19</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Zirconium</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">8.00E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.53E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">20</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Molybdenum</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.00E-08</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.23E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">21</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Silver</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">9.00E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.01E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">22</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Tungsten</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">6.00E-04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.03E+05</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">23</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Platinum</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">6.00E-07</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.47E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">24</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Gold</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">5.60E-08</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.36E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">25</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Beryllium</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.00E-11</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.83E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
</tr>
</table>
<p><br><br><br><br><br><br><br><br>Source:</p>
<p><br>1. Stempien thesis</p>
<p>2. TANABE, T., YAMANISHI, Y., SAWADA, K., IMOTO, S., &ldquo;Hydrogen Transport in Stainless Steels,&rdquo; Journal of Nuclear Materials. 122 &AMP; 123, 1568&ndash;1572 (1984).</p>
<p>3. CAUSEY, R.A., KARNESKY, R.A., SAN MARCHI, C., 4.16 - Tritium Barriers and Tritium Diffusion in Fusion Reactors, in: Konings, R.J.M. (Ed.), &ldquo;Comprehensive Nuclear Materials,&rdquo; Elsevier, Oxford, 2012: pp. 511&ndash;549.</p>
</html>"));
end ArrheniusEquation;
