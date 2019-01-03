within TRANSFORM.Math;
function linspace_2Dedge
  "Create a linearly spaced 2D matrix from the linear interpolation of 4 edge values"
  extends Modelica.Icons.Function;

  input Real x1 "Edge value x[1,:]";
  input Real x2 "Edge value x[end,:]";
  input Real x3 "Edge value x[:,1]";
  input Real x4 "Edge value x[:,end]";

  input Integer n1 "Number of rows";
  input Integer n2 "Number of columns";

  input Boolean exposeState[4]={true,true,true,true}
    "= true then set edge to value specified else linspace_1D";

  output Real y[n1,n2] "2-D matrix";

protected
  Real row[n2];
  Real col[n1];

algorithm

  if n1 == 1 and n2 == 1 then
    y[1, 1] := 0.25*(x1 + x3 + x4 + x2);

  elseif n1 == 1 then
    y[1, :] := linspace(x3,x4,n2);

  elseif n2 == 1 then
    y[:, 1] := linspace(x1,x2,n1);

  else
  if exposeState[1] and exposeState[2] and exposeState[3] and exposeState[4] then
    y[1, :] := x1*ones(n2);
    y[n1, :] := x2*ones(n2);
    y[:, 1] := x3*ones(n1);
    y[:, n2] := x4*ones(n1);

    y[1, 1] := 0.5*(x1 + x3);
    y[1, n2] := 0.5*(x1 + x4);
    y[n1, 1] := 0.5*(x2 + x3);
    y[n1, n2] := 0.5*(x2 + x4);

  elseif exposeState[1] and exposeState[2] and exposeState[3] and not exposeState[4] then
    y[1, :] := x1*ones(n2);
    y[n1, :] := x2*ones(n2);
    y[:, 1] := x3*ones(n1);
    y[:, n2] := 0.5*(x4*ones(n1)+linspace(x1,x2,n1));

    y[1, 1] := 0.5*(x1 + x3);
    y[1, n2] := x1;
    y[n1, 1] := 0.5*(x2 + x3);
    y[n1,n2] := x2;

  elseif exposeState[1] and exposeState[2] and not exposeState[3] and exposeState[4] then
    y[1, :] := x1*ones(n2);
    y[n1, :] := x2*ones(n2);
    y[:, 1] := 0.5*(x3*ones(n1)+linspace(x1,x2,n1));
    y[:, n2] := x4*ones(n1);

    y[1, 1] := x1;
    y[1, n2] := 0.5*(x1 + x4);
    y[n1, 1] := x2;
    y[n1, n2] := 0.5*(x2 + x4);

  elseif exposeState[1] and not exposeState[2] and exposeState[3] and exposeState[4] then
    y[1, :] := x1*ones(n2);
    y[n1, :] := 0.5*(x2*ones(n2)+linspace(x3,x4,n2));
    y[:, 1] := x3*ones(n1);
    y[:, n2] := x4*ones(n1);

    y[1, 1] := 0.5*(x1 + x3);
    y[1, n2] := 0.5*(x1 + x4);
    y[n1, 1] := x3;
    y[n1, n2] := x4;

  elseif not exposeState[1] and exposeState[2] and exposeState[3] and exposeState[4] then
    y[1, :] := 0.5*(x1*ones(n2)+linspace(x3,x4,n2));
    y[n1, :] := x2*ones(n2);
    y[:, 1] := x3*ones(n1);
    y[:, n2] := x4*ones(n1);

    y[1, 1] := x3;
    y[1, n2] := x4;
    y[n1, 1] := 0.5*(x2 + x3);
    y[n1, n2] := 0.5*(x2 + x4);

  elseif exposeState[1] and exposeState[2] and not exposeState[3] and not exposeState[4] then
    y[1, :] := x1*ones(n2);
    y[n1, :] := x2*ones(n2);
    y[:, 1] := 0.5*(x3*ones(n1)+linspace(x1,x2,n1));
    y[:, n2] := 0.5*(x4*ones(n1)+linspace(x1,x2,n1));

    y[1, 1] := x1;
    y[1, n2] := x1;
    y[n1, 1] := x2;
    y[n1, n2] := x2;

  elseif exposeState[1] and not exposeState[2] and not exposeState[3] and exposeState[4] then
    y[1, :] := x1*ones(n2);
    y[n1, :] := 0.5*(x2*ones(n2)+linspace(x3,x4,n2));
    y[:, 1] := 0.5*(x3*ones(n1)+linspace(x1,x2,n1));
    y[:, n2] := x4*ones(n1);

    y[1, 1] := x1;
    y[1, n2] := 0.5*(x1 + x4);
    y[n1, 1] := 0.5*(x2 + x3);
    y[n1, n2] := x4;

  elseif not exposeState[1] and not exposeState[2] and exposeState[3] and exposeState[4] then
    y[1, :] := 0.5*(x1*ones(n2)+linspace(x3,x4,n2));
    y[n1, :] := 0.5*(x2*ones(n2)+linspace(x3,x4,n2));
    y[:, 1] := x3*ones(n1);
    y[:, n2] := x4*ones(n1);

    y[1, 1] := x3;
    y[1, n2] := x4;
    y[n1, 1] := x3;
    y[n1, n2] := x4;

  elseif exposeState[1] and not exposeState[2] and not exposeState[3] and not exposeState[4] then
    y[1, :] := x1*ones(n2);
    y[n1, :] := 0.5*(x2*ones(n2)+linspace(x3,x4,n2));
    y[:, 1] := 0.5*(x3*ones(n1)+linspace(x1,x2,n1));
    y[:, n2] := 0.5*(x4*ones(n1)+linspace(x1,x2,n1));

    y[1, 1] := x1;
    y[1, n2] := x1;
    y[n1, 1] := 0.5*(x2 + x3);
    y[n1, n2] := 0.5*(x2 + x4);

  elseif not exposeState[1] and not exposeState[2] and not exposeState[3] and exposeState[4] then
    y[1, :] := 0.5*(x1*ones(n2)+linspace(x3,x4,n2));
    y[n1, :] := 0.5*(x2*ones(n2)+linspace(x3,x4,n2));
    y[:, 1] := 0.5*(x3*ones(n1)+linspace(x1,x2,n1));
    y[:, n2] := x4*ones(n1);

    y[1, 1] := 0.5*(x1 + x3);
    y[1, n2] := x4;
    y[n1, 1] := 0.5*(x2 + x3);
    y[n1, n2] := x4;

  elseif exposeState[1] and not exposeState[2] and exposeState[3] and not exposeState[4] then
    y[1, :] := x1*ones(n2);
    y[n1, :] := 0.5*(x2*ones(n2)+linspace(x3,x4,n2));
    y[:, 1] := x3*ones(n1);
    y[:, n2] := 0.5*(x4*ones(n1)+linspace(x1,x2,n1));

    y[1, 1] := 0.5*(x1 + x3);
    y[1, n2] := x1;
    y[n1, 1] := x3;
    y[n1, n2] := 0.5*(x2 + x4);

  elseif not exposeState[1] and exposeState[2] and not exposeState[3] and exposeState[4] then
    y[1, :] := 0.5*(x1*ones(n2)+linspace(x3,x4,n2));
    y[n1, :] := x2*ones(n2);
    y[:, 1] := 0.5*(x3*ones(n1)+linspace(x1,x2,n1));
    y[:, n2] := x4*ones(n1);

    y[1, 1] := 0.5*(x1 + x3);
    y[1, n2] := x4;
    y[n1, 1] := x2;
    y[n1, n2] := 0.5*(x2 + x4);

  elseif not exposeState[1] and exposeState[2] and exposeState[3] and not exposeState[4] then
    y[1, :] := 0.5*(x1*ones(n2)+linspace(x3,x4,n2));
    y[n1, :] := x2*ones(n2);
    y[:, 1] := x3*ones(n1);
    y[:, n2] := 0.5*(x4*ones(n1)+linspace(x1,x2,n1));

    y[1, 1] := x3;
    y[1, n2] := 0.5*(x1 + x4);
    y[n1, 1] := 0.5*(x2 + x3);
    y[n1, n2] := x2;

  elseif not exposeState[1] and exposeState[2] and not exposeState[3] and not exposeState[4] then
    y[1, :] := 0.5*(x1*ones(n2)+linspace(x3,x4,n2));
    y[n1, :] := x2*ones(n2);
    y[:, 1] := 0.5*(x3*ones(n1)+linspace(x1,x2,n1));
    y[:, n2] := 0.5*(x4*ones(n1)+linspace(x1,x2,n1));

    y[1, 1] := 0.5*(x1 + x3);
    y[1, n2] := 0.5*(x1 + x4);
    y[n1, 1] := x2;
    y[n1, n2] := x2;

  elseif not exposeState[1] and not exposeState[2] and exposeState[3] and not exposeState[4] then
    y[1, :] := 0.5*(x1*ones(n2)+linspace(x3,x4,n2));
    y[n1, :] := 0.5*(x2*ones(n2)+linspace(x3,x4,n2));
    y[:, 1] := x3*ones(n1);
    y[:, n2] := 0.5*(x4*ones(n1)+linspace(x1,x2,n1));

    y[1, 1] := x3;
    y[1, n2] := 0.5*(x1 + x4);
    y[n1, 1] := x3;
    y[n1, n2] := 0.5*(x2 + x4);

  elseif not exposeState[1] and not exposeState[2] and not exposeState[3] and not exposeState[4] then
    y[1, :] := 0.5*(x1*ones(n2)+linspace(x3,x4,n2));
    y[n1, :] := 0.5*(x2*ones(n2)+linspace(x3,x4,n2));
    y[:, 1] := 0.5*(x3*ones(n1)+linspace(x1,x2,n1));
    y[:, n2] := 0.5*(x4*ones(n1)+linspace(x1,x2,n1));

    y[1, 1] := 0.5*(x1 + x3);
    y[1, n2] := 0.5*(x1 + x4);
    y[n1, 1] := 0.5*(x2 + x3);
    y[n1, n2] := 0.5*(x2 + x4);

  else
    assert(false,"Model structure unknown");
  end if;

  for i in 2:n1 - 1 loop
    for j in 2:n2 - 1 loop
      row := linspace(
        y[i, 1],
        y[i, n2],
        n2);
      col := linspace(
        y[1, j],
        y[n1, j],
        n1);
      y[i, j] := 0.5*(row[j] + col[i]);
    end for;
  end for;
end if;

  annotation (smoothOrder=2, Documentation(info="<html>
<p>For example:</p>
<p>For x1=0, x2=10, x3=-5, x4 = 5, n1=5, and n2=3.</p>
<p>The returned matrix is y[5,3]</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p align=\"right\">-2.5</p></td>
<td><p align=\"right\">0</p></td>
<td><p align=\"right\">2.5</p></td>
</tr>
<tr>
<td><p align=\"right\">-5</p></td>
<td><p align=\"right\">1.25</p></td>
<td><p align=\"right\">5</p></td>
</tr>
<tr>
<td><p align=\"right\">-5</p></td>
<td><p align=\"right\">2.5</p></td>
<td><p align=\"right\">5</p></td>
</tr>
<tr>
<td><p align=\"right\">-5</p></td>
<td><p align=\"right\">3.75</p></td>
<td><p align=\"right\">5</p></td>
</tr>
<tr>
<td><p align=\"right\">2.5</p></td>
<td><p align=\"right\">10</p></td>
<td><p align=\"right\">7.5</p></td>
</tr>
</table>
<p><br><br><br>Notice that the center edge values are consistent with the specified input. The corner vlaues are linear interpolations of the adjacent values.</p>
<p><br>The exposeState options either hold the edge value (=true) or ignore the edge value (=false) and apply linear interpolation appropriately. This capability was made to assist with initialization of discritized models.</p>
<p>With the same input as above but with exposeState={true,false,true,false} the result is:</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p align=\"right\">0</p></td>
<td><p align=\"right\">0</p></td>
<td><p align=\"right\">2.5</p></td>
</tr>
<tr>
<td><p align=\"right\">-1.25</p></td>
<td><p align=\"right\">1.5625</p></td>
<td><p align=\"right\">5</p></td>
</tr>
<tr>
<td><p align=\"right\">0</p></td>
<td><p align=\"right\">2.5</p></td>
<td><p align=\"right\">5</p></td>
</tr>
<tr>
<td><p align=\"right\">1.25</p></td>
<td><p align=\"right\">3.4375</p></td>
<td><p align=\"right\">5</p></td>
</tr>
<tr>
<td><p align=\"right\">2.5</p></td>
<td><p align=\"right\">5</p></td>
<td><p align=\"right\">5</p></td>
</tr>
</table>
</html>"));
end linspace_2Dedge;
