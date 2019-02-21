within TRANSFORM.Math;
function variableFactor
  "Calcutes a matrix f from 0 to 1 that relates a ratio of variable to fixed values"
  extends TRANSFORM.Icons.Function;
  input Real[:] variable "Array with variable values";
  input Real[:] fixed "Array with fixed values";
  output Real[size(variable,1), size(fixed,1)] f "Ratio factor matrix";
protected
  Integer nVar=size(variable,1) "Size of variable array";
  Integer nFixed=size(fixed,1) "Size of fixed array";
  Integer nB = if nVar <= nFixed then nVar else nFixed;
  Integer nX = if nVar <= nFixed then nFixed else nVar;
  Real[nB] B = if nVar <= nFixed then variable else fixed;
  Real[nX] X = if nVar <= nFixed then fixed else variable;
  Real[nB,nX] f_int = zeros(nB, nX);
  Real Rmdr "Remainder value";
  Integer j = 0 "index";
  Real dA "Change factor";
algorithm
for i in 1:nB-1 loop
  Rmdr :=B[i];
  if j > 0 then
  Rmdr :=Rmdr - f_int[i, j]*X[j];
  end if;
  while Rmdr > 0 loop
    j :=j + 1;
    dA :=Rmdr - X[j];
    if dA > 0 then
      f_int[i,j] :=1.0;
      Rmdr :=Rmdr - X[j];
    else
      f_int[i,j] := if abs(1.0 - Rmdr/X[j]) <= 10*Modelica.Constants.eps then 1.0 else Rmdr/X[j];
      f_int[i+1,j] := 1.0 - f_int[i, j];
      Rmdr :=0;
    end if;
  end while;
end for;
for i in j+1:nX loop
  f_int[nB,i] := 1.0;
end for;
if nVar <= nFixed then
  f:=f_int;
else
  f:=transpose(f_int);
end if;
  annotation (Documentation(info="<html>
<p>For example,</p>
<p><br>It is desired to model the heat transfer to the wall of a container with liquid and gas, each phase modeled with one node while the wall has some number of nodes with fixed areas. The level of the liquid height varies so the area involved in the heat transfer changes. To capture this ratios of the areas of the wall associated with the heat transfer are needed to create the balance equations for Q_flows and T. This function will return the factor matrix (f) such that</p>
<p>for i in 1:nPhases loop</p>
<p>Q_flows_phase[i] + f[i,:]*Q_flows_wall[:] = 0;</p>
<p>T_phase[i] = fA[i,:]*T_wall[:]; // where fA is calculated from the function meanFactor</p>
<p>end for;</p>
</html>"));
end variableFactor;
