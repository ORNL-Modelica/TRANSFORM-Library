within TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models;
model PowerLawTemperature "Power Law Temperature y = A*T^n"

  extends PartialMassDiffusionCoefficient;

  parameter Boolean use_RecordData=false "=true then use predefined data";

  parameter Integer iTable[nC]=fill(1, nC)
    "Index of pre-defined values in data table: See Info page."
    annotation (Dialog(enable=use_RecordData));

  parameter SI.DiffusionCoefficient D_ab0=0 "Pre-exponential factor"
    annotation (Dialog(enable=not use_RecordData));
  parameter SI.DiffusionCoefficient D_abs0[nC]=fill(D_ab0, nC)
    "if non-uniform then set" annotation (Dialog(enable=not use_RecordData));

  parameter SI.MolarEnergy n=0 "Activation energy"
    annotation (Dialog(enable=not use_RecordData));
  parameter SI.MolarEnergy ns[nC]=fill(n, nC) "if non-uniform then set"
    annotation (Dialog(enable=not use_RecordData));

  TRANSFORM.Blocks.DataTable data(table=[6.4854e-26,5.7227])
    "Col 1 = D_ab0; Col 2 = n"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  if use_RecordData then
    for i in 1:nC loop
      D_abs[i] = data.table[iTable[i], 1]*T^data.table[iTable[i], 2];
    end for;
  else
    for i in 1:nC loop
      D_abs[i] = D_abs0[i]*T^ns[i];
    end for;
  end if;

  annotation (defaultComponentName = "massDiffusionCoeff",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model returns the coefficient D_abs using the equation:</p>
<p>D_abs = D_ab0*T^n</p>
<p><br>If pre-defined parameters are to be used then specify the row number of the desired substance(s).</p>
<p><br>Below is the definition associated with each entry of the dataTable:</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Index</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Description</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">D_ab0 [m2/s]</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">n [-]</span></b></p></td>
<td style=\"background-color: #11d200\"><p align=\"center\"><b><span style=\"font-family: Arial,Helvetica,sans-serif; color: #ffffff; background-color: #11d200;\">Source</span></b></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">1</span></p></td>
<td><p><span style=\"font-family: Arial,Helvetica,sans-serif;\">TF_LiFBeF2</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">6.49E-26</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">5.7227</span></p></td>
<td><p align=\"center\"><span style=\"font-family: Arial,Helvetica,sans-serif;\">1. Eq. 2.15, pg. 74</span></p></td>
</tr>
</table>
<p><br><br>Source:</p>
<p><br>1. Stempien thesis</p>
</html>"));
end PowerLawTemperature;
