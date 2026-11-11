# Contributing to TRANSFORM

TRANSFORM is released and used by people we do not know by name. A change must not break their models without warning. This file says how to make changes so that it does not, and how a release is made.

## Every change

- Base pull requests on `main`.
- Add or update a test. Unit tests and their reference results live in [TRANSFORM-UnitTests](https://github.com/ORNL-Modelica/TRANSFORM-UnitTests). If results change, update the reference results there in a pull request of its own.
- Add a line to [CHANGELOG.md](CHANGELOG.md) under **Unreleased**, saying what changed and whether results change.
- Reviewers, people or agents, start from [REVIEW.md](REVIEW.md): what a wrong change looks like in this library.

## Versions

Versions have three parts, for example `1.1.0`. The version is written in `TRANSFORM/package.mo`:

```modelica
version="1.1.0-dev",
conversion(noneFromVersion="0.5", noneFromVersion="1.0"),
```

- Between releases, `main` carries the next version with `-dev` added. It tells people that their copy is not a release. Modelica tools read only this annotation, never git tags.
- The `conversion` annotation tells Dymola and OpenModelica how to upgrade a model written for an older version. `noneFromVersion="1.0"` promises that models written for 1.0 run unchanged. `from(version="1.0", script="…")` instead names a conversion script that rewrites them.
- A **minor** release (1.1.0, 1.2.0, …) may add classes, fix bugs, change results, and rename or deprecate classes as long as the old name keeps working. A model written for an earlier 1.x version must still run without conversion.
- A **major** release (2.0.0) removes what earlier releases deprecated, or makes any other change that stops an old model running unless it is converted. Major releases are planned, so that removals are grouped together.
- A major release must replace **every** `noneFromVersion` entry (0.5, 1.0, the `-dev` strings, 1.1.0, …) with a `from(version={…}, script="…")` entry. Otherwise tools would load those old models without converting them. The guard checks only the newest release, so it does not catch this.
- When there are several conversion scripts, give each `from` entry a `to=` version, for example `from(version="1.0", to="1.1.0", script="…_from_1.0_to_1.1.0.mos")`, so that a model is converted step by step through every script. Without `to=`, a script converts straight to the current version and later scripts are skipped.

## Renaming or moving a class

1. Move the code to the new name.
2. Keep the old name as a thin class that extends the new one and says when it goes and what to use instead:

   ```modelica
   model OldName "Deprecated; use TRANSFORM.Some.NewName"
     extends TRANSFORM.Some.NewName;
     annotation (obsolete="Deprecated in 1.1.0, removed in 2.0.0; use TRANSFORM.Some.NewName");
   end OldName;
   ```

   Use the same kind of class as the new one (`block`, `function`, `connector`, …), and keep `partial` if the new class is partial.

3. Add a rule to the conversion script for this release, `TRANSFORM/Resources/Scripts/Conversion/ConvertTRANSFORM_from_1.0_to_1.1.0.mos`:

   ```
   convertClass("TRANSFORM.Some.OldName", "TRANSFORM.Some.NewName");
   ```

   If this is the first rule of the release, create the script. Then, in `TRANSFORM/package.mo`, replace `noneFromVersion="1.0"` with
   `from(version="1.0", script="modelica://TRANSFORM/Resources/Scripts/Conversion/ConvertTRANSFORM_from_1.0_to_1.1.0.mos")`.
4. Add a line to CHANGELOG.md under **Deprecated**: the old name, the new name and the version that removes the old one.
5. Run the conversion guard (below).

## Renaming a parameter or connector

Modelica has no way to mark a single parameter as deprecated. So a parameter or connector rename waits for a major release, unless the old name can be kept working simply and a test shows it does. For example, keep the old parameter with the old default and give the new one `newName = oldName`, so a user who still sets the old name changes the model; the other direction (`oldName = newName`) would silently ignore their value. The conversion rule is `convertElement({"TRANSFORM.Cls", <every class that extends it>}, "oldName", "newName");`. List the subclasses, because rules do not follow inheritance.

## Removing a class

Only in a major release, and only after it has been deprecated in an earlier release. Move it into `TRANSFORM.Obsolete` and add `convertClass("TRANSFORM.Old", "TRANSFORM.Obsolete.Old")`, so models that still use it keep running with a warning. Add a line under **Removed** in CHANGELOG.md.

## Conversion guard

The guard runs Dymola's `checkConversion`. It compares the library with its newest release tag and fails if a model written for that release would have no upgrade path. For example, it fails when a class is gone without a conversion rule, or when the version was not bumped after a release. Run it before merging any pull request that changes `TRANSFORM/`, since an accidental removal is exactly what it catches, and say in the pull request that it passed:

```
python3 <TRANSFORM-UnitTests>/scripts/check_conversion.py --library <TRANSFORM-Library>
```

It needs Dymola, git and tar. See the TRANSFORM-UnitTests README for the options.

## Making a release

1. In `TRANSFORM/package.mo`, set `version="1.1.0"` and `versionDate="YYYY-MM-DD"`. Add the development version to the conversion annotation: `noneFromVersion="1.1.0-dev"`, or add `"1.1.0-dev"` to the `from(version=…)` list if the release has a conversion script.
2. Run the conversion guard on this edited annotation.
3. In CHANGELOG.md, rename **Unreleased** to `[1.1.0] - YYYY-MM-DD` and start a new empty **Unreleased** section.
4. Add a class for the version to `TRANSFORM.UsersGuide.ReleaseNotes`, summarizing the changelog section and saying whether models need conversion.
5. Commit, tag the commit `v1.1.0`, and make a GitHub release from the tag.
6. On `main`, set the next development version, for example `version="1.2.0-dev"`, with `noneFromVersion="1.1.0"` added. Use `"2.0.0-dev"` instead once the first change that waits for 2.0 is merged; when main moves from `"1.2.0-dev"` to `"2.0.0-dev"`, add `"1.2.0-dev"` to the conversion annotation as in step 1, because Dymola matches version strings exactly.
