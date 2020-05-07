within TRANSFORM.PeriodicTable;
function CalculateMolarMass

  input String chemicalFormula="" "Chemical formula (e.g., 'C6H6'";
  output SI.MolarMass molarMass "Molar mass";

protected
  Integer n=Modelica.Utilities.Strings.length(chemicalFormula)
    "Number of characters chemical formula";
  Integer atomicNumber "Atomic number of identified element";
  Integer index=1 "Index within chemicalFormula";
  String symbol "Element symbol";
  TRANSFORM.PeriodicTable.SimpleTable periodicTable
    "Periodic table of elements";
  Integer multiplier "Multiplier for identified element";
algorithm

  molarMass := 0;

  while index <= n loop
    atomicNumber := 0;

    if index < n then
      symbol := Modelica.Utilities.Strings.substring(
        chemicalFormula,
        index,
        index + 1);
      atomicNumber := TRANSFORM.Utilities.Strings.index(symbol, TRANSFORM.PeriodicTable.SimpleTable.symbolbol);
    end if;

    if atomicNumber == 0 then
      symbol := Modelica.Utilities.Strings.substring(
        chemicalFormula,
        index,
        index);
      atomicNumber := TRANSFORM.Utilities.Strings.index(symbol, TRANSFORM.PeriodicTable.SimpleTable.symbolbol);

      if atomicNumber == 0 then
        assert(false, "Unknown chemicalFormula");
      else
        index := index + 1;
      end if;
    else
      index := index + 2;
    end if;

    (index,multiplier) := Modelica.Utilities.Strings.Advanced.scanInteger(
      chemicalFormula, startIndex=index);

    molarMass := molarMass + periodicTable.MM[atomicNumber]*(if multiplier == 0
       then 1 else multiplier);

  end while;
  annotation (Documentation(info="<html>
<p>Returns the molar mass (kg/mol) of a chemical formula.</p>
<p>For example, calling the function with &quot;CF3CH2F&quot; returns 0.102031066 kg/mol.</p>
</html>"));
end CalculateMolarMass;
