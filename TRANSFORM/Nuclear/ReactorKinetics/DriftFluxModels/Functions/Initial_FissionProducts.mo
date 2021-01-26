within TRANSFORM.Nuclear.ReactorKinetics.DriftFluxModels.Functions;
function Initial_FissionProducts
  extends TRANSFORM.Icons.Function;

  input Integer nC "# of fission products";
  input SIadd.NeutronFlux phi "Neutron flux";
  input SIadd.InverseTime[nC] lambdas "Half-life of fission product";
  input Integer l_lambdas_col[:];
  input Integer l_lambdas_count[nC];
  input Real l_lambdas[size(l_lambdas_col, 1)]=fill(0, size(l_lambdas_col, 1))
    "need to correct uni - Matrix of parent sources (e.g., sum(column) = 0, 1, or 2)*lambdas for each fission product 'daughter'. Row is daughter, Column is parent.";

  input SI.Area sigmasA[nC]=fill(0, nC)
    "Microscopic absorption cross-section for reactivity feedback";
  input Integer f_sigmasA_col[:];
  input Integer f_sigmasA_count[nC];
  input Real f_sigmasA[size(f_sigmasA_col, 1)]=fill(0, size(f_sigmasA_col, 1))
    "need to correct units";

  input SIadd.ExtraPropertyExtrinsic mCs_guess[nC]
    "Number of fission product atoms per group per volume";

  input Integer i_noGen[:]={0};

  output SIadd.ExtraPropertyExtrinsic mCs[nC];

protected
  SIadd.ExtraPropertyExtrinsic mCs_start[nC]=mCs_guess;
  Real it=0;
  Real itmax=10;
  Real error=100;
  Real error_min=0.001;

algorithm
  while it < itmax and error > error_min loop
    for j in 1:nC loop
      if TRANSFORM.Math.exists(j, i_noGen) then
        mCs[j] := mCs_start[j];
      else
        mCs[j] := (sum({l_lambdas[sum(l_lambdas_count[1:j - 1]) + k]*mCs[
          l_lambdas_col[sum(l_lambdas_count[1:j - 1]) + k]] for k in 1:
          l_lambdas_count[j]}) + sum({f_sigmasA[sum(f_sigmasA_count[1:j - 1]) +
          k]*mCs[f_sigmasA_col[sum(f_sigmasA_count[1:j - 1]) + k]] for k in 1:
          f_sigmasA_count[j]})*phi)/(lambdas[j] + sigmasA[j]*phi);
      end if;
    end for;
    error := sum(abs(mCs_start - mCs) ./ mCs);
    mCs_start := mCs;
    it := it + 1;
  end while;
end Initial_FissionProducts;
