within TRANSFORM.HeatAndMassTransfer.DiscritizedModels;
model HMTransfer_2D
  import Modelica.Fluid.Types.Dynamics;
  import TRANSFORM.Math.linspaceRepeat_2Dedge;
  extends Conduction_2D;
  parameter Integer nC = 1 "Number of substances";
  // Initialization
  parameter Dynamics traceDynamics=energyDynamics
    "Formulation of trace substance balances"
    annotation (Dialog(tab="Initialization", group="Dynamics"));
  parameter SI.Concentration Cs_start[nVs[1],nVs[2],nC]=linspaceRepeat_2Dedge(
      C_a1_start,
      C_b1_start,
      C_a2_start,
      C_b2_start,
      nVs[1],
      nVs[2],
      {exposeState_b2,exposeState_a1,exposeState_a2,exposeState_b1})
    "Trace substance concentration" annotation (Dialog(tab="Initialization",
        group="Start Value: Concentration"));
  parameter SI.Concentration C_a1_start[nC]=fill(0,nC) "Concentration at portM_a1"
    annotation (Dialog(tab="Initialization", group="Start Value: Concentration"));
  parameter SI.Concentration C_b1_start[nC]=C_a1_start "Concentration at portM_b1"
    annotation (Dialog(tab="Initialization", group="Start Value: Concentration"));
  parameter SI.Concentration C_a2_start[nC]=fill(0,nC) "Concentration at portM_a2"
    annotation (Dialog(tab="Initialization", group="Start Value: Concentration"));
  parameter SI.Concentration C_b2_start[nC]=C_a2_start "Concentration at portM_b2"
    annotation (Dialog(tab="Initialization", group="Start Value: Concentration"));
  parameter Boolean adiabaticDimsMT[2]={false,false}
    "=true, toggle off diffusive mass transfer in dimension {1,2}"
    annotation (Dialog(group="Trace Mass Transfer"));
  replaceable model DiffusionModel =
      BaseClasses.Dimensions_2.ForwardDifferenceMass_1O constrainedby BaseClasses.Dimensions_2.PartialDistributedMassFlow
    "Diffusive mass transfer" annotation (Dialog(group="Trace Mass Transfer"),
      choicesAllMatching=true);
  DiffusionModel diffusionModel(
    redeclare final package Material = Material,
    final nVs=nVs,
    final nC=nC,
    final nFM_1=nFM_1,
    final nFM_2=nFM_2,
    final adiabaticDims=adiabaticDimsMT,
    final crossAreas_1=crossAreas_1FM,
    final crossAreas_2=crossAreas_2FM,
    final lengths_1=lengths_1FM,
    final lengths_2=lengths_2FM,
    final states_1=statesFM_1,
    final states_2=statesFM_2,
    final Cs_1=CsFM_1,
    final Cs_2=CsFM_2,
    final D_abs_1=D_absFM_1,
    final D_abs_2=D_absFM_2) "Diffusion Model" annotation (Placement(
        transformation(extent={{-58,62},{-42,78}}, rotation=0)));
  replaceable model DiffusionCoeff =
      TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient    constrainedby
    TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.PartialMassDiffusionCoefficient
    "Diffusion Coefficient" annotation (Dialog(group="Trace Mass Transfer"),
      choicesAllMatching=true);
  DiffusionCoeff diffusionCoeff[nVs[1],nVs[2]](
    each final nC=nC,
    final T=materials.T) "Diffusion Coefficient" annotation (Placement(
        transformation(extent={{-38,42},{-22,58}}, rotation=0)));
  replaceable model InternalMassModel =
      BaseClasses.Dimensions_2.GenericMassGeneration constrainedby BaseClasses.Dimensions_2.PartialInternalMassGeneration
    "Internal mass generation" annotation (Dialog(group="Trace Mass Transfer"),
      choicesAllMatching=true);
  InternalMassModel internalMassModel(
    redeclare final package Material = Material,
    final nVs=nVs,
    final nC=nC,
    final Vs=geometry.Vs,
    final crossAreas_1=geometry.crossAreas_1,
    final crossAreas_2=geometry.crossAreas_2,
    final lengths_1=geometry.dlengths_1,
    final lengths_2=geometry.dlengths_2,
    final Cs=Cs,
    final states=materials.state) "Internal mass generation model" annotation (Placement(
        transformation(extent={{-38,62},{-22,78}}, rotation=0)));
  parameter Boolean use_nCs_scaled = false "=true to use der(nCs_scaled) = nCbs/C_nominal else der(nCs) = nCbs." annotation(Dialog(tab="Advanced"));
  parameter Units.NonDim C_nominal[nC] = fill(1e-6,nC) "Nominal concentration [mol/m3] for improved numeric stability" annotation(Dialog(tab="Advanced",enable=use_nCs_scaled));
  // Total quantities
  Units.Mole nCs[nVs[1],nVs[2],nC] "Trace substance moles";
  Units.Mole[nVs[1],nVs[2],nC] nCs_scaled "Scaled trace substance moles for improved numerical stability";
  SI.Concentration Cs[nVs[1],nVs[2],nC](each stateSelect=StateSelect.prefer, start=
       Cs_start) "Trace substance concentration";
  // Energy Balance
  SI.MolarFlowRate nCbs[nVs[1],nVs[2],nC]
    "Molar flow rate across volume interfaces (e.g., diffusion) and sources from volume states, (e.g., chemical reactions, external convection)";
  Interfaces.MolePort_State portM_external[nVs[1],nVs[2]](each nC=nC)
    "External mass transfer in non-discritized dimensions" annotation (
      Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-70,-110},{-50,-90}})));
  SI.MolarFlowRate nC_flows_1[nVs[1] + 1,nVs[2],nC]
    "Molar flow rates across segment boundaries";
  SI.MolarFlowRate nC_flows_2[nVs[1],nVs[2] + 1,nC]
    "Molar flow rates across segment boundaries";
  SI.Concentration C_a1[nVs[2],nC]
    "Concentration defined by volume outside portM_a1";
  SI.Concentration C_b1[nVs[2],nC]
    "Concentration defined by volume outside portM_b1";
  SI.Concentration C_a2[nVs[1],nC]
    "Concentration defined by volume outside portM_a2";
  SI.Concentration C_b2[nVs[1],nC]
    "Concentration defined by volume outside portM_b2";
  Interfaces.MolePort_Flow portM_a1[nVs[2]](each nC=nC)
                                            annotation (Placement(
        transformation(extent={{-110,-50},{-90,-30}}),
                                                     iconTransformation(extent=
            {{-110,-50},{-90,-30}})));
  Interfaces.MolePort_Flow    portM_b1[nVs[2]](each nC=nC)
                                               annotation (Placement(
        transformation(extent={{90,-50},{110,-30}}),
                                                   iconTransformation(extent={{
            90,-50},{110,-30}})));
  Interfaces.MolePort_Flow portM_a2[nVs[1]](each nC=nC)
                                            annotation (Placement(
        transformation(extent={{30,-110},{50,-90}}), iconTransformation(extent=
            {{30,-108},{50,-88}})));
  Interfaces.MolePort_Flow    portM_b2[nVs[1]](each nC=nC)
                                               annotation (Placement(
        transformation(extent={{30,90},{50,110}}), iconTransformation(extent={{
            30,90},{50,110}})));
protected
  SI.Concentration CsFM_1[nFM_1 + 1,nVs[2],nC];
  SI.Concentration CsFM_2[nVs[1],nFM_2 + 1,nC];
  SI.DiffusionCoefficient D_absFM_1[nFM_1 + 1,nVs[2],nC];
  SI.DiffusionCoefficient D_absFM_2[nVs[1],nFM_2 + 1,nC];
initial equation
  if traceDynamics == Dynamics.SteadyStateInitial then
    der(nCs) = zeros(nVs[1], nVs[2],nC);
  elseif traceDynamics == Dynamics.FixedInitial then
    Cs = Cs_start;
  end if;
equation
for ic in 1:nC loop
  // Total Quantities
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      nCs[i, j, ic] = Cs[i, j, ic]*Vs[i, j];
    end for;
  end for;
  // Mass Balance
  if traceDynamics == Dynamics.SteadyState then
    for i in 1:nVs[1] loop
      for j in 1:nVs[2] loop
        0 = nCbs[i, j, ic];
      end for;
    end for;
  else
    if use_nCs_scaled then
      for i in 1:nVs[1] loop
        for j in 1:nVs[2] loop
          der(nCs_scaled[i, j, ic]) = nCbs[i, j, ic]/C_nominal[ic];
          nCs[i, j, ic] = nCs_scaled[i, j, ic]*C_nominal[ic];
        end for;
      end for;
    else
      for i in 1:nVs[1] loop
        for j in 1:nVs[2] loop
          nCs_scaled[i, j, ic] = 0;
          der(nCs[i, j, ic]) = nCbs[i, j, ic];
        end for;
      end for;
    end if;
  end if;
  // Boundary Conditions
  portM_a1[:].n_flow[ic] =nParallel*(nC_flows_1[1, :, ic]);
  portM_b1[:].n_flow[ic] =nParallel*(-nC_flows_1[nVs[1] + 1, :, ic]);
  portM_a2[:].n_flow[ic] =nParallel*(nC_flows_2[:, 1, ic]);
  portM_b2[:].n_flow[ic] =nParallel*(-nC_flows_2[:, nVs[2] + 1, ic]);
  portM_external[:,:].C[ic] = Cs[:,:,ic];
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
        nCbs[i, j, ic] = nC_flows_1[i, j, ic] - nC_flows_1[i + 1, j, ic]
           + nC_flows_2[i, j, ic] - nC_flows_2[i, j + 1, ic] + (internalMassModel.n_flows[i, j, ic] +
          portM_external[i, j].n_flow[ic])/nParallel;
    end for;
  end for;
  C_a1[:,ic] = portM_a1[:].C[ic];
  C_b1[:,ic] = portM_b1[:].C[ic];
  C_a2[:,ic] = portM_a2[:].C[ic];
  C_b2[:,ic] = portM_b2[:].C[ic];
  /*##########################################################################*/
  /*                    Dimension-1 Flow Model Definitions                    */
  /*##########################################################################*/
  if exposeState_a1 and exposeState_b1 then
    assert(nVs[1] > 1,
      "nVs[1] must be > 1 if exposeState_a1 and exposeState_b1 = true");
  end if;
  for j in 1:nVs[2] loop
    if exposeState_a1 and exposeState_b1 then
      /************************************************************************/
      /*             1.a Model Structure (true, true) (i.e., v_v)             */
      /************************************************************************/
      //nFM_1 = nVs[1]-1
      // Connections
        nC_flows_1[2:nVs[1], j, ic] = diffusionModel.n_flows_1[1:nVs[1] - 1, j,
          ic];
      /* Boundary Ports */
      // Left Boundary
      portM_a1[j].C[ic] = Cs[1, j,ic];
      // Right Boundary
      portM_b1[j].C[ic] = Cs[nVs[1], j,ic];
      /* State Variables */
      for i in 1:nFM_1 + 1 loop
        CsFM_1[i, j,ic] = Cs[i, j,ic];
        D_absFM_1[i, j,ic] = diffusionCoeff[i, j].D_abs[ic];
      end for;
    elseif exposeState_a1 and not exposeState_b1 then
      /************************************************************************/
      /*             1.b Model Structure (true, false) (i.e., v_)             */
      /************************************************************************/
      //nFM_1 = nVs[1]
      // Connections
        nC_flows_1[2:nVs[1] + 1, j, ic] = diffusionModel.n_flows_1[1:nVs[1], j,
          ic];
      /* Boundary Ports */
      // Left Boundary
      portM_a1[j].C[ic] = Cs[1, j,ic];
      // Right Boundary - set by connecting model
      /* State Variables */
      for i in 1:nFM_1 loop
        CsFM_1[i, j,ic] = Cs[i, j,ic];
        D_absFM_1[i, j,ic] = diffusionCoeff[i, j].D_abs[ic];
      end for;
      CsFM_1[nFM_1 + 1, j,ic] = C_b1[j,ic];
      D_absFM_1[nFM_1 + 1, j,ic] = diffusionCoeff[end, j].D_abs[ic];
    elseif not exposeState_a1 and exposeState_b1 then
      /************************************************************************/
      /*             1.c Model Structure (false, true) (i.e., _v)             */
      /************************************************************************/
      //nFM_1 = nVs[1]
      // Connections
        nC_flows_1[1:nVs[1], j, ic] = diffusionModel.n_flows_1[1:nVs[1], j, ic];
      /* Boundary Ports */
      // Left Boundary - set by connecting model
      // Right Boundary
      portM_b1[j].C[ic] = Cs[nVs[1], j,ic];
      /* State Variables */
      CsFM_1[1, j,ic] = C_a1[j,ic];
      D_absFM_1[1, j,ic] = diffusionCoeff[1, j].D_abs[ic];
      for i in 2:nFM_1 + 1 loop
        CsFM_1[i, j,ic] = Cs[i - 1, j,ic];
        D_absFM_1[i, j,ic] = diffusionCoeff[i - 1, j].D_abs[ic];
      end for;
    elseif not exposeState_a1 and not exposeState_b1 then
      /************************************************************************/
      /*            1.d Model Structure (false, false) (i.e., _v_)            */
      /************************************************************************/
      //nFM_1 = nVs[1]+1;
      // Connections
        nC_flows_1[1:nVs[1] + 1, j, ic] = diffusionModel.n_flows_1[1:nVs[1] + 1,
          j, ic];
      /* Boundary Ports */
      // Left Boundary - set by connecting model
      // Right Boundary - set by connecting model
      /* State Variables */
      CsFM_1[1, j,ic] = C_a1[j,ic];
      D_absFM_1[1, j,ic] = diffusionCoeff[1, j].D_abs[ic];
      for i in 2:nFM_1 loop
        CsFM_1[i, j,ic] = Cs[i - 1, j,ic];
        D_absFM_1[i, j,ic] = diffusionCoeff[i - 1, j].D_abs[ic];
      end for;
      CsFM_1[nFM_1 + 1, j,ic] = C_b1[j,ic];
      D_absFM_1[nFM_1 + 1, j,ic] = diffusionCoeff[end, j].D_abs[ic];
    else
      assert(false, "Unknown model structure");
    end if;
  end for;
  /*##########################################################################*/
  /*                    Dimension-2 Flow Model Definitions                    */
  /*##########################################################################*/
  if exposeState_a2 and exposeState_b2 then
    assert(nVs[2] > 1,
      "nVs[2] must be > 1 if exposeState_a2 and exposeState_b2 = true");
  end if;
  for i in 1:nVs[1] loop
    if exposeState_a2 and exposeState_b2 then
      /************************************************************************/
      /*             2.a Model Structure (true, true) (i.e., v_v)             */
      /************************************************************************/
      //nFM_2 = nVs[2]-1
      // Connections
        nC_flows_2[i, 2:nVs[2], ic] = diffusionModel.n_flows_2[i, 1:nVs[2] - 1,
          ic];
      /* Boundary Ports */
      // Bottom Boundary
      portM_a2[i].C[ic] = Cs[i, 1,ic];
      // Top Boundary
      portM_b2[i].C[ic] = Cs[i, nVs[2],ic];
      /* State Variables */
      for j in 1:nFM_2 + 1 loop
        CsFM_2[i, j,ic] = Cs[i, j,ic];
        D_absFM_2[i, j,ic] = diffusionCoeff[i, j].D_abs[ic];
      end for;
    elseif exposeState_a2 and not exposeState_b2 then
      /************************************************************************/
      /*             2.b Model Structure (true, false) (i.e., v_)             */
      /************************************************************************/
      //nFM_2 = nVs[2]
      // Connections
        nC_flows_2[i, 2:nVs[2] + 1, ic] = diffusionModel.n_flows_2[i, 1:nVs[2],
          ic];
      /* Boundary Ports */
      // Bottom Boundary
      portM_a2[i].C[ic] = Cs[i, 1,ic];
      // Top Boundary - set by connecting model
      /* State Variables */
      for j in 1:nFM_2 loop
        CsFM_2[i, j,ic] = Cs[i, j,ic];
        D_absFM_2[i, j,ic] = diffusionCoeff[i, j].D_abs[ic];
      end for;
      CsFM_2[i, nFM_2 + 1,ic] = C_b2[i,ic];
      D_absFM_2[i, nFM_2 + 1,ic] = diffusionCoeff[i, end].D_abs[ic];
    elseif not exposeState_a2 and exposeState_b2 then
      /************************************************************************/
      /*             2.c Model Structure (false, true) (i.e., _v)             */
      /************************************************************************/
      //nFM_2 = nVs[2]
      // Connections
        nC_flows_2[i, 1:nVs[2], ic] = diffusionModel.n_flows_2[i, 1:nVs[2], ic];
      /* Boundary Ports */
      // Bottom Boundary - set by connecting model
      // Top Boundary
      portM_b2[i].C[ic] = Cs[i, nVs[2],ic];
      /* State Variables */
      CsFM_2[i, 1,ic] = C_a2[i,ic];
      D_absFM_2[i, 1,ic] = diffusionCoeff[i, 1].D_abs[ic];
      for j in 2:nFM_2 + 1 loop
        CsFM_2[i, j,ic] = Cs[i, j - 1,ic];
        D_absFM_2[i, j,ic] = diffusionCoeff[i, j - 1].D_abs[ic];
      end for;
    elseif not exposeState_a2 and not exposeState_b2 then
      /************************************************************************/
      /*            2.d Model Structure (false, false) (i.e., _v_)            */
      /************************************************************************/
      //nFM_2 = nVs[2]+1;
      // Connections
        nC_flows_2[i, 1:nVs[2] + 1, ic] = diffusionModel.n_flows_2[i, 1:nVs[2]
           + 1, ic];
      /* Boundary Ports */
      // Bottom Boundary - set by connecting model
      // Top Boundary - set by connecting model
      /* State Variables */
      CsFM_2[i, 1,ic] = C_a2[i,ic];
      D_absFM_2[i, 1,ic] = diffusionCoeff[i, 1].D_abs[ic];
      for j in 2:nFM_2 loop
        CsFM_2[i, j,ic] = Cs[i, j - 1,ic];
        D_absFM_2[i, j,ic] = diffusionCoeff[i, j - 1].D_abs[ic];
      end for;
      CsFM_2[i, nFM_2 + 1,ic] = C_b2[i,ic];
      D_absFM_2[i, nFM_2 + 1,ic] = diffusionCoeff[i, end].D_abs[ic];
    else
      assert(false, "Unknown model structure");
    end if;
  end for;
end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HMTransfer_2D;
