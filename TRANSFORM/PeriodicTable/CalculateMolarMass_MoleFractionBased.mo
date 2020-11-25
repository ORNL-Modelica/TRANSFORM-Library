within TRANSFORM.PeriodicTable;
function CalculateMolarMass_MoleFractionBased

  input String[:] chemicalFormula={""} "Array of each species";
  input Real[size(chemicalFormula,1)] x_i = {1.0} "Mole fraction of each species";
  output SI.MolarMass molarMass "Molar mass";

protected
  Integer n=size(chemicalFormula,1);

algorithm

  assert(abs(1.0 - sum(x_i)) < Modelica.Constants.eps, "Mole fraction must sum to 1");

  molarMass :=sum({CalculateMolarMass(chemicalFormula[i])*x_i[i] for i in 1:n});

  annotation (Documentation(info="<html>
<p>Returns the molar mass (kg/mol) of a chemical formula with mole fraction weighting.</p>
<p>For example, calling the function with</p>
<p><br>chemical formula = {&quot;LiF&quot;,&quot;NaK&quot;,&quot;KF&quot;}</p>
<p>x_i = {0.465,0.115,0.42}</p>
<p>yields</p>
<p>molarMass = 0.102031066 kg/mol.</p>
</html>"));
end CalculateMolarMass_MoleFractionBased;
