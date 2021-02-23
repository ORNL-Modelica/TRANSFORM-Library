within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Lumped;
model Isotopes_sparseMatrix
import Modelica.Fluid.Types.Dynamics;

extends PartialIsotopes(rhos_start = {-data.sigmasA[j]*mCs_start[j]/sum(data.nus[1]*data.sigmasF[k]*mCs_start[data.actinideIndex[k]] for k in 1:data.nA) for j in 1:nC});

    //todo: steady-state calculation for start?
  //    parameter SIadd.ExtraPropertyExtrinsic mCs_start2[nC]=
  //        Functions.Initial_FissionProducts(
  //        nC=nC,
  //        phi=Q_fission_start/(w_f_start*SigmaF_start)/V_start,
  //        lambdas=data.lambdas,
  //        l_lambdas_col=data.l_lambdas_col,
  //        l_lambdas_count=data.l_lambdas_count,
  //        l_lambdas=data.l_lambdas,
  //        sigmasA=data.sigmasA,
  //        f_sigmasA_col=data.f_sigmasA_col,
  //        f_sigmasA_count=data.f_sigmasA_count,
  //        f_sigmasA=data.f_sigmasA,
  //        mCs_guess=mCs_start) "Number of isotope atoms per group"
  //      annotation (Dialog(tab="Initialization"));

  parameter Boolean use_noGen=false
    "=true to set mC_gen = 0 for indices in i_noGen" annotation (Evaluate=true);
  parameter Integer i_noGen[:]=data.actinideIndex "Index of isotopes to be held constant if use_noGen";

protected
  final parameter Integer l_lambdas_count_sum[nC]={sum(data.l_lambdas_count[1:j - 1])
      for j in 1:nC} annotation (Evaluate=true);
  final parameter Integer f_sigmasA_count_sum[nC]={sum(data.f_sigmasA_count[1:j - 1])
      for j in 1:nC} annotation (Evaluate=true);

equation
  for j in 1:nC loop
    if use_noGen then
      if TRANSFORM.Math.exists(j, i_noGen) then
        mC_gens[j] = 0.0;
      else
        mC_gens[j] = sum({data.l_lambdas[l_lambdas_count_sum[j] + k]
          *mCs[data.l_lambdas_col[l_lambdas_count_sum[j] + k]] for
          k in 1:data.l_lambdas_count[j]}) - data.lambdas[j]*mCs[j] + sum({data.f_sigmasA[
          f_sigmasA_count_sum[j] + k]*mCs[data.f_sigmasA_col[f_sigmasA_count_sum[j] + k]] for k in 1:data.f_sigmasA_count[
          j]})*phi - data.sigmasA[j]*mCs[j]*phi;
      end if;
    else
      // exactly as above just repeated
        mC_gens[j] = sum({data.l_lambdas[l_lambdas_count_sum[j] + k]
          *mCs[data.l_lambdas_col[l_lambdas_count_sum[j] + k]] for
          k in 1:data.l_lambdas_count[j]}) - data.lambdas[j]*mCs[j] + sum({data.f_sigmasA[
          f_sigmasA_count_sum[j] + k]*mCs[data.f_sigmasA_col[f_sigmasA_count_sum[j] + k]] for k in 1:data.f_sigmasA_count[
          j]})*phi - data.sigmasA[j]*mCs[j]*phi;
    end if;
    rhos[j] = -data.sigmasA[j]*mCs[j]/sum(data.nus[1]*data.sigmasF[k]*mCs[data.actinideIndex[k]] for k in 1:data.nA);
  end for;

  annotation (defaultComponentName="reactivity", Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Isotopes_sparseMatrix;
