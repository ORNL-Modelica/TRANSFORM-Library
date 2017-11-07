within TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models;
model ArrheniusEquation "Arrhenius equation y = A*exp(-(Ea/RT)^b)"

  extends PartialSievertsLawCoefficient;

  parameter Boolean use_RecordData=true "=true then use predefined data";

  parameter Integer iTable[nC]=fill(1, nC)
    "Index of pre-defined values in data table: See Info page."
    annotation (Dialog(enable=use_RecordData));

  parameter Real kS0=0 "Pre-exponential factor [mol/(m3.Pa^(0.5)]"
    annotation (Dialog(enable=not use_RecordData));
  parameter Real kSs0[nC]=fill(kS0, nC) "if non-uniform then set"
    annotation (Dialog(enable=not use_RecordData));
  parameter SI.MolarEnergy deltaH=0 "Heat of Solution"
    annotation (Dialog(enable=not use_RecordData));
  parameter SI.MolarEnergy deltaHs[nC]=fill(deltaH, nC)
    "if non-uniform then set" annotation (Dialog(enable=not use_RecordData));
  parameter SI.MolarHeatCapacity R=Modelica.Constants.R
    "Universal gas constant";
  parameter Real beta=1.0 "Correction factor";
  parameter Real betas[nC]=fill(beta, nC) "if non-uniform then set";

  TRANSFORM.Blocks.DataTable data(table=[0.758,15700; 0.427,13900; 7.59,26700; 1.98,
        28500; 0.517,17500; 1.98,23100; 1.84,17200; 0.137,31200; 0.953,10700; 0.955,
        26700; 0.019,-19200; 0.046,39700; 0.438,-29000; 0.436,28600; 0.266,6900;
        0.564,15800; 0.792,38900; 34000,35800; 3.3,37400; 0.258,56700; 1.49,101000;
        0.207,46000; 77.9,99400; 0.0189,16800; 5900,96600])
    "Col 1 = kS0; Col 2 = Ea"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  if use_RecordData then
    for i in 1:nC loop
      kSs[i] = data.table[iTable[i], 1]*exp(-(data.table[iTable[i], 2]/(R*T))^
        betas[i]);
    end for;
  else
    for i in 1:nC loop
      kSs[i] = kSs0[i]*exp(-(deltaHs[i]/(R*T))^betas[i]);
    end for;
  end if;

  annotation (defaultComponentName="sievertsLawCoeff",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model returns the coefficient kSs using the equation:</p>
<p>kSs = kS0*exp(-deltaH/(R*T)^b)</p>
<p>If pre-defined data parameters are to be used then specify the row number of the desired substance(s).</p>
<p><br>Below is the definition associated with each entry of the dataTable:</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Index</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Description</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">kS0 [mol/(m3.Pa^(0.5))]</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">deltaH [J/mol]</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Source</span></b></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_304SS</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">7.58E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.57E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_316SS</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.27E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.39E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">3</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_YUS170</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">7.59E+00</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.67E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">4</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Inconel600</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.98E+00</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.85E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">5</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_InconelX</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">5.17E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.75E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">6</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Nichrom</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.98E+00</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.31E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">7</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Monel</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.84E+00</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.72E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">8</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Cu</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.37E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.12E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">9</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Ni</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">9.53E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.07E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">10</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_gammaFe</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">9.55E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.67E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">11</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Graphite</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.90E-02</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">-1.92E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">12</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Aluminum</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.60E-02</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.97E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">13</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Vanadium</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.38E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">-2.90E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">14</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_RAFM_Steels</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.36E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.86E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">15</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Austenitic_StainlessSteel</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.66E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">6.90E+03</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">16</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Nickel</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">5.64E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.58E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">17</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Copper</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">7.92E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.89E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">18</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Zirconium</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.40E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.58E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">19</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Molybdenum</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.30E+00</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.74E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">20</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Silver</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.58E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">5.67E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">21</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Tungsten</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.49E+00</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.01E+05</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">22</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Platinum</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2.07E-01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">4.60E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">23</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Gold</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">7.79E+01</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">9.94E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">24</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Beryllium_a</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.89E-02</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1.68E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">25</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_Beryllium_b</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">5.90E+03</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">9.66E+04</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">2</span></p></td>
</tr>
</table>
<p><br><br><br><br>Source:</p>
<p><br>1. TANABE, T., YAMANISHI, Y., SAWADA, K., IMOTO, S., &ldquo;Hydrogen Transport in Stainless Steels,&rdquo; Journal of Nuclear Materials. 122 &AMP; 123, 1568&ndash;1572 (1984).</p>
<p>2. CAUSEY, R.A., KARNESKY, R.A., SAN MARCHI, C., 4.16 - Tritium Barriers and Tritium Diffusion in Fusion Reactors, in: Konings, R.J.M. (Ed.), &ldquo;Comprehensive Nuclear Materials,&rdquo; Elsevier, Oxford, 2012: pp. 511&ndash;549.</p>
</html>"));
end ArrheniusEquation;
