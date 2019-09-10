within TRANSFORM.Nuclear.ReactorKinetics.Reactivity;
model FissionProducts
  import Modelica.Fluid.Types.Dynamics;
  // Fission products
  replaceable record Data =
      TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_0
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.PartialFissionProduct
    "Fission Product Data" annotation (choicesAllMatching=true);
  Data data;
  parameter Integer nC=data.nC "# of fission products";
  parameter Integer nFS=data.nFS "# of fission product sources";
  parameter Integer nT=data.nT
    "# of fission product types (e.g., fast/thermal)";
  parameter Real[nC,nC] parents=data.parents
    "Matrix of parent-daughter sources";
  parameter Integer nC_add=0
    "# of additional substances (i.e., trace fluid substances)";
  parameter Units.NonDim fissionSources_start[nFS]=fill(1/nFS, nFS)
    "Fission source material fractional composition (sum=1)"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter Units.NonDim fissionTypes_start[nFS,nT]=fill(
      1/nT,
      nFS,
      nT)
    "Fraction of fission from each fission type per fission source, sum(row) = 1"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter Units.NonDim nu_bar_start=2.4 "Neutrons per fission"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter SI.Energy w_f_start=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter SI.MacroscopicCrossSection SigmaF_start=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter SI.Area sigmasA_start[nC]=data.sigmasA
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Initialization", group="Fission Products"));
  parameter Real fissionYields_start[nC,nFS,nT]=data.fissionYields
    "# fission product atoms yielded per fission per fissile source [#/fission]"
    annotation (Dialog(tab="Initialization", group="Fission Products"));
  parameter Units.InverseTime lambdas_start[nC]=data.lambdas
    "Decay constants for each fission product"
    annotation (Dialog(tab="Initialization", group="Fission Products"));
  input Units.NonDim dfissionSources[nFS]=fill(0, nFS)
    "Change in source of fissile material fractional composition (sum=1)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Fission Sources"));
  input Units.NonDim dfissionTypes[nFS,nT]=fill(
      0,
      nFS,
      nT)
    "Change in fraction of fission from each fission type per fission source, sum(row) = 1"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Fission Sources"));
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
  input Real dfissionYields[nC,nFS,nT]=fill(
      0,
      nC,
      nFS,
      nT)
    "Change in # fission product atoms yielded per fission per fissile source [#/fission]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Fission Products"));
  input Units.InverseTime dlambdas[nC]=fill(0, nC)
    "Change in decay constants for each fission product" annotation (Dialog(tab=
         "Parameter Change", group="Inputs: Fission Products"));
  Units.NonDim fissionSources[nFS]=fissionSources_start + dfissionSources
    "Source of fissile material fractional composition (sum=1)";
  Units.NonDim fissionTypes[nFS,nT]=fissionTypes_start + dfissionTypes
    "Fraction of fission from each fission type per fission source, sum(row) = 1";
  Units.NonDim nu_bar=nu_bar_start + dnu_bar "Neutrons per fission";
  SI.Energy w_f=w_f_start + dw_f "Energy released per fission";
  SI.MacroscopicCrossSection SigmaF=SigmaF_start + dSigmaF
    "Macroscopic fission cross-section of fissile material";
  SI.Area sigmasA[nC]=sigmasA_start + dsigmasA
    "Microscopic absorption cross-section for reactivity feedback";
  Real fissionYields[nC,nFS,nT]=fissionYields_start + dfissionYields
    "# fission product atoms yielded per fission per fissile source [#/fission]";
  Units.InverseTime lambdas[nC]=lambdas_start + dlambdas
    "Decay constants for each fission product";
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
  parameter SIadd.ExtraPropertyExtrinsic mCs_start[nC]=
      Functions.Initial_FissionProducts(
      nC,
      nFS,
      nT,
      parents,
      fissionSources_start,
      fissionTypes_start,
      w_f_start,
      SigmaF_start,
      sigmasA_start,
      fissionYields_start,
      lambdas_start,
      fill(1e10, nC),
      Q_fission_start,
      V_start) "Number of fission product atoms per group"
    annotation (Dialog(tab="Initialization"));
  parameter Dynamics traceDynamics=Dynamics.DynamicFreeInitial
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Real mC_nominal[nC]=fill(1e-6, nC)
    "Nominal fission product atoms. For numeric purposes only."
    annotation (Dialog(tab="Advanced"));
  SIadd.NeutronFlux phi "Neutron flux";
  SIadd.ExtraPropertyFlowRate mC_gens[nC]
    "Generation rate of fission products [atoms/s]";
  SIadd.ExtraPropertyExtrinsic mCs[nC](each stateSelect=StateSelect.prefer,
      start=mCs_start) "Number of fission product atoms";
  SIadd.ExtraPropertyExtrinsic mCs_scaled[nC]
    "Scaled number of fission product atoms for improved numerical stability";
  input SIadd.ExtraPropertyExtrinsic mCs_add[nC_add]=fill(0, nC_add)
    "Number of atoms" annotation (Dialog(group="Inputs: Additional Reactivity"));
  input SI.Volume Vs_add=0.1 "Volume for fisson product concentration basis"
    annotation (Dialog(group="Inputs: Additional Reactivity"));
  parameter SI.Area sigmasA_add_start[nC_add]=fill(0, nC_add)
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(group="Additional Reactivity", tab="Initialization"));
  input SI.Area dsigmasA_add[nC_add]=fill(0, nC_add)
    "Change in microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(group="Inputs: Additional Reactivity", tab="Parameter Change"));
  SI.Area sigmasA_add[nC_add]=sigmasA_add_start + dsigmasA_add
    "Microscopic absorption cross-section for reactivity feedback";
  parameter SIadd.NonDim rhos_start[nC]={-sigmasA_start[j]*mCs_start[j]/(
      nu_bar_start*SigmaF_start)/V_start for j in 1:nC}
    "Initial fission product reactivity feedback"
    annotation (Dialog(tab="Outputs", enable=false));
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
    der(mCs_scaled[:]) = mC_gens[:] ./ mC_nominal;
    mCs[:] = mCs_scaled[:] .* mC_nominal;
  end if;
  phi =Q_fission/(w_f*SigmaF)/V;
  for j in 1:nC loop
    mC_gens[j] =Q_fission/w_f*sum({fissionSources[k]*sum({fissionTypes[k, m]*
      fissionYields[j, k, m] for m in 1:nT}) for k in 1:nFS}) - lambdas[j]*mCs[
      j] + sum(lambdas .* mCs[:] .* parents[j, :]) - sigmasA[j]*mCs[j]*
      Q_fission/(w_f*SigmaF)/V;
    rhos[j] =-sigmasA[j]*mCs[j]/(nu_bar*SigmaF)/V;
  end for;
  // Additional substances from another source
  for j in 1:nC_add loop
    mC_gens_add[j] =-sigmasA_add[j]*mCs_add[j]*Q_fission/(w_f*SigmaF)/Vs_add;
    rhos_add[j] = -sigmasA_add[j]*mCs_add[j]/(nu_bar*SigmaF)/Vs_add;
  end for;
  annotation (defaultComponentName="fissionProducts", Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/BatemanEquations.jpg")}));
end FissionProducts;
