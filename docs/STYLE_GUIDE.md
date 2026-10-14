# TRANSFORM documentation and editorial style guide

**Draft for the first TRANSFORM 2.0 documentation pass — 14 October 2026**

This guide sets a reviewable standard for user-facing text. It draws on existing documentation in `UsersGuide.Connectors`, `HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Nus_SinglePhase_2Region`, and `HeatAndMassTransfer.Volumes.UnitVolume`, plus gaps in the README and component pages. Those files are evidence of current practice, not automatic templates: for example, the old `UnitVolume` page describes an extending class although `UnitVolume` is concrete.

## Scope of a text-only pass

Allowed changes are Markdown and the human-readable parts of Modelica classes: class descriptions and `Documentation(info=...)` text. Correct spelling, grammar, links, terminology, and explanations. Do not change names, parameter or variable declarations, defaults, equations, algorithms, inheritance, connectors, experiment settings, graphical annotations, or `package.order` as part of this pass. A proposed correction to a declaration's short description should be reviewed separately because it sits in the declaration. Preserve public paths.

Even documentation can affect tooling. Keep Modelica string escaping valid, use `modelica://TRANSFORM/...` for packaged resources, and check a Modelica load or parse when a compiler is available. Review the diff to confirm that only intended text changed. Do not claim a simulation result from a documentation review.

## Class documentation

Begin with one sentence saying what the class does and where it fits. For a component, add the most important configuration choices and the meaning of ports or inputs. Describe assumptions, validity limits, sign conventions, and initialization behavior when they matter to using the model. Name replaceable media, geometry, or closure models when they materially change results. For a correlation, give the regime and source rather than implying universal validity. For an example, state the setup, the question it demonstrates, how to run it, and what output to inspect. Say when an optional library, native binary, or data file is needed.

Write from the actual equations and declarations. For example, `Fluid.Volumes.SimpleVolume` has two fluid ports and an optional heat port; its `port_a` and `port_b` pressure equations include half of `geometry.dheight` with opposite signs. Do not call the pressure drop “frictional” or assert a fixed flow direction: neither is established by this model. `HeatAndMassTransfer.Volumes.SimpleWall` computes thermal resistance from thickness, conductivity, and area by default; its `exposeState_*` settings select how port temperatures and heat flows are constrained. State such relationships directly and avoid promises about all media or solvers.

Use sections only where they help. A typical substantial page may use **Description**, **Configuration**, **Assumptions and limits**, **Example**, and **References**. A small component can use two concise paragraphs and a list. Avoid empty boilerplate headings.

## Modelica HTML and links

Use `Documentation(info="<html>... </html>")` for in-tool documentation. Prefer simple `<p>`, `<ul>`, `<ol>`, `<code>`, and heading tags supported by Modelica tools. Escape `"` inside the Modelica string; use HTML entities where needed. Close elements and check that image URLs resolve. Use `modelica://TRANSFORM/Resources/...` for library assets. Link to another Modelica class with a `modelica://` URL where supported, and include the readable class path in the text. Use stable HTTPS URLs for external material and include enough source detail that a reader can identify a reference if a link changes.

Keep equations in prose readable, with symbols matching the implementation. Use SI unit names and dimensions consistently, but do not silently change Modelica types or display units. Define any package-specific unit or non-obvious sign convention locally. State whether an input can vary with time; do not imply that a value in a GUI group named “Inputs” is necessarily connected to a signal source.

## Terminology and tone

Use “Modelica Standard Library (MSL)” on first mention, “OpenModelica” and “Dymola” with their official capitalization, and package names exactly as written. Use “test” for a defined check, “example” for a demonstration, “reference result” for a stored baseline, and “validated” only when an acceptance criterion and result are identified. Distinguish a model that loads, checks, translates, simulates, and passes numerical comparison. Avoid tool-wide compatibility claims inferred from one example.

Prefer direct, factual prose. Make physical claims traceable to equations, tests, or cited sources. Fix apparent mistakes in existing documentation, but flag uncertain physics or validity ranges for domain review rather than guessing. Preserve historical naming in identifiers even when prose uses current terminology.

## Review checklist for a batch

1. Identify the exact classes and audience. Compare the new wording with their declarations, equations, and nearby examples.
2. Check links, image paths, dependency claims, and references. Separate verified facts from plans or untested compatibility claims.
3. Review `git diff` for text-only scope and accidental whitespace or line-ending churn. Check Markdown links and Modelica string delimiters.
4. Load or parse touched Modelica classes when a compiler is available. Record tool and version, or state plainly that this check was unavailable.
5. Have a domain reviewer inspect a sample that includes technical claims. Apply the agreed convention to the next batch only after this pilot is accepted.
