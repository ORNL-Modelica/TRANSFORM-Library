within TRANSFORM.UsersGuide;
package ReleaseNotes "Release notes"
  extends TRANSFORM.Icons.ReleaseNotes;

  class Version_1_2_0 "Version 1.2.0 (2026-11-12)"
    extends TRANSFORM.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p><b>Conversion:</b> none needed. Models written for TRANSFORM 1.1.0, 1.0 or 0.5 load without change, except in the rare case described under <b>Added</b>. A few changes can give different results in your own models; each is marked <b>upgrade note</b> in <code>CHANGELOG.md</code> and says how to get the old behaviour back where that makes sense.</p>
<p><b>OpenModelica:</b> with this release many more of the library's examples run in OpenModelica and match Dymola. Most of the fixes are in the library's components, media and functions, so they also help your own models; some are in the examples' start values only. The examples that still do not run in OpenModelica are listed in <code>CHANGELOG.md</code>.</p>
<p><b>Results that change:</b></p>
<ul>
<li>Conduction walls (<code>TRANSFORM.HeatAndMassTransfer</code> conduction models and the walls built on them) now start at <code>Ts_start</code>. Their geometry was computed in an algorithm section, which a tool cannot differentiate, so some walls started at the material's reference temperature (298.15 K for most solids) instead, in OpenModelica always and in Dymola in some models. Upgrade note in <code>CHANGELOG.md</code>.</li>
<li><code>TRANSFORM.Nuclear.ReactorKinetics.Functions.Initial_powerBased_powerHistory</code>: the precursor start values from a power history are now right when the history's power changes; the start values <code>Cs_0</code> and <code>Es_0</code> are no longer ignored without decay heat.</li>
<li>Solid media: OFHC copper conductivity and resistivity follow their table instead of a poor polynomial fit; <code>Cr225Mo1</code> conductivity is held above its table. Conductivity fits that reach zero below 0 K are no longer evaluated below 0 K, which removes a false steady state; no value at a real temperature changes.</li>
<li><code>Molybdenum</code> and <code>Tungsten</code>: in Dymola, their enthalpy at a fixed temperature came out as 0; it is now right.</li>
<li>Examples with corrected starts or data: <code>Pressurizer_withWall_Test</code>, <code>NaturalCirculation</code>, <code>NaturalCirculation2</code> and <code>CIET_nureth</code> (its expansion tank was far too large). <code>DRACS</code>, <code>nParallel_StateBoundary</code>, <code>nParallel_FlowBoundary</code> and <code>nParallel_FlowBoundary_MultiTransferSurface</code> also have corrected starts, which leave their Dymola results unchanged; so does <code>Pressurizer_Test</code>, within its test tolerance.</li>
<li><code>TRANSFORM.Fluid.Volumes.ExpansionTank_1Port</code>: the port pressure's start value includes <code>dheight</code>. The tank documentation now says how to start a tank whose port joins a component that holds a pressure.</li>
</ul>
<p><b>Added:</b> outputs <code>re</code> and <code>im</code> of <code>TRANSFORM.Math.ComplexMath.ccubicRoots</code> (the roots as Real arrays). If your own function replaces <code>ccubicRoots</code> through a <code>replaceable</code> declaration constrained by it, it must now also declare these two outputs; one that extends <code>ccubicRoots</code> must not declare its own <code>re</code> or <code>im</code>. The library now declares <code>SDF</code> 0.4.5 in its <code>uses</code> annotation; only the critical-heat-flux and film-boiling look-up tables need it.</p>
<p><b>Compatibility, results unchanged:</b> several components and functions are rewritten in standard Modelica that OpenModelica accepts (solid-media functions, trace separators, distributed heat transfer, <code>linspace_2D</code> functions, reading the power-history table), and two examples no longer use constructs that only Dymola accepts.</p>
<p>The full list is in <code>CHANGELOG.md</code> in the <a href=\"https://github.com/ORNL-Modelica/TRANSFORM-Library\">TRANSFORM-Library repository</a>.</p>
</html>"));
  end Version_1_2_0;

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
