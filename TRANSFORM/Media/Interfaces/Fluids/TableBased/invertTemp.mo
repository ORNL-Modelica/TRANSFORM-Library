within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function invertTemp "Function to invert temperatures"
  extends Modelica.Icons.Function;
  input Real[:] table "Table temperature data";
  input Boolean Tink "Flag for Celsius or Kelvin";
  output Real invTable[size(table,1)] "Inverted temperatures";
algorithm
  for i in 1:size(table,1) loop
    invTable[i] := if TinK then 1/table[i] else 1/
      Modelica.Units.Conversions.from_degC(table[i]);
  end for;
  annotation(smoothOrder=3);
end invertTemp;
