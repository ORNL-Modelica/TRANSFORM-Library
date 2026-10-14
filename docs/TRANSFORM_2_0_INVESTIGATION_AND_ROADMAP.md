# TRANSFORM 2.0 Investigation and Roadmap

**Working plan — 14 October 2026**

TRANSFORM 2.0 should make the library easier to understand, more reliable to simulate, and more portable across Modelica tools while preserving the capabilities that make TRANSFORM useful today. The first visible work should be a disciplined documentation and presentation campaign. In parallel, the existing test infrastructure should establish what currently works in Dymola and OpenModelica. Larger changes to media, package structure, and other compiler targets should follow measured results.

This plan covers the TRANSFORM library and relevant work in [TRANSFORM-UnitTests](https://github.com/ORNL-Modelica/TRANSFORM-UnitTests), [DynamicSystemsTestingFramework (DSTF)](https://github.com/ORNL-Modelica/DynamicSystemsTestingFramework), [TRANSFORM-Training](https://github.com/ORNL-Modelica/TRANSFORM-Training), and other [ORNL-Modelica repositories](https://github.com/orgs/ORNL-Modelica/repositories?type=all). It is a proposal for review and refinement, not a claim that the proposed simulation targets have already been met.

## Current position

The local TRANSFORM checkout contains 3,270 Modelica source files. About 945 files occur under an `Examples` directory, including package and support files; 320 of those files contain an `experiment(...)` annotation. About 331 Modelica files contain the existing `ErrorAnalysis.UnitTests` test marker. These counts show the scale of the work, but neither the number of runnable examples nor a simulation pass rate.

The separate TRANSFORM-UnitTests repository already uses DSTF. Its stored references contain 331 active Dymola/Linux baselines, 331 active Dymola/Windows baselines, and 235 active OpenModelica/Linux baselines. One additional Windows file is inactive. All partitions together cover 331 unique model IDs. The 96-model difference between Dymola/Linux and OpenModelica/Linux is a **baseline coverage gap**; it must be classified before calling it a compiler failure. The local DSTF documentation records historical full-library runs, but their verdicts do not substitute for a current run at a pinned TRANSFORM revision.

The library's [README](../README.md) still names Dymola as the requirement and refers to `runAll_*.mos` scripts absent from this checkout. The [unit-testing guide](../TRANSFORM/UsersGuide/UnitTesting.mo) is image-only, while the [overview](../TRANSFORM/UsersGuide/Overview.mo) provides little help in choosing among the library's models. TRANSFORM-Training already contains a twelve-step flow-loop progression that can support a better learning path and selected validation scenarios. Its package currently declares `TRANSFORM(version="0.5")`, whereas [TRANSFORM's package](../TRANSFORM/package.mo) declares version `1.0`; that relationship needs explicit verification and documentation.

Media portability has several distinct parts. TRANSFORM's CoolProp wrappers extend the separate ExternalMedia library, which is absent from the top-level `uses(...)` declaration; [issue #106](https://github.com/ORNL-Modelica/TRANSFORM-Library/issues/106) reports this. The table media call custom interpolation functions linked to `noname` and GSL, with supplied archives in this checkout under `linux64`. Some heat-transfer models call SDF; [issue #98](https://github.com/ORNL-Modelica/TRANSFORM-Library/issues/98) identifies its unavailable-library problem. [MediaLookupTables](https://github.com/ORNL-Modelica/MediaLookupTables) contains the earlier interpolation proof of concept and source, and the separate [Groeneveld CHF table project](https://github.com/greenwoodms06/2006_Groeneveld_CriticalHeatFlux_LUT) provides source data and a regression case. These should be studied before replacing an interpolation backend.

OpenModelica is already a credible target, with specific evidence rather than a blank slate: [issue #109](https://github.com/ORNL-Modelica/TRANSFORM-Library/issues/109) reports a compiler code-generation failure affecting common components and a tested source workaround. Each subsequent failure needs its own classification. A package loading under MSL 4.0.0 does not establish that every contained model translates or simulates.

## Ranked workstreams

| Rank | Workstream | Outcome and decision gate |
| --- | --- | --- |
| **1** | Documentation, presentation, and style | Publish an extracted and improved style guide; make the README, user guide, model descriptions, and cross-repository learning path accurate and consistent. Start with text-only changes and verify that model behavior is unchanged. |
| **2** | Current test and example inventory | Reconcile test markers, explicit DSTF tests, baselines, runnable examples, optional dependencies, and obsolete or partial models. Record current results with exact source and tool versions. This defines the denominator for future coverage claims. |
| **3** | OpenModelica compatibility | Explain the 96-model baseline gap and classify each attempted model by load, check, translation, simulation, and comparison outcome. Fix common blockers first; report compiler defects upstream with small reproductions. |
| **4** | Numerical and physical validation | Add conservation, initialization, event, discretization, and performance criteria to representative scenarios. Distinguish a completed simulation from a physically credible one. |
| **5** | Media and native-dependency strategy | Compare upstream ExternalMedia/CoolProp, TRANSFORM's two table-medium variants, MediaLookupTables, and the SDF/CHF case. Prove one portable vertical slice before designing a general table-to-Modelica bridge. |
| **6** | Richer examples and validation suites | Use existing component examples and TRANSFORM-Training to define interesting, documented scenarios. Decide whether a separate library such as `TRANSFORM-Validation` improves dependencies and release management. |
| **7** | Package boundaries and future platforms | Move public models or split libraries only where evidence shows a dependency, release-cadence, platform, or audience boundary. Use the validated subset to probe Rumoca, ModelScript, Modelon Impact, and Dyad; build on [TRANSFORM-Julia](https://github.com/ORNL-Modelica/TRANSFORM-Julia). |

Workstreams 1 and 2 can begin together. The first visible deliverables should come from workstream 1. The inventory in workstream 2 supplies the check that later compatibility and coverage statements need.

## Documentation and style campaign

### Establish the standard before a broad sweep

Extract a draft style guide from a deliberately chosen sample of high-quality models across Fluid, HeatAndMassTransfer, Media, Nuclear, Utilities, and system examples. Compare those conventions with the Modelica Standard Library and language rules. Record which practices are existing TRANSFORM conventions and which are proposed improvements; frequency alone does not make a convention good.

The guide should specify how to write a class summary, explain assumptions and validity limits, document replaceable media and closure relations, distinguish parameters from time-varying inputs, state units and sign conventions, cite correlations, describe initialization, and tell users what an example demonstrates. It should also set standards for links, image alternatives, terminology, spelling, and `Documentation(info=...)` structure. Separate editorial conventions from future API or source-code conventions: a text-only campaign should not rename public classes, variables, or parameters.

### Work in two levels of review

AI can autonomously inventory documentation, propose a style guide, repair links, rewrite navigation pages, correct descriptions, and apply agreed prose patterns in small batches. The initial boundary is README and guide prose, Modelica class description strings, ordinary comments, and `Documentation(...)` text. Each batch should be reviewed as a text change and parsed by a Modelica tool when one is available. It should not alter declarations, equations, algorithms, modifiers, public names, experiment settings, dependency annotations, derivative annotations, or diagram and icon geometry as part of a prose cleanup.

Explanations of physics require stronger review than spelling or formatting. A description of a correlation, valid operating range, two-phase behavior, or numerical assumption should be checked against the implementation and cited source. If that evidence is missing, document the limitation or leave the claim for a domain review. A polished unsupported claim would make the library harder to trust.

### First documentation deliverables

1. A source-based editorial and documentation style guide with a short checklist and representative before/after examples.
2. An accurate root README that explains installation, MSL and optional dependencies, Dymola and OpenModelica status, the Training path, and the current DSTF test workflow.
3. A searchable user guide covering package selection, connector and parameter conventions, common model composition, media choice, troubleshooting, and testing.
4. One reviewed pilot batch of public components and examples from several domains. Use it to refine the guide before wider application.
5. A documentation coverage inventory that distinguishes missing text, weak text, inherited documentation, broken links, and content requiring technical verification.

## Testing and compatibility program

Use the existing DSTF configuration and reference store as the starting point. First, map every test marker and explicit specification to its model and baseline partition. Record whether each baseline is current for the chosen TRANSFORM revision. Then run a representative cross-tool set before expanding to all eligible examples.

The compatibility ledger should distinguish: not attempted, intentionally non-runnable, missing optional dependency, load or parse failure, model-check failure, translation failure, external-library/link failure, simulation failure, completed with failed acceptance criteria, and passed. Record tool version, MSL version, OS, medium, solver settings, runtime, and diagnostic links. The target of “all examples simulate” should eventually mean **all classified, eligible runnable examples in a defined environment**, with explicit reasons for exclusions and optional dependency tiers.

Existing baselines primarily support signal regression. Add checks that answer different questions: conservation of mass, energy, and species; flow reversal and near-zero flow; initialization robustness; event count and chattering; mesh and tolerance sensitivity; phase-boundary behavior; state count and translation changes; and runtime. Compare physical quantities with domain-appropriate tolerances when different solvers place events at different times. Use DSTF's existing comparison modes before adding new framework features.

## Media and architecture decision rules

Treat the proposed CoolProp-to-table workflow as a medium design project, not a CSV conversion project. A Modelica.Media-compatible implementation needs consistent thermodynamic states, property derivatives, inverse state operations, validity handling, and predictable behavior near phase boundaries. Benchmark a single-phase fluid first against direct CoolProp and a representative TRANSFORM component; include accuracy, derivatives, extrapolation, simulation robustness, runtime, and Windows/Linux packaging. Evaluate a two-phase case only after that slice meets explicit criteria. CoolProp notes that tabular resolution can limit accuracy near a critical point ([tabular documentation](https://coolprop.org/coolprop/Tabular.html)).

Keep package moves conditional. Candidates for separation include optional native-media dependencies, large validation suites, or application examples with a different release cadence. Before moving a public path, measure its users, document compatibility costs, and test aliases or conversion annotations. The [Modelica language specification](https://specification.modelica.org/maint/3.6/annotations.html) provides library `uses` and conversion mechanisms. Splitting the library simply to make its tree look tidier would impose migration work without demonstrating user benefit.

## How to manage the work

### Use `main` for TRANSFORM 2.0

The local repository's checked-out branch is `main`, and `origin/HEAD` points to `origin/main`. No `master` rename is needed. Keep `main` as the integration line for TRANSFORM 2.0, with focused topic branches and pull requests. Do not create a long-lived `2.0` branch by default; it would require continuous merging and delay feedback from users of the default branch. If maintenance of the current version becomes necessary, create a separate maintenance branch from a recorded pre-2.0 commit. Record that commit or a descriptive baseline tag before behavior-changing work; the package's `version="1.0"` alone does not identify a released Git tag. Update the package version and conversion plan deliberately as release decisions, not as the first documentation edit.

### Use issues for work, branches for changes

Use GitHub Issues as the lightweight ticket system. Each issue should identify the problem, evidence, intended result, files or packages in scope, acceptance criteria, and dependencies. Keep an umbrella issue for each workstream and split only the next actionable batches into smaller issues. Use consistent labels for documentation, compatibility, testing, numerics, media, and architecture; use milestones for reviewable release phases. A GitHub Project board is useful when cross-repository coordination becomes hard to follow in Issues, but is not a prerequisite. GitHub supports this issues/labels/milestones model ([documentation](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work)).

Make each implementation branch address one reviewable issue or closely related batch. Use pull requests into `main` to show the exact diff, evidence, and remaining uncertainty. Protect `main` against accidental deletion or force pushes, and introduce required checks as the checks become reliable. If a sole maintainer is the only reviewer, avoid a mandatory approval setting that makes ordinary merges impossible. GitHub's [branch protection guidance](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches) supports these controls.

### Let AI work methodically in bounded batches

AI should do the time-consuming inventory, source comparison, drafting, and repetitive edits. Each batch needs a defined scope and an observable result. Documentation batches need a diff restricted to permitted text surfaces, link/resource checks, a Modelica parse or load check when available, and a small human review sample. Behavior-changing batches need relevant DSTF regressions, compiler logs, and a statement of numerical impact. Keep failed attempts and tool-specific limitations in the issue record so the next agent does not repeat them.

The human decisions worth reserving are the style guide's technical conventions, claims about physics without clear source support, whether a public API move is worth its migration cost, which tool/platform tiers the release promises, and acceptance of a 2.0 release candidate. These are specific decision gates, not a reason to stop autonomous analysis or drafting.

## Initial issue set

The first issue set should be small enough to review and broad enough to expose dependencies:

| Issue | Acceptance evidence |
| --- | --- |
| Audit current documentation and select canonical examples | Inventory by package, broken-link list, and a cited sample of strong and weak documentation. |
| Draft the TRANSFORM documentation and editorial style guide | Examples from multiple domains; explicit separation of prose rules and API changes; reviewed technical conventions. |
| Rewrite the README and user-guide entry path | One accurate route through Library, Training, UnitTests, and DSTF; working dependency and test instructions. |
| Pilot a text-only documentation batch | Representative components and examples, restricted diff, source-backed technical claims, successful load/parse check. |
| Reconcile DSTF discovery and baseline partitions | Model-by-model ledger for the 331 baseline universe and the 96-model OpenModelica coverage difference. |
| Reproduce and classify known OpenModelica blockers | Small reproductions and results for issue #109 and representative failures from the gap. |
| Inventory optional and native dependencies | ExternalMedia, GSL/`noname`, SDF, platform binaries, and affected public examples. |
| Design one media vertical-slice evaluation | Candidate architectures, reference states, derivative tests, portability tests, and a decision criterion. |
| Define richer scenario families | Map current examples and Training's flow-loop steps to learning, component regression, physical validation, and system demonstrations. |

Place an issue in the repository that owns its implementation. The TRANSFORM-Library umbrella issues should link to DSTF, UnitTests, or Training issues when work belongs there.

## Immediate sequence

1. Review this plan with emphasis on the 2.0 promise, target users, supported tools, and appetite for public path changes.
2. Record a pre-change source and testing baseline. Use the existing baselines and historical runs as inputs, then produce current results at a pinned revision.
3. Open the documentation/style umbrella and its first few actionable issues. Draft the style guide and pilot before a library-wide prose sweep.
4. Update the README and user guide, then expand documentation in reviewable package batches.
5. Run the OpenModelica gap analysis and media dependency investigation in parallel. Promote larger architectural proposals only when their measured benefit and migration cost are clear.

The first review should ask whether a reader can install TRANSFORM, choose a model, understand its assumptions, and reproduce an example from the published instructions. The release review should additionally ask which eligible examples pass in each promised environment and whether their physical and numerical acceptance criteria hold.
