within TRANSFORM.Nuclear.ReactorKinetics.Functions;
function Initial_FissionProducts
  input Integer nC "# of fission products";
  input Integer nFS "# of fission product sources";
  input Integer nT
    "# of fission product types (e.g., fast/thermal)";

  input Real[nC,nC] parents
    "Matrix of parent-daughter sources";

  input Units.NonDim fissionSources_start[nFS]=fill(1/nFS, nFS)
    "Fission source material fractional composition (sum=1)"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  input Units.NonDim fissionTypes_start[nFS,nT]=fill(
      1/nT,
      nFS,
      nT)
    "Fraction of fission from each fission type per fission source, sum(row) = 1"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));

  input SI.Energy w_f_start=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));

  input SI.MacroscopicCrossSection SigmaF_start=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  input SI.Area sigmasA_start[nC]
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Initialization", group="Fission Products"));
  input Real fissionYields_start[nC,nFS,nT]
    "# fission product atoms yielded per fission per fissile source [#/fission]"
    annotation (Dialog(tab="Initialization", group="Fission Products"));
  input Units.InverseTime lambdas_start[nC]
    "Decay constants for each fission product"
    annotation (Dialog(tab="Initialization", group="Fission Products"));

  input SIadd.ExtraPropertyExtrinsic mCs_guess[nC] "Number of fission product atoms per group per volume" annotation (Dialog(tab="Initialization"));

  input SI.Power Qs_fission_start=1e6
    "Power determined from kinetics. Does not include fission product decay heat"
    annotation (Dialog(tab="Initialization"));
  input SI.Volume Vs_start=0.1
    "Volume for fisson product concentration basis"
    annotation (Dialog(tab="Initialization"));

    output SIadd.ExtraPropertyExtrinsic mCs[nC];

protected
  SIadd.ExtraPropertyExtrinsic mCs_start[nC] = mCs_guess;

  Real it = 0;
  Real itmax = 10;
  Real error = 100;
  Real error_min = 0.001;
algorithm

  while it<itmax and error > error_min loop
 for j in 1:nC loop
 mCs[j] :=(Qs_fission_start/w_f_start*sum({fissionSources_start[k]*sum({
      fissionTypes_start[k, m]*fissionYields_start[j, k, m] for m in 1:nT})
      for k in 1:nFS}) + sum({if i == j then 0 else lambdas_start[i]*mCs_start[
      i]*parents[j, i] for i in 1:nC}))/(lambdas_start[j] + sigmasA_start[j]*
      Qs_fission_start/(w_f_start*SigmaF_start)/Vs_start);

      end for;
 error :=sum(abs(mCs_start - mCs)./mCs);
 mCs_start := mCs;
      it :=it + 1;
 end while;

end Initial_FissionProducts;
