within TRANSFORM.Math;
function linspaceRepeat_2Dedge
  "Create [m] linearly spaced 2D matrix stored in a [n1,n2,m] matrix from the linear interpolation of 4 edge values"
  extends Modelica.Icons.Function;

  input Real x1[:] "Edge value x[1,:,m]";
  input Real x2[:] "Edge value x[end,:,m]";
  input Real x3[:] "Edge value x[:,1,m]";
  input Real x4[:] "Edge value x[:,end,m]";

  input Integer n1 "Number of rows";
  input Integer n2 "Number of columns";

  input Boolean exposeState[4]={true,true,true,true}
    "= true then set edge to value specified else linspace_1D";

  output Real y[n1,n2,size(x1,1)] "3-D matrix of a repeated 2-D matrix";

protected
  Real row[n2];
  Real col[n1];

  Integer m=size(x1,1);

algorithm

  for i in 1:m loop
    y[:,:,i] := linspace_2Dedge(
      x1[i],
      x2[i],
      x3[i],
      x4[i],
      n1,
      n2,
      exposeState);
  end for;

  annotation (smoothOrder=2, Documentation(info="<html>
</html>"));
end linspaceRepeat_2Dedge;
