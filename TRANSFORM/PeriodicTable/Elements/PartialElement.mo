within TRANSFORM.PeriodicTable.Elements;
partial record PartialElement
  constant Integer Z=TRANSFORM.Utilities.Strings.index(symbol, TRANSFORM.PeriodicTable.SimpleTable.symbol)
    "Atomic Number";
  constant String symbol "Symbol";
  constant String name=TRANSFORM.PeriodicTable.SimpleTable.name[Z]
    "Element name";
  constant Integer isotopesNatural=TRANSFORM.PeriodicTable.SimpleTable.isotopesNatural[
      Z] "Naturally occuring isotopes";
  constant SI.MolarMass MM=TRANSFORM.PeriodicTable.SimpleTable.MM[Z]
    "Molar Mass";
end PartialElement;
