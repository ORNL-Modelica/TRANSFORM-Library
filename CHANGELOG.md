# Changelog

All notable changes to TRANSFORM are recorded in this file.

The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). Each change adds a line under **Unreleased**. When a version is released, its section is also summarized in `TRANSFORM.UsersGuide.ReleaseNotes`, the release-notes package inside the library, as the Modelica Standard Library does.

## [Unreleased]

### Added

- `CHANGELOG.md` and the `TRANSFORM.UsersGuide.ReleaseNotes` package, so that every change is recorded and each release is summarized inside the library.
- Regression tests for `TRANSFORM.Examples.MoltenSaltReactor.MSDR_noBOP` (15 signals) and the new standalone `TRANSFORM.Examples.MoltenSaltReactor.Components.Examples.DRACS_Test` (5 signals). Their baselines were recorded before the fixes for issues #111–#116.

### Changed

- `.gitignore` now tracks `TRANSFORM/Resources/Scripts/Conversion/`, the conventional home of Modelica conversion scripts. The rest of `TRANSFORM/Resources/Scripts/` stays ignored.

## Earlier history

Changes before this file was created are recorded only in the git history. For reference:

- Git tags `v0.1-beta` (2018-06-14), `v0.2-beta` (2018-09-20), `v0.3-beta` (2018-11-13), `v0.4-beta` (2019-09-10) and `Before_MSL_4.0` (2020-12-07).
- `TRANSFORM/package.mo` has declared `version="1.0"` since commit `673d13d8` (2024-09-17). No git tag marks that version.
