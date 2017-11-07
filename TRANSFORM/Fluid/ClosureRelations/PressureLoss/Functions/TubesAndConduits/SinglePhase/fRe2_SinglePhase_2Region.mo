within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase;
function fRe2_SinglePhase_2Region

  input SI.ReynoldsNumber Re "Reynolds Number";
  input SI.Length dimension "Hydraulic diameter";
  input SI.Length roughness "Average height of surface asperities";
  input SI.ReynoldsNumber Re_center "Re smoothing transition center";
  input SI.ReynoldsNumber Re_width "Re smoothing transition width";

  output SIadd.nonDim fRe2 "Friction factor*Re^2";

protected
  SIadd.nonDim fRe2_lam=
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Laminar_Local_Developed_Circular(
       Re) "Laminar Friction factor";
  SIadd.nonDim fRe2_turb=
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.fRe2_Turbulent_Local_Developed_SwameeJain(
      Re,
      dimension,
      roughness) "Turbulent Friction factor";

algorithm

   fRe2 := TRANSFORM.Math.spliceTanh(
     fRe2_turb,
     fRe2_lam,
     Re - Re_center,
     Re_width);

  annotation (smoothOrder=1);
end fRe2_SinglePhase_2Region;
