within TRANSFORM.Obsolete.Math;
package Interpolation
annotation (obsolete="Obsolete package - to be removed with its compiled libraries in the next minor release",
  Documentation(info="<html>
<p>Obsolete. 2-D interpolation of tables read from files, written for the table-based media in <code>Obsolete.Media.LookupTableMedia</code>. It needs two compiled libraries that TRANSFORM ships for Linux only (<code>libnoname</code> and the GNU Scientific Library). It is kept so that models written for earlier versions keep working, and will be removed, with those libraries, in the next minor release. For 2-D table interpolation use <code>Modelica.Blocks.Tables.CombiTable2Ds</code> or <code>TRANSFORM.Math.interpolate2D</code>.</p>
<p>Provides interpolation methods for externally tabulated data based on external functions.</p>
</html>"));
end Interpolation;
