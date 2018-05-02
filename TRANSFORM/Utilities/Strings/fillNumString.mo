within TRANSFORM.Utilities.Strings;
function fillNumString "Create array of strings with option to number"

  extends Modelica.Icons.Function;
  input Integer n(min=0) = 1 "Number of occurrences";
  input String string=" " "String value";
  input Integer iStart = 1 "Value to start numbering if number=true";
  input Boolean number=true "=true to add extensions to string (i.e., {string_1, string_n...})";

  output String[n] arrayString "String array";

protected
  Integer iNum=iStart;
algorithm

  if number then
  for i in 1:n loop
     arrayString[i] := Modelica.Utilities.Strings.replace(string + "_" + Modelica.Math.Vectors.toString({iNum})," ","");
     iNum :=iNum + 1;
  end for;
  else
    arrayString := fill(string,n);
  end if;

  annotation (Documentation(info="<html>
<p>Creates an array of strings with the option to enumerate the strings starting from a user specified number.</p>
<p>fillString(2,&quot;hi&quot;,iStart=1,<span style=\"font-family: Courier New;\">number</span>=true)</p>
<p>= {&quot;hi_1&quot;,&quot;hi_2&quot;}</p>
</html>"));
end fillNumString;
