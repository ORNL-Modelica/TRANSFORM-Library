within TRANSFORM.Math;
function indexFilter "Return array of indices from source contained or not contained in target"

  input Integer[:] source;
  input Integer[:] target;
  input Boolean contained = true;

  output Integer[if contained then size(target,1) else size(source,1)-size(target,1)] result;

protected
  Integer nS = size(source,1);
  Integer nT = size(target,1);

  Integer j = 0;
  Integer val;

algorithm

  assert(nS>nT,"source array must be larger than target array");

  for i in 1:nS loop
    val := Modelica.Math.Vectors.find(source[i], target);
    if contained then
      if val > 0 then
        j := j + 1;
        result[j] :=source[i];
      end if;
    else
      if val == 0 then
        j := j + 1;
        result[j] :=source[i];
      end if;
    end if;
  end for;

  annotation (Documentation(info="<html>
<p>The return array is the size of the target array (if contained=true) or size of the difference of the arrays (if contained=false).</p>
<p>If a return value is 0 that means there was no match for that array value.</p>
<p><br>For example:</p>
<p><span style=\"font-family: Courier New;\">source[:]&nbsp;=&nbsp;{1,2,4,8,3};</span></p>
<p><span style=\"font-family: Courier New;\">target[3]&nbsp;=&nbsp;{3,1,8};</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">If </span><span style=\"font-family: Courier New;\">contained&nbsp;=&nbsp;true; then:</span></p>
<p><br><span style=\"font-family: Courier New;\">y = {1,8,3}</span></p>
<p><br><span style=\"font-family: Courier New;\">If contained = false; then:</span></p>
<p><span style=\"font-family: Courier New;\">y = {2,4}</span></p>
</html>"));
end indexFilter;
