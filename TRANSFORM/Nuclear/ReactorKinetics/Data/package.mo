within TRANSFORM.Nuclear.ReactorKinetics;
package Data
  annotation (Documentation(info="<html>
<p>Data records for the trace substances tracked with reactor kinetics: delayed-neutron precursor groups, fission products, decay heat, tritium and corrosion products.</p>
<h4>Nominal values of the trace substances (<code>C_nominal</code>)</h4>
<p>Each record sets <code>C_nominal</code>, one value per species. A model that passes them into a fluid medium, for example with <code>C_nominal=kinetics.summary_data.C_nominal</code> as in <a href=\"modelica://TRANSFORM.Examples.MoltenSaltReactor.MSDR_noBOP\">MSDR_noBOP</a>, scales the trace inventories of every volume and pipe by them:</p>
<pre>der(mCs_scaled[i, :]) = mCbs[i, :] ./ Medium.C_nominal;
mCs[i, :] = mCs_scaled[i, :] .* Medium.C_nominal;</pre>
<p>(<a href=\"modelica://TRANSFORM.Fluid.Pipes.BaseClasses.PartialDistributedVolume\">PartialDistributedVolume</a>; lumped volumes do the same). The scaling does not change the equations. It changes how the solver weighs each species' error, and only if the tool integrates <code>mCs_scaled</code>:</p>
<ul>
<li>TRANSFORM declares the concentrations <code>Cs</code> with <code>StateSelect.prefer</code>. Dymola then integrates <code>Cs</code>, and <code>C_nominal</code> has no measurable effect on accuracy. Checked with Dymola 2026x: changing every 1e14 to 1e6 left the point-kinetics tests bit-identical and moved <code>MSDR_noBOP</code> results by at most 6e-4 (relative), at the cost of 55&nbsp;% more steps.</li>
<li>A tool that integrates <code>mCs_scaled</code> uses <code>C_nominal</code> as the error scale. With OpenModelica 1.27.1, species whose inventories are far below 1e14 were reported to show non-physical excursions that per-species values removed (<a href=\"https://github.com/ORNL-Modelica/TRANSFORM-Library/issues/117\">issue #117</a>).</li>
</ul>
<p>Most records ship with a placeholder of 1e14 for every species. No single default fits every model: inventories differ by many orders of magnitude between species and between components, for example between a core and a heat-exchanger tube. To scale the species of your own model, extend the record and set <code>C_nominal</code> per species, near the inventory expected in the main volumes:</p>
<pre>record MyPrecursorGroups
  extends TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_FLiBeFueledSalt(
    C_nominal={...});
end MyPrecursorGroups;</pre>
</html>"));
end Data;
