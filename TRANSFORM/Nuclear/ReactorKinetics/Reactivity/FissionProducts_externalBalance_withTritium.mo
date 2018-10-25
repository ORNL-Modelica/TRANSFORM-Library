within TRANSFORM.Nuclear.ReactorKinetics.Reactivity;
model FissionProducts_externalBalance_withTritium
  "FissionProducts using external trace balance (e.g., fluid volumes) with an additional tritium contributor"

  import Modelica.Fluid.Types.Dynamics;

  // Fission products
  parameter Integer nV=1 "# of discrete volumes";

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

  input SI.Power Qs_fission=1e6
    "Power determined from kinetics. Does not include fission product decay heat"
    annotation (Dialog(group="Inputs"));
  input SIadd.NonDim SF_Qs_fission[nV] = fill(1/nV,nV) "Shape factor for Qs_fission, sum() = 1" annotation(Dialog(group="Shape Factors"));
  input SI.Volume[nV] Vs=fill(0.1, nV)
    "Volume for fisson product concentration basis"
    annotation (Dialog(group="Inputs"));

  SIadd.NeutronFlux phi[nV] "Neutron flux";
  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens
    "Generation rate of fission products [atoms/s]";
  input SIadd.ExtraPropertyExtrinsic[nV,nC] mCs={{0 for j in 1:nC} for i in 1:nV}
    "Fission product number in each volume [atoms]"
    annotation (Dialog(group="Inputs"));

  // Tritium Sources
  replaceable record Data_TR =
      TRANSFORM.Nuclear.ReactorKinetics.Data.Tritium.tritium_0
    constrainedby TRANSFORM.Nuclear.ReactorKinetics.Data.Tritium.PartialTritium
    "Tritium Contributors Data" annotation (choicesAllMatching=true,Dialog(tab="Tritium Balance"));

  Data_TR data_TR;
  parameter Integer nTR = data_TR.nC "Tritium contributers"
                                                           annotation (Dialog(tab="Tritium Balance"));
  //parameter Integer iH3 = 1 "Index of tritium (1-H-3) in fission products array"annotation (Dialog(tab="Tritium Balance"));
  final parameter Integer iH3 = TRANSFORM.Utilities.Strings.index("1-H-3",data.extraPropertiesNames) "Index of tritium (1-H-3) in fission products array"
                                                                                                                                                         annotation (Dialog(tab="Tritium Balance"));
  parameter Real[nTR,nTR] parents_TR=data_TR.parents
    "Matrix of parent sources for each tritium contributor 'daughter'."
    annotation (Dialog(tab="Tritium Balance"));

  parameter SI.Area sigmasA_TR_start[nTR]=data_TR.sigmasA
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Tritium Balance"));
  input SI.Area dsigmasA_TR[nTR]=fill(0, nTR)
    "Change in microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(group="Inputs: Parameter Change", tab="Tritium Balance"));
  SI.Area sigmasA_TR[nTR]=sigmasA_TR_start + dsigmasA_TR
    "Microscopic absorption cross-section for reactivity feedback";

  parameter SI.Area sigmasT_TR_start[nTR]=data_TR.sigmasT
    "Microscopic absorption cross-section for tritium generation"
    annotation (Dialog(tab="Tritium Balance"));
  input SI.Area dsigmasT_TR[nTR]=fill(0, nTR)
    "Change in microscopic absorption cross-section for tritium generation"
    annotation (Dialog(group="Inputs: Parameter Change", tab="Tritium Balance"));
  SI.Area sigmasT_TR[nTR]=sigmasT_TR_start + dsigmasT_TR
    "Microscopic absorption cross-section for tritium generation";

  parameter Units.InverseTime lambdas_TR_start[nTR]=data_TR.lambdas
    "Decay constants for each tritium contributor" annotation (Dialog(tab="Tritium Balance"));
  input Units.InverseTime dlambdas_TR[nTR]=fill(0,nTR)
    "Decay constants for each tritium contributor" annotation (Dialog(group="Inputs: Parameter Change", tab="Tritium Balance"));
  Units.InverseTime lambdas_TR[nTR]=lambdas_TR_start + dlambdas_TR
    "Decay constants for each tritium contributor";

  input SIadd.ExtraPropertyExtrinsic[nV,nTR] mCs_TR={{0 for j in 1:nTR} for i in 1:nV}
    "Amount of each contributor to tritium [atoms]"
    annotation (Dialog(tab="Tritium Balance", group="Inputs"));

  Units.ExtraPropertyFlowRate mC_gens_H3[nV,nTR]
    "Generation rate of tritium [atoms/s]";

  output SIadd.NonDim rhos[nV,nC] "Fission product reactivity feedback"
    annotation (Dialog(tab="Outputs", enable=false));
  output TRANSFORM.Units.NonDim[nV,nTR] rhos_TR "Tritium contributors reactivity feedback"
    annotation (Dialog(tab="Outputs", enable=false));
  output SIadd.ExtraPropertyFlowRate[nV,nTR] mC_gens_TR "Generation rate of tritium contributors [atoms/s]"
    annotation (Dialog(
      tab="Outputs",
      enable=false));

equation

  for i in 1:nV loop
    phi[i] = Qs_fission*SF_Qs_fission[i]/(w_f*SigmaF)/Vs[i];
    for j in 1:nC loop
      mC_gens[i, j] = Qs_fission*SF_Qs_fission[i]/w_f*sum({fissionSources[k]*sum({
        fissionTypes[k, m]*fissionYields[j, k, m] for m in 1:nT}) for k in 1:
        nFS}) - lambdas[j]*mCs[i, j] + sum(lambdas .* mCs[i, :] .* parents[j, :])
         - sigmasA[j]*mCs[i, j]*Qs_fission*SF_Qs_fission[i]/(w_f*SigmaF)/Vs[i] + (if j == iH3 then sum(mC_gens_H3[i, :]) else 0);
      rhos[i, j] = -sigmasA[j]*mCs[i, j]/(nu_bar*SigmaF)/Vs[i]*SF_Qs_fission[i];
    end for;
  end for;

  // Tritium sources from carrier fluid (e.g., FLiBe)
  for i in 1:nV loop
    for j in 1:nTR loop
       mC_gens_TR[i, j] =-lambdas_TR[j]*mCs_TR[i, j] + sum(lambdas_TR .* mCs_TR[
        i, :] .* parents_TR[j, :]) - (sigmasA_TR[j] + sigmasT_TR[j])*mCs_TR[i,
        j]*Qs_fission*SF_Qs_fission[i]/(w_f*SigmaF)/Vs[i];
      rhos_TR[i,j] =-(sigmasA_TR[j] + sigmasT_TR[j])*mCs_TR[i, j]/(nu_bar*
        SigmaF)/Vs[i]*SF_Qs_fission[i];
        end for;
  end for;

  mC_gens_H3 ={{sigmasT_TR[j]*mCs_TR[i, j]*Qs_fission*SF_Qs_fission[i]/(w_f*SigmaF)/Vs[i]
    for j in 1:nTR} for i in 1:nV};

  annotation (defaultComponentName="fissionProducts",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Bitmap(extent={{-100,-100},{100,100}},
            fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/BatemanEquations.jpg")}));
end FissionProducts_externalBalance_withTritium;
