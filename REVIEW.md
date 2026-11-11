# Reviewing a TRANSFORM change

For anyone reviewing a pull request here, person or agent. It says what a wrong
change looks like in this library, so a review looks there first.

## What failure looks like here

Most important first.

1. **A test passes but the result is wrong.** A test only checks the variables it
   tracks. One that tracks a single variable, or only values its boundary
   conditions fix, can pass while the model is wrong. Coarse output can hide a
   start-up spike. Check what each affected test tracks before trusting a pass.
2. **A physical value changes without saying so.** A guard, clamp, new fit or
   changed default must not move any value inside the real range. Results that
   move in models the pull request does not name are a finding.
3. **Checked in one tool only.** Dymola and OpenModelica can disagree. Dymola
   treats a variable's `min` and `max` as proven, so it can compile a guard away,
   and an `assert` can pass while the stored result disagrees. A fix is checked
   in both tools, including with fixed-value inputs, against a baseline or an
   independent number.
4. **Start values tuned to a simulation.** Start values are expressions of
   parameters or a tool option, not numbers copied from a run.
5. **A public surface changes without an upgrade path.** A class, parameter,
   default or behaviour that users rely on changes without a conversion rule,
   deprecation or upgrade note, or new behaviour is not opt-in.
6. **A fix reaches one model of a family.** When several models share the
   pattern being fixed, the fix covers all of them, or the pull request says why
   not.
7. **A problem hidden instead of fixed.** A tolerance loosened, a nominal value
   enlarged or a test removed to make a failure go away.

## How to report

- Start with the number of findings. If there is nothing to fix, say so plainly.
- Each finding names a file and line and gives a concrete case: which input or
  state gives which wrong result.
- Mark a problem that was already on `main` as **pre-existing**; it does not
  block this change.
- At most a few small style notes per review. Skip icon and diagram graphics and
  the data files under `TRANSFORM/Resources/` unless the change is about them.
