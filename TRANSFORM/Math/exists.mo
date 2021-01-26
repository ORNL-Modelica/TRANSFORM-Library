within TRANSFORM.Math;
function exists
  "Return true or false for if element is found in the vector"
  extends Modelica.Icons.Function;
  input Real e "Search for e";
  input Real v[:] "Real vector";
  input Real eps(min=0) = 0
    "Element e is equal to a element v[i] of vector v if abs(e-v[i]) <= eps";
  output Boolean result "=true if e in v else false";
protected
  Integer i;
algorithm
  result := false;
  i := 1;

  while i <= size(v, 1) and result == false loop
    if abs(v[i] - e) <= eps then
      result := true;
    else
      i := i + 1;
    end if;
  end while;

  annotation (Documentation(info="<html>
<p><b>Syntax</b></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">Vectors.<b>find</b>(e, v);</span></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">Vectors.<b>find</b>(e, v, eps=0);</span></p>
<p><b>Description</b></p>
<p>The function call &quot;<span style=\"font-family: Courier New;\">Vectors.find(e, v)</span>&quot; returns true if input e is in vector <b>v</b>. The test of equality is performed by &quot;abs(e-v[i]) &le; eps&quot;, where &quot;eps&quot; can be provided as third argument of the function. Default is &quot;eps = 0&quot;. </p>
<p><b>Example</b></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">Real v[3] = {1, 2, 3};</span></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">Real e1 = 2;</span></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">Real e2 = 3.01;</span></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">Boolean result;</span></p>
<p style=\"margin-left: 40px;\"><b><span style=\"font-family: Courier New;\">algorithm</span></b></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">result := Vectors.find(e1,v); // = true</span></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">result := Vectors.find(e2,v); // = false</span></p>
<p style=\"margin-left: 40px;\"><span style=\"font-family: Courier New;\">result := Vectors.find(e2,v,eps=0.1); // = true</span></p>
<p><b>See also</b></p>
<p><a href=\"modelica://Modelica.Math.Vectors.isEqual\">Vectors.isEqual</a> </p>
</html>"));
end exists;
