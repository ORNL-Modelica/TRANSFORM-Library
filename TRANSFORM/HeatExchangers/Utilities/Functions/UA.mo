within TRANSFORM.HeatExchangers.Utilities.Functions;
function UA
  "Calculation of overall heat transfer conductance, coefficient and total resistance with any combination of parallel or series thermal resistance sections"
  extends Modelica.Icons.Function;

  input Integer n "Total number of sections of thermal resistances";
  input Boolean[n] isSeries "Define each individual section as series or parallel resistances";
  input SI.ThermalResistance[n,:] R "Thermal resistances (e.g., t/(kA). Each row is a section.";

  output SI.ThermalConductance UA "Overall heat transfer conductance";
  output SI.ThermalResistance R_total "Total thermal resistances";

protected
  Integer[:] Rsize = size(R);
  Integer nRow = Rsize[1] "Total number of sections of thermal resistances";
  Integer nColumn = Rsize[2] "Number of thermal resistances in each section";
  SI.ThermalResistance[n] Rsums "Appropriate summation of each section";
  SI.ThermalResistance modR "Modified R to account for zeros in parallel resistances";

algorithm
  R_total :=0;

  assert(n==size(isSeries,1), "The number of values in isSeries must be equal to the number of sections of thermal resistances 'n'");
  assert(n==nRow, "The number of rows in R must be equal to the number of sections of thermal resistances 'n'");

  for i in 1:nRow loop
    if isSeries[i] then
      Rsums[i] := sum(R[i, :]);
    else
      modR :=0;
      for j in 1:nColumn loop
        if R[i,j] <> 0 then
          modR :=modR + 1/R[i, j];
        else
          modR :=modR;
        end if;
      end for;
      Rsums[i] := 1/modR;
    end if;
  end for;
  R_total :=sum(Rsums);

  UA :=1/R_total;

  annotation (Documentation(info="<html>
<p>The Peclet numver is defined to be the ratio of the rate of&nbsp;advection&nbsp;of a physical quantity by the flow to the rate of&nbsp;diffusion&nbsp;of the same quantity driven by an appropriate gradient.</p>
<p> In the context of species or&nbsp;mass transfer, the P&eacute;clet number is the product of the&nbsp;Reynolds number&nbsp;and the&nbsp;Schmidt number. </p>
<ul>
<li>Pe = Re*Sc</li>
</ul>
<p>In the context of the&nbsp;thermal fluids, the thermal Peclet number is equivalent to the product of the&nbsp;Reynolds number&nbsp;and the&nbsp;Prandtl number.</p>
<ul>
<li>Pe = Re*Pr</li>
</ul>
</html>"));
end UA;
