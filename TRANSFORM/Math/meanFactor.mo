within TRANSFORM.Math;
function meanFactor
  "Calcutes a matrix fA and f that returns the calculates a mean value based on a ratio of variable to fixed values using variableFactor"
  extends TRANSFORM.Icons.Function;
  input Real[:] variable "Array with variable values";
  input Real[:] fixed "Array with fixed values";
  output Real[size(variable,1), size(fixed,1)] fA "Ratio factor matrix";
  output Real[size(variable,1), size(fixed,1)] f "Ratio factor matrix";
protected
  Integer nVar=size(variable,1) "Size of variable array";
  Integer nFixed=size(fixed,1) "Size of fixed array";
  Real Asum "Summation of fixed values within variable value";
  Real[nVar,nFixed] f_int=TRANSFORM.Math.variableFactor(variable,fixed);
algorithm
  for i in 1:nVar loop
    Asum :=0;
    for j in 1:nFixed loop
      Asum :=Asum + f_int[i, j]*fixed[j];
    end for;
    for j in 1:nFixed loop
      if Asum < Modelica.Constants.eps then
        fA[i,j] :=0;
      else
        fA[i,j] :=f_int[i, j]*fixed[j]/Asum;
      end if;
    end for;
  end for;
  f :=f_int;
  annotation (Documentation(info="<html>
<p>For example,</p>
<p><br>It is desired to model the heat transfer to the wall of a container with liquid and gas, each phase modeled with one node while the wall has some number of nodes with fixed areas. The level of the liquid height varies so the area involved in the heat transfer changes. To capture this ratios of the areas of the wall associated with the heat transfer are needed to create the balance equations for Q_flows and T. This function will return the factor matrix (fA) such that</p>
<p>for i in 1:nPhases loop</p>
<p>Q_flows_phase[i] + f[i,:]*Q_flows_wall[:] = 0; // where f is from function variableFactor</p>
<p>T_phase[i] = fA[i,:]*T_wall[:];</p>
<p>end for;</p>
</html>"));
end meanFactor;
