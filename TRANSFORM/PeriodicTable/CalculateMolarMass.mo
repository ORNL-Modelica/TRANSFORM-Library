within TRANSFORM.PeriodicTable;
function CalculateMolarMass

  input String symbol="LiF2";
  output Real molarMass;
protected
  Integer n=Modelica.Utilities.Strings.length(symbol);
  Integer sym_index;
  Integer index=1;
  String sym;
  TRANSFORM.PeriodicTable.SimpleTable periodicTable;
  Integer multiplier;
algorithm

  molarMass := 0;

  while index <= n loop
    sym_index := 0;

    if index < n then
      sym := Modelica.Utilities.Strings.substring(
        symbol,
        index,
        index + 1);
      sym_index := TRANSFORM.Utilities.Strings.index(sym, TRANSFORM.PeriodicTable.SimpleTable.symbol);
    end if;

    if sym_index == 0 then
      sym := Modelica.Utilities.Strings.substring(
        symbol,
        index,
        index);
      sym_index := TRANSFORM.Utilities.Strings.index(sym, TRANSFORM.PeriodicTable.SimpleTable.symbol);

      if sym_index == 0 then
        assert(false, "Unknown symbol");
      else
        index := index + 1;
      end if;
    else
      index := index + 2;
    end if;

    (index,multiplier) := Modelica.Utilities.Strings.Advanced.scanInteger(
      symbol, startIndex=index);

    molarMass := molarMass + periodicTable.MM[sym_index]*(if multiplier == 0
       then 1 else multiplier);
//     Modelica.Utilities.Streams.print(String(sym_index));
//     Modelica.Utilities.Streams.print(String(multiplier));

  end while;
  annotation ();
end CalculateMolarMass;
