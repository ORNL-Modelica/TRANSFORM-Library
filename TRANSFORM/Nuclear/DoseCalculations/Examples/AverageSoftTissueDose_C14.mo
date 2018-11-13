within TRANSFORM.Nuclear.DoseCalculations.Examples;
model AverageSoftTissueDose_C14


  Dose_AlphaBetaTissue dose(A=1.2e5/0.05, E_bar=
        SIadd.Conversions.Functions.Energy_J.from_MeV(0.0495))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><span style=\"font-family: Courier New;\">See example in Section 12.9 Alpha and Low-Energy Beta Emitters Distributed in Tissue (pp. 379-380)</span></p>
<p><br><span style=\"font-family: Courier New;\">Source: J. E. TURNER, Atoms, Radiation, and Radiation Protection, 3., completely revised and enl. ed, Wiley-VCH, Weinheim (2007).</span></p>
</html>"));
end AverageSoftTissueDose_C14;
