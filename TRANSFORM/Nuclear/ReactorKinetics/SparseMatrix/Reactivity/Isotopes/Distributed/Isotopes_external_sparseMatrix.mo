within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Distributed;
model Isotopes_external_sparseMatrix
  extends PartialIsotopesExternal;

  parameter Boolean use_noGen=false
    "=true to set mC_gen = 0 for indices in i_noGen" annotation (Evaluate=true);
  parameter Integer i_noGen[:]=data.actinideIndex "Index of isotopes to be held constant if use_noGen";

protected
  final parameter Integer l_lambdas_count_sum[nC]={sum(data.l_lambdas_count[1:j - 1])
      for j in 1:nC} annotation (Evaluate=true);
  final parameter Integer f_sigmasA_count_sum[nC]={sum(data.f_sigmasA_count[1:j - 1])
      for j in 1:nC} annotation (Evaluate=true);

  Real SigmaA[nV] = {sum({data.nus[1]*data.sigmasF[k]*mCs[i,data.actinideIndex[k]] for k in 1:data.nA}) for i in 1:nV};
equation
  for i in 1:nV loop
    for j in 1:nC loop
      if use_noGen then
        //if Modelica.Math.Vectors.find(j,i_noGen)>0 then // alternative function
        if TRANSFORM.Math.exists(j, i_noGen) then
          mC_gens[i, j] = 0.0;
        else
          mC_gens[i, j] = sum({data.l_lambdas[l_lambdas_count_sum[j] + k]*mCs[i,
            data.l_lambdas_col[l_lambdas_count_sum[j] + k]] for k in 1:data.l_lambdas_count[
            j]}) - data.lambdas[j]*mCs[i, j] + sum({data.f_sigmasA[
            f_sigmasA_count_sum[j] + k]*mCs[i, data.f_sigmasA_col[
            f_sigmasA_count_sum[j] + k]] for k in 1:data.f_sigmasA_count[j]})*
            phi[i] - data.sigmasA[j]*mCs[i, j]*phi[i];
        end if;
      else
        // exactly as above just repeated
        mC_gens[i, j] = sum({data.l_lambdas[l_lambdas_count_sum[j] + k]*mCs[i,
          data.l_lambdas_col[l_lambdas_count_sum[j] + k]] for k in 1:data.l_lambdas_count[
          j]}) - data.lambdas[j]*mCs[i, j] + sum({data.f_sigmasA[
          f_sigmasA_count_sum[j] + k]*mCs[i, data.f_sigmasA_col[
          f_sigmasA_count_sum[j] + k]] for k in 1:data.f_sigmasA_count[j]})*phi[
          i] - data.sigmasA[j]*mCs[i, j]*phi[i];
      end if;
    // this seems correct for poisons which start with a concentration of zero.
    // for simplicity, actinides will be neglected for reactivity feedback
    // shift to transport driven power is advisable to keep the solution tractable
    // rho = (fprime-f)/fprime yields the below (assuming mCs for absorbption is very small)
     if TRANSFORM.Math.exists(j,data.actinideIndex) then
       rhos[i,j] = 0.0;
     else
       rhos[i,j] = -data.sigmasA[j]*mCs[i,j]*SF_Q_fission[i]/SigmaA[i];
     end if;
    end for;
  end for;

  annotation (defaultComponentName="reactivity", Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Isotopes_external_sparseMatrix;
