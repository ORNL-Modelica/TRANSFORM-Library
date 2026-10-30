# Changelog

All notable changes to TRANSFORM are recorded in this file.

The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). Each change adds a line under **Unreleased**. When a version is released, its section is also summarized in `TRANSFORM.UsersGuide.ReleaseNotes`, the release-notes package inside the library, as the Modelica Standard Library does.

## [Unreleased]

### Added

- `CHANGELOG.md` and the `TRANSFORM.UsersGuide.ReleaseNotes` package, so that every change is recorded and each release is summarized inside the library.
- Regression tests for `TRANSFORM.Examples.MoltenSaltReactor.MSDR_noBOP` (15 signals) and the new standalone `TRANSFORM.Examples.MoltenSaltReactor.Components.Examples.DRACS_Test` (5 signals). Their baselines were recorded before the fixes for issues #111–#116.

### Changed

- `.gitignore` now tracks `TRANSFORM/Resources/Scripts/Conversion/`, the conventional home of Modelica conversion scripts. The rest of `TRANSFORM/Resources/Scripts/` stays ignored.

### Fixed

- `TRANSFORM.Examples.MoltenSaltReactor.MSDR_noBOP`: the drain-tank thimble convection area `surfaceAreas_thimble` passed to `DRACS` no longer multiplies by `DRACS.nP_outer_drainTank[1].nParallel`, which counted the 360 thimbles twice and made the heel-to-thimble conductance 360 times too large, on both the salt and gas sides (#112). `MSDR_noBOP` results change.
- `TRANSFORM.Examples.MoltenSaltReactor.Components.DRACS`: the water-tank make-up controller `PID_waterTank` is tuned to `k=200`, `Ti=300` instead of the `LimPID` defaults (`k=1`, `Ti=0.5`), which left the make-up flow in a barely damped oscillation of about 1 to 99 kg/s with a period of about 760 s (#113). `MSDR_noBOP` results change.
- `TRANSFORM.Examples.MoltenSaltReactor.Components.DRACS`: the NaK loop now circulates by natural convection. The downcomer `downcomer_DRACS` runs downward (`angle=-pi/2` instead of `+pi/2`, so the loop no longer climbs 36.6 m), and `resistance` has `R=1` instead of `R=-2000`, which acted as a pump (#111). The riser and downcomer each use `nV=10` volumes instead of 1, so the static-head regularization at the end of each leg no longer averages away the buoyancy head and reverses the loop (#116). `MSDR_noBOP` results change.
- `TRANSFORM.Examples.MoltenSaltReactor.Components.DRACS` and `MSDR_noBOP`: the four thimble walls start at the temperature of the fluid beside them instead of unrelated data temperatures, so there are no large heat-flow pulses at t=0 (up to 4.9 GW before) (#114). The inner walls start at the NaK start `0.5*(T_hot_dracs + T_cold_dracs)`, the outer water-tank wall at the tank start `0.5*(T_inlet_waterTank + T_outlet_waterTank)`, and in `MSDR_noBOP` the outer drain-tank wall at the heel start `data_PHX.T_inlet_tube`. All are expressions of existing parameters. Results change mainly during start-up; end values change by less than 2 %.

## Earlier history

Changes before this file was created are recorded only in the git history. For reference:

- Git tags `v0.1-beta` (2018-06-14), `v0.2-beta` (2018-09-20), `v0.3-beta` (2018-11-13), `v0.4-beta` (2019-09-10) and `Before_MSL_4.0` (2020-12-07).
- `TRANSFORM/package.mo` has declared `version="1.0"` since commit `673d13d8` (2024-09-17). No git tag marks that version.
