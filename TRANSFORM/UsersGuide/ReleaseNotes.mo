within TRANSFORM.UsersGuide;
package ReleaseNotes "Release notes"
  extends TRANSFORM.Icons.ReleaseNotes;

  class Version_1_1_0 "Version 1.1.0 (2026-11-03)"
    extends TRANSFORM.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p><b>Conversion:</b> none needed. Models written for TRANSFORM 1.0 or 0.5 need no change, except in the rare case described under <b>Added</b>. The library now uses three-part version numbers.</p>
<p><b>Results that change:</b></p>
<ul>
<li><code>TRANSFORM.Examples.MoltenSaltReactor.MSDR_noBOP</code> and its component <code>DRACS</code>: several model errors are fixed (issues #111 to #116 and a wrong thimble length in the water tanks). The NaK loop now circulates by natural convection, the drain-tank thimble area is no longer counted twice, the water-tank make-up controller is tuned, and the thimble walls start at the temperature of the fluid beside them.</li>
<li><code>TRANSFORM.Fluid.Volumes.Examples.ExpansionTank2_Test</code>: the outlet resistance is 100 instead of 0.01, so the tested CO2 concentration is a real signal instead of solver noise.</li>
<li><code>TRANSFORM.Utilities.Visualizers.IconColorMap_1D</code>: each element is colored from its own value; before, all took the color of the first. No model in the library uses this block.</li>
<li>Distributed pipe pressure-loss models: during homotopy initialization, pipes that run downward no longer get a negative conductance (#115). The relation used after initialization is unchanged.</li>
</ul>
<p><b>Added:</b> the function <code>massFraction</code> in <code>TRANSFORM.Media.Interfaces.Fluids.PartialMedium</code>, so TRANSFORM fluid media are again subtypes of the Modelica.Fluid medium under MSL 4.1.0, which Dymola 2026x ships. If your own medium extends <code>PartialPureSubstance</code> or <code>TableBased</code> and already declares a <code>massFraction</code>, change that declaration to <code>redeclare function extends massFraction</code> or remove it. Also added: regression tests for <code>MSDR_noBOP</code>, <code>DRACS_Test</code>, <code>MassFraction_Test</code> and <code>IconColorMap_1D_Test</code>, and documentation of <code>C_nominal</code> in <code>TRANSFORM.Nuclear.ReactorKinetics.Data</code> (#117).</p>
<p><b>Compatibility, results unchanged:</b></p>
<ul>
<li>OpenModelica: array modifiers use <code>each</code> where it is required, and the color maps of fluid volumes, pipes and heat exchangers no longer stop code generation (#109).</li>
<li>Graphics annotations use only standard attributes, so Dymola's pedantic check accepts them.</li>
<li>The library declares <code>ExternalMedia</code> 4.0.0 in its <code>uses</code> annotation (#106). ExternalMedia stays optional: without it, TRANSFORM still loads, and only models that use the CoolProp media need it.</li>
</ul>
<p>The full list is in <code>CHANGELOG.md</code> in the <a href=\"https://github.com/ORNL-Modelica/TRANSFORM-Library\">TRANSFORM-Library repository</a>.</p>
</html>"));
  end Version_1_1_0;

  annotation (Documentation(info="<html>
<p>This package holds the release notes of TRANSFORM, one class per released version, newest first. Each class summarizes what changed in that version and whether user models need to be converted.</p>
<p>Changes made since the last release are listed in <code>CHANGELOG.md</code> at the root of the <a href=\"https://github.com/ORNL-Modelica/TRANSFORM-Library\">TRANSFORM-Library repository</a>. They are summarized here when a version is released.</p>
<p>Release notes start with version 1.1.0. Earlier changes are recorded only in the repository's git history.</p>
</html>"));
end ReleaseNotes;
