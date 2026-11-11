### Description
Fixes #

### Type
- [ ] Bug fix
- [ ] New feature
- [ ] Rename or deprecation, with the old name kept working (see [CONTRIBUTING.md](https://github.com/ORNL-Modelica/TRANSFORM-Library/blob/main/CONTRIBUTING.md))
- [ ] Removal or other breaking change; waits for a major release

### How it was tested
<!-- Which tools and operating systems, which tests, and how results compare with main. -->

### What these checks would not catch
<!-- Where the evidence stops: for example, variables no test tracks, or behaviour between stored samples. -->

### How to undo
<!-- Usually: revert this pull request and its TRANSFORM-UnitTests pull request together. -->

### Checks
- [ ] Tests added or updated (TRANSFORM-UnitTests); reference results updated there if results change
- [ ] A line in CHANGELOG.md under Unreleased
- [ ] The conversion guard was run and passed (`TRANSFORM-UnitTests/scripts/check_conversion.py`; needed for any change under `TRANSFORM/`)
