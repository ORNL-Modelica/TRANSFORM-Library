within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity;
model FissionProducts_sparseMatrix
  import Modelica.Fluid.Types.Dynamics;
  // Fission products
  replaceable record Data =
      SparseMatrix.Data.FissionProducts.fissionProducts_0 constrainedby
    SparseMatrix.Data.FissionProducts.PartialFissionProduct
    "Fission Product Data" annotation (choicesAllMatching=true);
  Data data;

  final parameter Integer nC=data.nC "# of fission products";

  parameter Units.NonDim nu_bar_start=2.4 "Neutrons per fission"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter SI.Energy w_f_start=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter SI.MacroscopicCrossSection SigmaF_start=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  input Units.NonDim dnu_bar=0 "Change in neutrons per fission" annotation (
      Dialog(tab="Parameter Change", group="Inputs: Fission Sources"));
  input SI.Energy dw_f=0 "Change in energy released per fission" annotation (
      Dialog(tab="Parameter Change", group="Inputs: Fission Sources"));
  input SI.MacroscopicCrossSection dSigmaF=0
    "Change in macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Fission Sources"));
  input SI.Area dsigmasA[nC]=fill(0, nC)
    "Change in microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Fission Products"));

  input Units.InverseTime dlambdas[nC]=fill(0, nC)
    "Change in decay constants for each fission product" annotation (Dialog(tab=
         "Parameter Change", group="Inputs: Fission Products"));
  Units.NonDim nu_bar=nu_bar_start + dnu_bar "Neutrons per fission";
  SI.Energy w_f=w_f_start + dw_f "Energy released per fission";
  SI.MacroscopicCrossSection SigmaF=SigmaF_start + dSigmaF
    "Macroscopic fission cross-section of fissile material";

  parameter SI.Power Q_fission_start=1e6
    "Power determined from kinetics. Does not include fission product decay heat"
    annotation (Dialog(tab="Initialization"));
  input SI.Power Q_fission=Q_fission_start
    "Power determined from kinetics. Does not include fission product decay heat"
    annotation (Dialog(group="Inputs"));
  input SI.Volume V=V_start "Volume for fisson product concentration basis"
    annotation (Dialog(group="Inputs"));
  parameter SI.Volume V_start=0.1
    "Volume for fisson product concentration basis"
    annotation (Dialog(tab="Initialization"));
  parameter SIadd.ExtraPropertyExtrinsic mCs_start[nC]=zeros(nC)
    "Number of fission product atoms per group"
    annotation (Dialog(tab="Initialization"));

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
  //        mCs_guess=mCs_start) "Number of fission product atoms per group"
  //      annotation (Dialog(tab="Initialization"));

  parameter Dynamics traceDynamics=Dynamics.DynamicFreeInitial
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  SIadd.NeutronFlux phi "Neutron flux";
  SIadd.ExtraPropertyFlowRate mC_gens[nC]
    "Generation rate of fission products [atoms/s]";
  SIadd.ExtraPropertyExtrinsic mCs[nC](each stateSelect=StateSelect.prefer,
      start=mCs_start) "Number of fission product atoms";
  SIadd.ExtraPropertyExtrinsic mCs_scaled[nC]
    "Scaled number of fission product atoms for improved numerical stability";

  parameter Boolean use_noGen=false
    "=true to set mC_gen = 0 for indices in i_noGen" annotation (Evaluate=true);
  parameter Integer i_noGen[:]={0} "Index of fission product to be held constant";

  parameter Integer nC_add=0
    "# of additional substances (i.e., trace fluid substances)";
  input SIadd.ExtraPropertyExtrinsic mCs_add[nC_add]=fill(0, nC_add)
    "Number of atoms" annotation (Dialog(group="Inputs: Additional Reactivity"));
  input SI.Volume Vs_add=0.1 "Volume for fisson product concentration basis"
    annotation (Dialog(group="Inputs: Additional Reactivity"));
  input SI.Area sigmasA_add[nC_add]=fill(0, nC_add)
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(group="Inputs: Additional Reactivity"));

  output SIadd.NonDim rhos[nC] "Fission product reactivity feedback"
    annotation (Dialog(tab="Outputs", enable=false));
  output SIadd.ExtraPropertyFlowRate[nC_add] mC_gens_add
    "Generation rate of additional substances [atoms/s] (e.g., Boron in fluid)"
    annotation (Dialog(
      group="Additional Reactivity",
      tab="Outputs",
      enable=false));
  output SIadd.NonDim rhos_add[nC_add]
    "Additional subtances reactivity feedback" annotation (Dialog(
      group="Additional Reactivity",
      tab="Outputs",
      enable=false));

initial equation
  if traceDynamics == Dynamics.FixedInitial then
    mCs = mCs_start;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mCs) = zeros(nC);
  end if;
equation
  if traceDynamics == Dynamics.SteadyState then
    zeros(nC) = mC_gens[:];
  else
    der(mCs_scaled[:]) = mC_gens[:] ./ data.C_nominal;
    mCs[:] = mCs_scaled[:] .* data.C_nominal;
  end if;
  phi = Q_fission/(w_f*SigmaF)/V;
  for j in 1:nC loop
    if use_noGen then
      if TRANSFORM.Math.exists(j, i_noGen) then
        mC_gens[j] = 0.0;
      else
        mC_gens[j] = sum({data.l_lambdas[sum(data.l_lambdas_count[1:j - 1]) + k]
          *mCs[data.l_lambdas_col[sum(data.l_lambdas_count[1:j - 1]) + k]] for
          k in 1:data.l_lambdas_count[j]}) - data.lambdas[j]*mCs[j] + sum({data.f_sigmasA[
          sum(data.f_sigmasA_count[1:j - 1]) + k]*mCs[data.f_sigmasA_col[sum(
          data.f_sigmasA_count[1:j - 1]) + k]] for k in 1:data.f_sigmasA_count[
          j]})*phi - data.sigmasA[j]*mCs[j]*phi;
      end if;
    else
      // exactly as above just repeated
      mC_gens[j] = sum({data.l_lambdas[sum(data.l_lambdas_count[1:j - 1]) + k]*
        mCs[data.l_lambdas_col[sum(data.l_lambdas_count[1:j - 1]) + k]] for k in
            1:data.l_lambdas_count[j]}) - data.lambdas[j]*mCs[j] + sum({data.f_sigmasA[
        sum(data.f_sigmasA_count[1:j - 1]) + k]*mCs[data.f_sigmasA_col[sum(data.f_sigmasA_count[
        1:j - 1]) + k]] for k in 1:data.f_sigmasA_count[j]})*phi - data.sigmasA[
        j]*mCs[j]*phi;
    end if;
    rhos[j] = -data.sigmasA[j]*mCs[j]/(nu_bar*SigmaF)/V;
  end for;
  // Additional substances from another source
  for j in 1:nC_add loop
    mC_gens_add[j] = -sigmasA_add[j]*mCs_add[j]*Q_fission/(w_f*SigmaF)/Vs_add;
    rhos_add[j] = -sigmasA_add[j]*mCs_add[j]/(nu_bar*SigmaF)/Vs_add;
  end for;

  annotation (defaultComponentName="fissionProducts", Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/BatemanEquations.jpg")}));
end FissionProducts_sparseMatrix;
