within TRANSFORM.Utilities.Strings;
function concatenate
  input String strings[:];
  input String delimeter="";
  input Integer delimeterBound=0
    "For adding delimeter on outside of result. 0 = none, 1=left, 2=right, 3=both";
  output String result;
algorithm
  result := strings[1];
  for i in 2:size(strings, 1) loop
    result := result + delimeter + strings[i];
  end for;
  if delimeterBound == 1 or delimeterBound == 3 then
    result := delimeter + result;
  end if;
  if delimeterBound == 2 or delimeterBound == 3 then
    result := result + delimeter;
  end if;
  annotation (Documentation(info="<html>
  <p>Concatentate strings</p>
</html>"));
end concatenate;
