within TRANSFORM.Nuclear.DoseCalculations.Examples;
model DoseCalculations_GammaPointSource
  Dose_GammaPointSource dose(
    r=1.7,
    C=SIadd.Conversions.Functions.Activity_Bq.from_Ci(0.1),
    E=SIadd.Conversions.Functions.Energy_J.from_MeV(0.563))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><span style=\"font-family: Courier New;\">See example in Section 12.9 Point Source of Gamma Rays (pp. 381-382)</span></p>
<p><br><span style=\"font-family: Courier New;\">Source: J. E. TURNER, Atoms, Radiation, and Radiation Protection, 3., completely revised and enl. ed, Wiley-VCH, Weinheim (2007).</span></p>
</html>"));
end DoseCalculations_GammaPointSource;
