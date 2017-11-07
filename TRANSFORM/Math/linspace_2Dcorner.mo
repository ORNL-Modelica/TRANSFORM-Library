within TRANSFORM.Math;
function linspace_2Dcorner
  "Create a linearly spaced 2D matrix from the linear interpolation of 4 corner values"
  extends Modelica.Icons.Function;

  input Real x1 "Corner value x[1,1]";
  input Real x2 "Corner value x[1,end]";
  input Real x3 "Corner value x[end,1]";
  input Real x4 "Corner value x[end,end]";

  input Integer n1 "Number of rows";
  input Integer n2 "Number of columns";

  output Real y[n1,n2] "2-D matrix";

protected
  Real row[n2];
  Real col[n1];

algorithm

  if n1 == 1 and n2 == 1 then
    y[1, 1] := 0.25*(x1 + x2 + x3 + x4);
  elseif n1 == 1 then
    y[1, :] := linspace(
      0.5*(x1 + x3),
      0.5*(x2 + x4),
      n2);
  elseif n2 == 1 then
    y[:, 1] := linspace(
      0.5*(x1 + x2),
      0.5*(x3 + x4),
      n1);
  else
    y[1, :] := linspace(
      x1,
      x2,
      n2);
    y[:, n2] := linspace(
      x2,
      x4,
      n1);
    y[:, 1] := linspace(
      x1,
      x3,
      n1);
    y[n1, :] := linspace(
      x3,
      x4,
      n2);

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
</html>"));
end linspace_2Dcorner;
