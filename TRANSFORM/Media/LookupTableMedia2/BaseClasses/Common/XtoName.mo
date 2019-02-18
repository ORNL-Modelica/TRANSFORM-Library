within TRANSFORM.Media.LookupTableMedia2.BaseClasses.Common;
function XtoName "A function to convert concentration to substance name"
  extends Modelica.Icons.Function;
  input String substanceName = "";
  input Real[:] composition = {0.0};
  input String delimiter = "|";
  input Boolean debug = false;
  output String result;
protected
  Integer nextIndex;
  Integer inLength;
  String name;
  String rest;
algorithm
  if noEvent(size(composition,1) <= 0) then
    assert(not debug, "You are passing an empty composition vector, returning name only: "+substanceName, level = AssertionLevel.warning);
    result :=substanceName;
  else
    assert(noEvent(size(composition,1)==1), "Your mixture has more than two components, ignoring all but the first element.", level = AssertionLevel.warning);
    inLength  := Modelica.Utilities.Strings.length(substanceName);
    nextIndex := Modelica.Utilities.Strings.find(substanceName, delimiter);
    if noEvent(nextIndex<2) then
      // Assuming there are no special options
      name   := substanceName;
      rest   := "";
    else
      name   := Modelica.Utilities.Strings.substring(substanceName, 1, nextIndex-1);
      rest   := Modelica.Utilities.Strings.substring(substanceName, nextIndex, inLength);
    end if;
    if noEvent(noEvent(composition[1]<=0) or noEvent(composition[1]>=1)) then
      result := substanceName;
    else
      result := name + "-" + String(composition[1]) + rest;
    end if;
  end if;
  if noEvent(debug) then
    Modelica.Utilities.Streams.print(result+" --- "+substanceName);
  end if;
end XtoName;
