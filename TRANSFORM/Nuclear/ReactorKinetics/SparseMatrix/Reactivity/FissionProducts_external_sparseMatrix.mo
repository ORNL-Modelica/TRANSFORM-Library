within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity;
model FissionProducts_external_sparseMatrix
  "FissionProducts using external trace balance (e.g., fluid volumes)"
  import Modelica.Fluid.Types.Dynamics;
  // Fission products
  parameter Integer nV=1 "# of discrete volumes";
  replaceable record Data =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_null
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.PartialIsotopes
    "Fission Product Data" annotation (choicesAllMatching=true);
  Data data;
  constant Integer nC=data.nC "# of fission products";

  input TRANSFORM.Units.NonDim nu_bar=2.4 "Neutrons per fission"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.Energy w_f=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.MacroscopicCrossSection SigmaF=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.Power Q_fission=1e6
    "Power determined from kinetics. Does not include fission product decay heat"
    annotation (Dialog(group="Inputs"));
  input SIadd.NonDim SF_Q_fission[nV]=fill(1/nV, nV)
    "Shape factor for Q_fission, sum() = 1"
    annotation (Dialog(group="Shape Factors"));
  input SI.Volume[nV] Vs=fill(0.1, nV)
    "Volume for fisson product concentration basis"
    annotation (Dialog(group="Inputs"));
  SIadd.NeutronFlux phi[nV] "Neutron flux";
  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens
    "Generation rate of fission products [atoms/s]";
  input SIadd.ExtraPropertyExtrinsic[nV,nC] mCs={{0 for j in 1:nC} for i in 1:
      nV} "Fission product number in each volume [atoms]"
    annotation (Dialog(group="Inputs"));
  output SIadd.NonDim rhos[nV,nC] "Fission product reactivity feedback"
    annotation (Dialog(tab="Outputs", enable=false));
  parameter Boolean use_noGen=false
    "=true to set mC_gen = 0 for indices in i_noGen" annotation (Evaluate=true);
  parameter Integer i_noGen[:]=data.actinideIndex
    "Index of fission product to be held constant";

  parameter Integer l_lambdas_count_sum[nC]={sum(data.l_lambdas_count[1:j - 1])
      for j in 1:nC} annotation (Evaluate=true);
  parameter Integer f_sigmasA_count_sum[nC]={sum(data.f_sigmasA_count[1:j - 1])
      for j in 1:nC} annotation (Evaluate=true);

equation
  for i in 1:nV loop
    phi[i] = Q_fission*SF_Q_fission[i]/(w_f*SigmaF)/Vs[i];
    for j in 1:nC loop
      if use_noGen then
        //if Modelica.Math.Vectors.find(j,i_noGen)>0 then
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
      rhos[i, j] = -data.sigmasA[j]*mCs[i, j]/(nu_bar*SigmaF)/Vs[i]*
        SF_Q_fission[i];
    end for;
  end for;

  annotation (defaultComponentName="fissionProducts", Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/BatemanEquations.jpg")}));
end FissionProducts_external_sparseMatrix;
