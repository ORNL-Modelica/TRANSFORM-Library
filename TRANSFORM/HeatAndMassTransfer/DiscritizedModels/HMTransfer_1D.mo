within TRANSFORM.HeatAndMassTransfer.DiscritizedModels;
model HMTransfer_1D
  import Modelica.Fluid.Types.Dynamics;
  import TRANSFORM.Math.linspaceRepeat_1D;
  extends Conduction_1D;
  parameter Integer nC = 1 "Number of substances";
  // Initialization
  parameter Dynamics traceDynamics=energyDynamics
    "Formulation of trace substance balances"
    annotation (Dialog(tab="Initialization", group="Dynamics"));
  parameter SI.Concentration Cs_start[nVs[1],nC]=linspaceRepeat_1D(
      C_a1_start,
      C_b1_start,
      nVs[1]) "Trace substance concentration" annotation (Dialog(tab=
          "Initialization", group="Start Value: Concentration"));
  parameter SI.Concentration C_a1_start[nC]=fill(0,nC) "Concentration at portM_a1"
    annotation (Dialog(tab="Initialization", group="Start Value: Concentration"));
  parameter SI.Concentration C_b1_start[nC]=C_a1_start "Concentration at portM_b1"
    annotation (Dialog(tab="Initialization", group="Start Value: Concentration"));
  replaceable model DiffusionModel =
      BaseClasses.Dimensions_1.ForwardDifferenceMass_1O    constrainedby
    BaseClasses.Dimensions_1.PartialDistributedMassFlow
    "Diffusive mass transfer" annotation (Dialog(group="Trace Mass Transfer"),
      choicesAllMatching=true);
  DiffusionModel diffusionModel(
    redeclare final package Material = Material,
    final nVs=nVs,
    final nC=nC,
    final nFM_1=nFM_1,
    final crossAreas_1=crossAreas_1FM,
    final lengths_1=lengths_1FM,
    final states_1=statesFM_1,
    final Cs_1=CsFM_1,
    final D_abs_1=D_absFM_1) "Diffusion Model" annotation (Placement(
        transformation(extent={{-58,62},{-42,78}}, rotation=0)));
  replaceable model DiffusionCoeff =
      TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
                                                                                          constrainedby
    TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.PartialMassDiffusionCoefficient
    "Diffusion Coefficient" annotation (Dialog(group="Trace Mass Transfer"),
      choicesAllMatching=true);
  DiffusionCoeff diffusionCoeff[nVs[1]](
    each final nC=nC,
    final T=materials.T) "Diffusion Coefficient" annotation (Placement(
        transformation(extent={{-38,42},{-22,58}}, rotation=0)));
  replaceable model InternalMassModel =
      BaseClasses.Dimensions_1.GenericMassGeneration    constrainedby
    BaseClasses.Dimensions_1.PartialInternalMassGeneration
    "Internal mass generation" annotation (Dialog(group="Trace Mass Transfer"),
      choicesAllMatching=true);
  InternalMassModel internalMassModel(
    redeclare final package Material = Material,
    final nVs=nVs,
    final nC=nC,
    final Vs=geometry.Vs,
    final crossAreas_1=geometry.crossAreas_1,
    final lengths_1=geometry.dlengths_1,
    final Cs=Cs,
    final states=materials.state) "Internal mass generation model" annotation (Placement(
        transformation(extent={{-38,62},{-22,78}}, rotation=0)));
  parameter Boolean use_nCs_scaled = false "=true to use der(nCs_scaled) = nCbs/C_nominal else der(nCs) = nCbs." annotation(Dialog(tab="Advanced"));
  parameter Units.NonDim C_nominal[nC] = fill(1e-6,nC) "Nominal concentration [mol/m3] for improved numeric stability" annotation(Dialog(tab="Advanced",enable=use_nCs_scaled));
  // Total quantities
  Units.Mole nCs[nVs[1],nC] "Trace substance moles";
  Units.Mole[nVs[1],nC] nCs_scaled "Scaled trace substance moles for improved numerical stability";
  SI.Concentration Cs[nVs[1],nC](each stateSelect=StateSelect.prefer, start=
        Cs_start) "Trace substance concentration";
  // Energy Balance
  SI.MolarFlowRate nCbs[nVs[1],nC]
    "Molar flow rate across volume interfaces (e.g., diffusion) and source/sinks in volumes (e.g., chemical reactions, external convection)";
  Interfaces.MolePort_State portM_external[nVs[1]](each nC=nC)
    "External mass transfer in non-discritized dimensions" annotation (
      Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-70,-110},{-50,-90}})));
  SI.MolarFlowRate nC_flows_1[nVs[1] + 1,nC]
    "Molar flow rates across segment boundaries";
  SI.Concentration C_a1[nC] "Concentration defined by volume outside portM_a1";
  SI.Concentration C_b1[nC] "Concentration defined by volume outside portM_b1";
  Interfaces.MolePort_Flow portM_a1(nC=nC)
                                        annotation (Placement(transformation(extent={{-110,
            -50},{-90,-30}}),     iconTransformation(extent={{-110,-50},{-90,-30}})));
  Interfaces.MolePort_Flow    portM_b1(nC=nC)
                                           annotation (Placement(transformation(
          extent={{90,-50},{110,-30}}),
                                      iconTransformation(extent={{90,-50},{110,
            -30}})));
protected
  SI.Concentration CsFM_1[nFM_1 + 1,nC];
  SI.DiffusionCoefficient D_absFM_1[nFM_1 + 1,nC];
initial equation
  if traceDynamics == Dynamics.SteadyStateInitial then
    der(nCs) = zeros(nVs[1],nC);
  elseif traceDynamics == Dynamics.FixedInitial then
    Cs = Cs_start;
  end if;
equation
for ic in 1:nC loop
  // Total Quantities
  for i in 1:nVs[1] loop
    nCs[i,ic] = Cs[i,ic]*Vs[i];
  end for;
  // Mass Balance
  if traceDynamics == Dynamics.SteadyState then
    for i in 1:nVs[1] loop
      0 = nCbs[i, ic];
    end for;
  else
    if use_nCs_scaled then
      for i in 1:nVs[1] loop
       der(nCs_scaled[i,ic])  = nCbs[i, ic]/C_nominal[ic];
       nCs[i,ic] = nCs_scaled[i,ic]*C_nominal[ic];
      end for;
    else
      for i in 1:nVs[1] loop
        nCs_scaled[i, ic] = 0;
        der(nCs[i, ic]) = nCbs[i, ic];
      end for;
    end if;
  end if;
  // Boundary Conditions
  portM_a1.n_flow[ic] =nParallel*(nC_flows_1[1, ic]);
  portM_b1.n_flow[ic] =nParallel*(-nC_flows_1[nVs[1] + 1, ic]);
  portM_external[:].C[ic] = Cs[:,ic];
  for i in 1:nVs[1] loop
      nCbs[i, ic] = nC_flows_1[i, ic] - nC_flows_1[i + 1, ic] + (internalMassModel.n_flows[i, ic] + portM_external[i].n_flow[
        ic])/nParallel;
  end for;
  C_a1[ic] = portM_a1.C[ic];
  C_b1[ic] = portM_b1.C[ic];
  /*##########################################################################*/
  /*                    Dimension-1 Flow Model Definitions                    */
  /*##########################################################################*/
  if exposeState_a1 and exposeState_b1 then
    assert(nVs[1] > 1,
      "nVs[1] must be > 1 if exposeState_a1 and exposeState_b1 = true");
  end if;
  if exposeState_a1 and exposeState_b1 then
    /************************************************************************/
    /*             1.a Model Structure (true, true) (i.e., v_v)             */
    /************************************************************************/
    //nFM_1 = nVs[1]-1
    // Connections
      nC_flows_1[2:nVs[1], ic] = diffusionModel.n_flows_1[1:nVs[1] - 1, ic];
    /* Boundary Ports */
    // Left Boundary
    portM_a1.C[ic] = Cs[1,ic];
    // Right Boundary
    portM_b1.C[ic] = Cs[nVs[1],ic];
    //materials[nVs[1]].T;
    /* State Variables */
    for i in 1:nFM_1 + 1 loop
      CsFM_1[i,ic] = Cs[i,ic];
      D_absFM_1[i,ic] = diffusionCoeff[i].D_abs[ic];
    end for;
  elseif exposeState_a1 and not exposeState_b1 then
    /************************************************************************/
    /*             1.b Model Structure (true, false) (i.e., v_)             */
    /************************************************************************/
    //nFM_1 = nVs[1]
    // Connections
      nC_flows_1[2:nVs[1] + 1, ic] = diffusionModel.n_flows_1[1:nVs[1], ic];
    /* Boundary Ports */
    // Left Boundary
    portM_a1.C[ic] = Cs[1,ic];
    // Right Boundary - set by connecting model
    /* State Variables */
    for i in 1:nFM_1 loop
      CsFM_1[i,ic] = Cs[i,ic];
      D_absFM_1[i,ic] = diffusionCoeff[i].D_abs[ic];
    end for;
    CsFM_1[nFM_1 + 1,ic] = C_b1[ic];
    D_absFM_1[nFM_1 + 1,ic] = diffusionCoeff[end].D_abs[ic];
  elseif not exposeState_a1 and exposeState_b1 then
    /************************************************************************/
    /*             1.c Model Structure (false, true) (i.e., _v)             */
    /************************************************************************/
    //nFM_1 = nVs[1]
    // Connections
      nC_flows_1[1:nVs[1], ic] = diffusionModel.n_flows_1[1:nVs[1], ic];
    /* Boundary Ports */
    // Left Boundary - set by connecting model
    // Right Boundary
    portM_b1.C[ic] = Cs[nVs[1],ic];
    /* State Variables */
    CsFM_1[1,ic] = C_a1[ic];
    D_absFM_1[1,ic] = diffusionCoeff[1].D_abs[ic];
    for i in 2:nFM_1 + 1 loop
      CsFM_1[i,ic] = Cs[i - 1,ic];
      D_absFM_1[i,ic] = diffusionCoeff[i - 1].D_abs[ic];
    end for;
  elseif not exposeState_a1 and not exposeState_b1 then
    /************************************************************************/
    /*            1.d Model Structure (false, false) (i.e., _v_)            */
    /************************************************************************/
    //nFM_1 = nVs[1]+1;
    // Connections
      nC_flows_1[1:nVs[1] + 1, ic] = diffusionModel.n_flows_1[1:nVs[1] + 1, ic];
    /* Boundary Ports */
    // Left Boundary - set by connecting model
    // Right Boundary - set by connecting model
    /* State Variables */
    CsFM_1[1,ic] = C_a1[ic];
    D_absFM_1[1,ic] = diffusionCoeff[1].D_abs[ic];
    for i in 2:nFM_1 loop
      CsFM_1[i,ic] = Cs[i - 1,ic];
      D_absFM_1[i,ic] = diffusionCoeff[i - 1].D_abs[ic];
    end for;
    CsFM_1[nFM_1 + 1,ic] = C_b1[ic];
    D_absFM_1[nFM_1 + 1,ic] = diffusionCoeff[end].D_abs[ic];
  else
    assert(false, "Unknown model structure");
  end if;
end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HMTransfer_1D;
