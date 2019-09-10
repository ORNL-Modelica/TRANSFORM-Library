within TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models;
model ArrheniusEquation "Arrhenius equation y = A*exp(-(Ea/RT)^b)"
  extends PartialHenrysLawCoefficient;
  parameter Boolean use_RecordData=true "=true then use predefined data";
  parameter Integer iTable[nC]=fill(1, nC)
    "Index of pre-defined values in data table: See Info page."
    annotation (Dialog(enable=use_RecordData));
  parameter TRANSFORM.Units.HenrysLawCoefficient kH0=0 "Pre-exponential factor"
    annotation (Dialog(enable=not use_RecordData));
  parameter TRANSFORM.Units.HenrysLawCoefficient kHs0[nC]=fill(kH0, nC)
    "if non-uniform then set" annotation (Dialog(enable=not use_RecordData));
  parameter SI.MolarEnergy Ea=0 "Activation energy"
    annotation (Dialog(enable=not use_RecordData));
  parameter SI.MolarEnergy Eas[nC]=fill(Ea, nC) "if non-uniform then set"
    annotation (Dialog(enable=not use_RecordData));
  parameter SI.MolarHeatCapacity R=Modelica.Constants.R
    "Universal gas constant";
  parameter Real beta=1.0 "Correction factor";
  parameter Real betas[nC]=fill(beta, nC) "if non-uniform then set";
  TRANSFORM.Blocks.DataTable data(table=[3.98e-07,-34400])
    "Col 1 = kH0; Col 2 = Ea"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  if use_RecordData then
    for i in 1:nC loop
      kHs[i] = data.table[iTable[i], 1]*exp(-(data.table[iTable[i], 2]/(R*T))^
        betas[i]);
    end for;
  else
    for i in 1:nC loop
      kHs[i] = kHs0[i]*exp(-(Eas[i]/(R*T))^betas[i]);
    end for;
  end if;
  annotation (defaultComponentName="henrysLawCoeff",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model returns the coefficient kHs using the equation:</p>
<p>kHs = kH0*exp(-Ea/(R*T)^b)</p>
<p>If pre-defined data parameters are to be used then specify the row number of the desired substance(s).</p>
<p>Below is the definition associated with each entry of the dataTable:</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Index</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Description</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">kH0 [mol/(m3.Pa)]</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Ea [J/mol]</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Source</span></b></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">H2_FLiNaK</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">3.98e-7</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">-3.44e4</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1. Eq. 2.14, pg. 72</span></p></td>
</tr>
</table>
<p><br><br>Source:</p>
<p><br>1. Stempien thesis</p>
</html>"));
end ArrheniusEquation;
