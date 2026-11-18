within TRANSFORM.UsersGuide;
package ReleaseNotes "Release notes"
  extends TRANSFORM.Icons.ReleaseNotes;

  class Version_1_3_0 "Version 1.3.0 (2026-11-18)"
    extends TRANSFORM.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p><b>Conversion:</b> this release has a conversion script. It updates references in models written for 1.2.0, the 1.3.0-dev versions in between, and earlier to classes that moved to <code>TRANSFORM.Obsolete</code>: <code>Math.GNU_ScientificLibrary</code>, <code>Math.Interpolation</code> and the media built on it, <code>Media.LookupTableMedia</code> and <code>Media.LookupTableMedianew</code>. These classes are deprecated and will be removed in the next minor release. The functions of <code>GNU_ScientificLibrary</code> now call Modelica functions instead of the GNU Scientific Library, so models that use them keep working; use <code>Math.besselI</code>, <code>besselK</code>, <code>besselY</code> and <code>besselJ</code> instead. <code>Math.Interpolation</code> and the lookup-table media ran on Linux only; for para-hydrogen use <code>Media.ExternalMedia.CoolProp.ParaHydrogen</code>, and for 2-D table interpolation <code>Modelica.Blocks.Tables.CombiTable2Ds</code> or <code>Math.interpolate2D</code>. After their removal TRANSFORM ships no compiled libraries and no GPL code. Several changes can give different results in your own models; they are listed below, and those that say how to keep the old behaviour are marked <b>upgrade note</b> in <code>CHANGELOG.md</code>. OpenModelica does not run the conversion script by itself: it warns, and <code>convertPackageToLibrary</code> converts a model's package.</p>
<p><b>Results that change:</b></p>
<ul>
<li><code>Nuclear.ReactorKinetics.Functions.Initial_powerBased_powerHistory</code>: the start values from a power history are now exact. Before, history intervals shorter than 1 s were treated as 1 s long, the slowest decay-heat groups lost accuracy over short intervals, and with decay heat the iteration for the fission power often did not converge. Without a power history nothing changes. Upgrade note.</li>
<li><code>TRANSFORM.HeatExchangers.BaseClasses.Partial_LMTD_HX</code> (so <code>LMTD_HX_A</code>, <code>LMTD_HX_UA</code> and <code>LMTD_HX_Q</code>): the log mean temperature difference now uses the counterflow end differences, so areas, UA values and heat rates change. <code>counterCurrent=false</code> now gives parallel flow; before, it was ignored. The two internal volumes, which have zero size, now have steady-state balances by default (new parameter <code>energyDynamics</code>). Upgrade notes.</li>
<li><code>TRANSFORM.HeatExchangers.Simple_HX</code> and <code>Simple_HX_A</code>: the default correction factor <code>CF</code> on UA is now 1. Before, it was a temperature, which multiplied UA whenever both sides' outlet start temperatures differed from their inlet ones. Their <code>counterCurrent</code> option is now enabled in the parameter dialog. Upgrade note.</li>
<li><code>HeatAndMassTransfer.FinEfficiency</code>: the fin area of <code>StraightTriangular</code> and the <code>m</code> of <code>SpineRectangular</code> and <code>SpineTriangular</code> are corrected. <code>RectangleAnnular</code> now counts its tip through the corrected radius <code>r_outer + th/2</code>; with <code>use_NonDimensional = true</code>, its input <code>mr_outer</code> now means m*(r_outer + th/2). <code>SpineTriangular</code>, <code>StraightTriangular</code> and <code>RectangleAnnular</code> use <code>Math.besselI</code> and <code>Math.besselK</code> instead of the GNU Scientific Library, so they now run on Windows and in every tool; their efficiencies move only slightly.</li>
<li><code>Math.besselJ</code>: for a whole-number order it now uses the Abramowitz and Stegun approximations and recurrence instead of its power series, which lost all accuracy for large <code>x</code>. Values at small <code>x</code> move only slightly. Non-integer orders are unchanged.</li>
<li>Convection resistances <code>Heat.ConvectionMedia</code>, <code>ConvectionMedia_singleNode</code> and <code>Mass.ConvectionMedia</code>: the default surface area is now a round pipe's wetted area, and the default flow areas of <code>Mass.ConvectionMedia</code> now match <code>Heat.ConvectionMedia</code>. A model that relied on the default surface area gets a different one (larger in the heat classes); to keep the old area, set it to the old expression. <code>ConvectionMedia_singleNode</code> and <code>ConvectionMediaSimple</code> now work with media other than moist air.</li>
<li>Other resistances in <code>HeatAndMassTransfer.Resistances</code>: the reported <code>R</code> of the convection resistances was wrong; the heat and mass flows did not use it. <code>Heat.Sphere</code>, <code>Mass.Cylinder</code> and <code>Mass.Sphere</code> now accept <code>r_in = 0</code>, a solid body. Several resistances now guard against a zero area. <code>Resistances.Heat.SemiInfinitePlane</code> has a new parameter <code>t_0</code>, the elapsed time already at the start, so its first heat flow rate is finite; this lowers the heat flow rate slightly at every time, and <code>t_0 = 0</code> gives the old values.</li>
<li><code>Volumes.SimpleWall_Cylinder</code> and the <code>ClassicalMethod</code> cylinder (<code>Partial_FDCond_Cylinder</code>): a solid cylinder (<code>r_inner = 0</code>) now uses the centre-to-surface resistance. Before, the wall divided by zero.</li>
<li>Start values of <code>HeatAndMassTransfer.DiscritizedModels.Conduction_2D</code>, <code>HMTransfer_2D</code>, <code>Conduction_3D</code> and <code>HMTransfer_3D</code>, and of the walls of <code>Fluid.Pipes.GenericPipe_withWall</code>, <code>GenericPipe_withWallx2</code> and <code>GenericPipe_wWall_wTraceMass</code>: each edge or face start value now starts the volumes on its own edge or face. Only start values change, and only where the edge or face values differ.</li>
<li>Geometry: <code>Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe</code> gave every node the surface area of node 1 in <code>surfaceAreas_nVtotal</code> and <code>surfaceArea_total</code>. No physical result in the library changes, but a model built on the obsolete <code>Fluid.Pipes.GenericPipe</code> with unequal nodes now gets each node's own heat and mass transfer area. <code>Fluid.Volumes.ClosureModels.Geometry.Models.Flow.PartialGeometry</code> now also checks its last characteristic dimension, and <code>Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Generic</code> now stops with a message when its characteristic dimension is not positive.</li>
<li>Examples: <code>TRANSFORM.HeatExchangers.Examples.OilWater_Simple_HX</code> now takes its <code>UA</code> from Incropera and DeWitt, Example 11.1, and its outlet start temperatures from its outlet boundaries. <code>TRANSFORM.HeatExchangers.Examples.check_LMTD_HX</code> never started before; it now runs in Dymola and OpenModelica.</li>
</ul>
<p><b>Added:</b></p>
<ul>
<li><code>Math.besselI</code>, <code>Math.besselK</code> and <code>Math.besselY</code>: integer-order Bessel functions written in Modelica, beside <code>Math.besselJ</code>.</li>
<li><code>Math.linspace_3Dface</code> and <code>Math.linspaceRepeat_3Dface</code>: a 3-D array from six face values.</li>
<li><code>SItf</code>: a second alias for <code>TRANSFORM.Units</code>. New and edited classes write <code>SItf.NonDim</code>; <code>SIadd</code> stays.</li>
<li><code>TRANSFORM.HeatExchangers.Examples.IncroperaAndDeWitt.Example_11_1_Area</code>, <code>Example_11_1_UA</code> and <code>Example_11_1_Q</code>: Example 11.1 of Incropera and DeWitt, solved once with each LMTD heat exchanger. They carry the book's answers as reference values.</li>
</ul>
<p><b>Documentation:</b></p>
<ul>
<li><code>TRANSFORM.UsersGuide.Conventions</code>: a style guide for the library, in eleven short pages. It applies to new and edited classes.</li>
<li><code>TRANSFORM.UsersGuide.ModelingTips</code>: a page of habits that avoid failures which are hard to trace.</li>
<li><code>TRANSFORM.HeatAndMassTransfer</code>: new documentation pages and description strings for the resistances, the discretized models and the simple walls, and descriptions brought in line with the style guide. Every <code>showName</code>, <code>geometry</code> and <code>summary</code> in the library has one description.</li>
<li><code>TRANSFORM.UsersGuide.Overview</code>, <code>ParameterGUI</code> and <code>Connectors</code> are reworded: a filled port defines the flow, a white port the state. 16 documentation images that did not show now show. Links to the project's GitHub repositories use the organization's new name, WyrdLab.</li>
</ul>
<p><b>Compatibility, results unchanged:</b></p>
<ul>
<li>The library's own classes refer to TRANSFORM's unit types through the alias <code>SItf</code>. Every name refers to the same type as before, and <code>TRANSFORM.Units</code> and <code>SIadd</code> stay.</li>
<li><code>TRANSFORM.HeatExchangers.LMTD_HX_A</code> computes UA in a form linear in the area, the same value as before. The old form made Dymola's Newton solver diverge from the area's start value when the area sought was small.</li>
<li><code>SolubilityInterface.nb</code> now declares the maximum of 3 that its exponent function declares.</li>
<li>The icon picture of <code>HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.PartialInternalMassGeneration</code> now shows on Linux.</li>
</ul>
<p>The full list, with the examples that do not run in OpenModelica, is in <code>CHANGELOG.md</code> in the <a href=\"https://github.com/WyrdLab/TRANSFORM-Library\">TRANSFORM-Library repository</a>.</p>
</html>"));
  end Version_1_3_0;

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
<p>The full list is in <code>CHANGELOG.md</code> in the <a href=\"https://github.com/WyrdLab/TRANSFORM-Library\">TRANSFORM-Library repository</a>.</p>
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
<p>The full list is in <code>CHANGELOG.md</code> in the <a href=\"https://github.com/WyrdLab/TRANSFORM-Library\">TRANSFORM-Library repository</a>.</p>
</html>"));
  end Version_1_1_0;

  annotation (Documentation(info="<html>
<p>This package holds the release notes of TRANSFORM, one class per released version, newest first. Each class summarizes what changed in that version and whether user models need to be converted.</p>
<p>Changes made since the last release are listed in <code>CHANGELOG.md</code> at the root of the <a href=\"https://github.com/WyrdLab/TRANSFORM-Library\">TRANSFORM-Library repository</a>. They are summarized here when a version is released.</p>
<p>Release notes start with version 1.1.0. Earlier changes are recorded only in the repository's git history.</p>
</html>"));
end ReleaseNotes;
