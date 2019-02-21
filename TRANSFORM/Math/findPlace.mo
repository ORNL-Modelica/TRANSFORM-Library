within TRANSFORM.Math;
function findPlace
  "Find the index next to which the target value fits in the array (requires monotonic array of positive values)"
  input Real e "Search for e";
  input Real v[:] "Real vector";
  output Integer result "result=0, if e < v[1], result=size(v,1) if e > v[end]";
protected
  Integer i=1;
  Integer j=-1;
algorithm

  if e < v[1] then
    j := 0;
  elseif e >= v[end] then
    j := size(v, 1);
  else
    while j == -1 and i <= size(v, 1) loop
      if e <= v[i] then
        j := i - 1;
      end if;
      i := i + 1;
    end while;
  end if;

  result := j;


  annotation (smoothOrder=1, Documentation(info="<html>
<p>NOTE: Currently only handles montonically increasing, positive array values.</p>
<p>Example:</p>
<p>e = 5.5</p>
<p>v = {1,3,7,9,11}</p>
<p>result = 2 because 5.5 falls between index 2 and 3 of v</p>
<p><br>Example 2:</p>
<p>e = 3</p>
<p>v = {1,3,7,9,11}</p>
<p>result = 2</p>
<p><br>Example 3:</p>
<p>e = 12</p>
<p>v = {1,3,7,9,11}</p>
<p>result = 5</p>
</html>"));
end findPlace;
