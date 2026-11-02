within TRANSFORM.Nuclear.ReactorKinetics;
package Data
  annotation (Documentation(info="<html>
<p>Data records for the trace substances tracked with reactor kinetics: delayed-neutron precursor groups, fission products, decay heat, tritium and corrosion products.</p>
<h4>Nominal values (<code>C_nominal</code>)</h4>
<p>When a medium takes its <code>C_nominal</code> from these records, volumes and pipes integrate the trace inventories scaled by it (<code>der(mCs_scaled) = mCbs ./ Medium.C_nominal</code>). This does not change the equations; it sets the error scale of each species, but only in tools that integrate <code>mCs_scaled</code>. Tools that honour the <code>StateSelect.prefer</code> on the concentrations <code>Cs</code>, such as Dymola, integrate <code>Cs</code> instead, and <code>C_nominal</code> has little effect.</p>
<p>Most records use a placeholder of 1e14 for every species. Inventories differ by many orders of magnitude between species and components, so where the scaling matters, set <code>C_nominal</code> per species in your own record:</p>
<pre>record MyPrecursorGroups
  extends TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_FLiBeFueledSalt(
    C_nominal={...});
end MyPrecursorGroups;</pre>
</html>"));
end Data;
