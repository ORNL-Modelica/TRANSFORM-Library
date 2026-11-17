within TRANSFORM.Math;
function linspaceRepeat_3Dface
  "Create [m] 3-D arrays from six face values each, stored in a [n1,n2,n3,m] array"
  extends TRANSFORM.Icons.Function;
  input Real x1[:] "Face values x[1,:,:,m]";
  input Real x2[size(x1, 1)] "Face values x[end,:,:,m]";
  input Real x3[size(x1, 1)] "Face values x[:,1,:,m]";
  input Real x4[size(x1, 1)] "Face values x[:,end,:,m]";
  input Real x5[size(x1, 1)] "Face values x[:,:,1,m]";
  input Real x6[size(x1, 1)] "Face values x[:,:,end,m]";
  input Integer n1 "# of elements in dimension 1";
  input Integer n2 "# of elements in dimension 2";
  input Integer n3 "# of elements in dimension 3";
  output Real y[n1,n2,n3,size(x1, 1)] "4-D array of repeated 3-D arrays";
algorithm
  for iM in 1:size(x1, 1) loop
    y[:, :, :, iM] := linspace_3Dface(
      x1[iM],
      x2[iM],
      x3[iM],
      x4[iM],
      x5[iM],
      x6[iM],
      n1,
      n2,
      n3);
  end for;
  annotation (Documentation(info="<html>
<p><code>linspace_3Dface</code> applied to each of <code>m</code> sets of six face values, for
example the start concentrations of several trace substances.</p>
</html>"));
end linspaceRepeat_3Dface;
