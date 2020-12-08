within TRANSFORM.Media.Interfaces.Solids;
package Polynomials_Temp "Temporary Functions operating on polynomials (including polynomial fitting); only to be used in Modelica.Media.Incompressible.TableBased"
extends Modelica.Icons.Package;

annotation (Documentation(info="<html>
<p>
This package contains functions to operate on polynomials,
in particular to determine the derivative and the integral
of a polynomial and to use a polynomial to fit a given set
of data points.
</p>

<p><b>Copyright &copy; 2004-2016, Modelica Association and DLR.</b></p>

<p><i>
This package is <b>free</b> software. It can be redistributed and/or modified
under the terms of the <b>Modelica license</b>, see the license conditions
and the accompanying <b>disclaimer</b> in the documentation of package
Modelica in file \"Modelica/package.mo\".
</i>
</p>

</html>", revisions="<html>
<ul>
<li><i>Oct. 22, 2004</i> by Martin Otter (DLR):<br>
       Renamed functions to not have abbreviations.<br>
       Based fitting on LAPACK<br>
       New function to return the polynomial of an indefinite integral</li>
<li><i>Sept. 3, 2004</i> by Jonas Eborn (Scynamics):<br>
       polyderval, polyintval added</li>
<li><i>March 1, 2004</i> by Martin Otter (DLR):<br>
       first version implemented</li>
</ul>
</html>"));
end Polynomials_Temp;
