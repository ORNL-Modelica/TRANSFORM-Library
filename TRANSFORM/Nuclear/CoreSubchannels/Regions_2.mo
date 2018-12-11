within TRANSFORM.Nuclear.CoreSubchannels;
model Regions_2
  "0-D point kinetics fuel channel model with two solid media regions"
  import TRANSFORM;

  import TRANSFORM.Math.linspace_1D;
  import TRANSFORM.Math.linspaceRepeat_1D;
  import Modelica.Fluid.Types.ModelStructure;
  import TRANSFORM.Fluid.Types.LumpedLocation;
  import Modelica.Fluid.Types.Dynamics;

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium,m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0)) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,
            10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow    port_b(redeclare package Medium
      =                                                                          Medium,m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0)) annotation (
      Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
            {110,10}})));

  parameter Real nParallel=1 "Number of identical parallel coolant channels";

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Coolant medium" annotation (choicesAllMatching=true);
  replaceable package Material_1 =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
      annotation (choicesAllMatching=true);
  replaceable package Material_2 =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
      annotation (choicesAllMatching=true);

  replaceable model Geometry =
      ClosureRelations.Geometry.Models.CoreSubchannels.Generic
    constrainedby ClosureRelations.Geometry.Models.CoreSubchannels.Generic
    "Geometry" annotation (Dialog(group="Geometry"),choicesAllMatching=true);

  Geometry geometry(final nRegions=2)
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

  replaceable model FlowModel =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
    "Coolant flow models (i.e., momentum, pressure loss, wall friction)"
    annotation (choicesAllMatching=true, Dialog(group="Pressure Loss"));

  replaceable model HeatTransfer =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.PartialHeatTransfer_setT
    "Coolant coefficient of heat transfer" annotation (choicesAllMatching=true,
      Dialog(group="Heat Transfer"));

  /* Kinetics */
  parameter SI.Power Q_nominal=1e6
    "Total nominal reactor power (fission + decay)";
  parameter Boolean specifyPower=false
    "=true to specify power (i.e., no der(P) equation)";
  parameter Units.NonDim SF_start_power[geometry.nV]=fill(1/geometry.nV,
      geometry.nV) "Shape factor for the power profile, sum(SF) = 1";
  replaceable record Data_PG =
      ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_TRACEdefault constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.PartialPrecursorGroup
    annotation (choicesAllMatching=true,Dialog(tab="Kinetics",group="Neutron Kinetics"));
  replaceable record Data_DH = ReactorKinetics.Data.DecayHeat.decayHeat_0 constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat.PartialDecayHeat_powerBased
    annotation (choicesAllMatching=true,Dialog(tab="Kinetics",group="Decay-Heat"));
  replaceable record Data_FP =
      ReactorKinetics.Data.FissionProducts.fissionProducts_0 constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.PartialFissionProduct
                                                                                                                                                        annotation (
     choicesAllMatching=true,Dialog(tab="Kinetics",group="Fission Products"));
  parameter SI.Area sigmasA_add_start[Medium.nC]=fill(0, Medium.nC)
    "Microscopic absorption cross-section for reactivity feedback" annotation(Dialog(tab="Kinetics",group="Fluid Trace Substances"));
  input SI.Power Q_fission_input=Q_nominal
    "Fission power (if specifyPower=true)" annotation (Dialog(group="Input"));
  input SI.Power Q_external=0
    "Power from external source of neutrons" annotation (Dialog(group="Input"));
  input Units.NonDim rho_input=0
    "External Reactivity" annotation (Dialog(group="Input"));
  parameter SI.Area dsigmasA_add[Medium.nC]=fill(0, Medium.nC)
    "Change in microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Parameter Change",group="Input: Fluid Trace Substances"));
  parameter SI.Time Lambda_start=1e-5 "Prompt neutron generation time"
    annotation (Dialog(tab="Kinetics",group="Neutron Kinetics"));
  parameter Boolean use_history=false "=true to provide power history"
                                                                      annotation (Dialog(tab="Kinetics",group="Decay-Heat"));
  parameter SI.Power history[:,2]=fill(
      0,
      0,
      2) "Power history up to simulation time=0, [t,Q]" annotation (Dialog(tab="Kinetics",group="Decay-Heat"));
  parameter Boolean includeDH=false
    "=true if power history includes decay heat" annotation (Dialog(tab="Kinetics",group="Decay-Heat"));
  parameter SI.Power Q_fission_start=Q_nominal/(1 + sum(kinetics.efs_dh_start))
    "Initial reactor fission power" annotation (Dialog(tab="Kinetics",group="Neutron Kinetics"));
  parameter SI.Power Cs_pg_start[kinetics.nC]={kinetics.betas_start[j]/(kinetics.lambdas_start[
      j]*Lambda_start)*Q_fission_start for j in 1:kinetics.nC}
    "Power of the initial delayed-neutron precursor concentrations" annotation (Dialog(tab="Kinetics",group="Neutron Kinetics"));
  parameter SI.Energy Es_start[kinetics.nDH]={Q_fission_start*kinetics.efs_dh_start[
      j]/kinetics.lambdas_dh_start[j] for j in 1:kinetics.nDH}
    "Initial decay heat group energy"
    annotation (Dialog(tab="Kinetics", group="Decay-Heat"));
  parameter Units.ExtraPropertyExtrinsic mCs_fp_start[kinetics.nFP]=
      TRANSFORM.Nuclear.ReactorKinetics.Functions.Initial_FissionProducts(
      kinetics.fissionProducts.nC,
      kinetics.fissionProducts.nFS,
      kinetics.fissionProducts.nT,
      kinetics.fissionProducts.parents,
      kinetics.fissionSources_start,
      kinetics.fissionProducts.fissionTypes_start,
      kinetics.fissionProducts.w_f_start,
      kinetics.fissionProducts.SigmaF_start,
      kinetics.fissionProducts.sigmasA_start,
      kinetics.fissionProducts.fissionYields_start,
      kinetics.fissionProducts.lambdas_start,
      fill(1e10, kinetics.fissionProducts.nC),
      kinetics.fissionProducts.Q_fission_start,
      kinetics.fissionProducts.V_start)
    "Number of fission product atoms per group"
    annotation (Dialog(tab="Kinetics", group="Fission Products"));
  input Units.InverseTime dlambdas[kinetics.nC]=fill(0, kinetics.nC)
    "Change in decay constants for each precursor group" annotation(Dialog(tab="Parameter Change",group="Input: Neutron Kinetics"));
  input Units.NonDim dalphas[kinetics.nC]=fill(0, kinetics.nC)
    "Change in normalized precursor fractions [betas = alphas*Beta]" annotation(Dialog(tab="Parameter Change",group="Input: Neutron Kinetics"));
  input Units.NonDim dBeta=0
    "Change in effective delayed neutron fraction [e.g., Beta = sum(beta_i)]" annotation(Dialog(tab="Parameter Change",group="Input: Neutron Kinetics"));
  input SI.Time dLambda=0 "Change in prompt neutron generation time" annotation(Dialog(tab="Parameter Change",group="Input: Neutron Kinetics"));
  input Units.InverseTime dlambdas_dh[kinetics.nDH]=fill(0, kinetics.nDH)
    "Change in decay constant" annotation(Dialog(tab="Parameter Change",group="Input: Decay-Heat"));
  input Units.NonDim defs_dh[kinetics.nDH]=fill(0, kinetics.nDH)
    "Change in effective energy fraction" annotation(Dialog(tab="Parameter Change",group="Input: Decay-Heat"));

  parameter Units.TempFeedbackCoeff alpha_fuel=-2.5e-5
    "Doppler feedback coefficient"
    annotation (Dialog(tab="Kinetics", group="Reactivity Feedback"));
  parameter Units.TempFeedbackCoeff alpha_coolant=-20e-5
    "Moderator feedback coefficient"
    annotation (Dialog(tab="Kinetics", group="Reactivity Feedback"));
  parameter SI.Temperature Teffref_fuel "Fuel reference temperature"
                                 annotation (Dialog(tab="Kinetics", group="Reactivity Feedback"));
  parameter SI.Temperature Teffref_coolant "Coolant reference temperature"
                                    annotation (Dialog(tab="Kinetics", group="Reactivity Feedback"));

  parameter Units.NonDim fissionSources_start[kinetics.nFS]=fill(1/kinetics.nFS,
      kinetics.nFS) "Source of fissile material fractional composition (sum=1)" annotation(Dialog(tab="Kinetics",group="Fission Products"));
  parameter Units.NonDim fissionTypes_start[kinetics.nFS,kinetics.nT]=fill(
      1/kinetics.nT,
      kinetics.nFS,
      kinetics.nT)
    "Fraction of fission from each fission type per fission source, sum(row) = 1" annotation(Dialog(tab="Kinetics",group="Fission Products"));
  parameter Units.NonDim nu_bar_start=2.4 "Neutrons per fission" annotation(Dialog(tab="Kinetics",group="Fission Products"));
  parameter SI.Energy w_f_start=200e6*1.6022e-19 "Energy released per fission" annotation(Dialog(tab="Kinetics",group="Fission Products"));
  parameter SI.MacroscopicCrossSection SigmaF_start=1
    "Macroscopic fission cross-section of fissile material" annotation(Dialog(tab="Kinetics",group="Fission Products"));
  input Units.NonDim dfissionSources[kinetics.nFS]=fill(0, kinetics.nFS)
    "Change in source of fissile material fractional composition (sum=1)" annotation(Dialog(tab="Parameter Change",group="Input: Fission Products"));
  input Units.NonDim dfissionTypes[kinetics.nFS,kinetics.nT]=fill(
      0,
      kinetics.nFS,
      kinetics.nT)
    "Change in fraction of fission from each fission type per fission source, sum(row) = 1" annotation(Dialog(tab="Parameter Change",group="Input: Fission Products"));
  input Units.NonDim dnu_bar=0 "Change in neutrons per fission" annotation(Dialog(tab="Parameter Change",group="Input: Fission Products"));
  input SI.Energy dw_f=0 "Change in energy released per fission" annotation(Dialog(tab="Parameter Change",group="Input: Fission Products"));
  input SI.MacroscopicCrossSection dSigmaF=0
    "Change in macroscopic fission cross-section of fissile material" annotation(Dialog(tab="Parameter Change",group="Input: Fission Products"));
  input SI.Area dsigmasA[kinetics.nFP]=fill(0, kinetics.nFP)
    "Change in microscopic absorption cross-section for reactivity feedback" annotation(Dialog(tab="Parameter Change",group="Input: Fission Products"));
  input Real dfissionYields[kinetics.nFP,kinetics.nFS,kinetics.nT]=fill(
      0,
      kinetics.nFP,
      kinetics.nFS,
      kinetics.nT)
    "Change in # fission product atoms yielded per fission per fissile source [#/fission]" annotation(Dialog(tab="Parameter Change",group="Input: Fission Products"));
  input Units.InverseTime dlambdas_FP[kinetics.nFP]=fill(0, kinetics.nFP)
    "Change in decay constants for each fission product" annotation(Dialog(tab="Parameter Change",group="Input: Fission Products"));

  // Fuel Initialization
  parameter SI.Temperature T_start_1=Material_1.T_default "Fuel temperature"
    annotation (Dialog(tab="Fuel Element Initialization",group="Reference Temperatures for Start Values"));
  parameter SI.Temperature T_start_2=Material_1.T_default "Cladding temperature"
    annotation (Dialog(tab="Fuel Element Initialization",group="Reference Temperatures for Start Values"));

  parameter SI.Temperature Ts_start_1[geometry.nRs[1],geometry.nV]=fill(
      T_start_1,
      geometry.nRs[1],
      geometry.nV) "Fuel temperatures"     annotation (Dialog(tab="Fuel Element Initialization",
        group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start_2[geometry.nRs[2],geometry.nV]=[{Ts_start_1
      [end, :]}; fill(
      T_start_2,
      geometry.nRs[2] - 1,
      geometry.nV)] "Cladding temperatures" annotation (Dialog(tab="Fuel Element Initialization",
        group="Start Value: Temperature"));

      // Coolant Initialization
  parameter SI.AbsolutePressure[geometry.nV] ps_start=linspace_1D(
      p_a_start,
      p_b_start,
      geometry.nV) "Pressure" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_a_start=Medium.p_default
    "Pressure at port a" annotation (Dialog(tab="Coolant Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start=p_a_start + (if m_flow_a_start > 0 then -1e3 elseif m_flow_a_start < 0 then -1e3 else 0)
    "Pressure at port b" annotation (Dialog(tab="Coolant Initialization", group="Start Value: Absolute Pressure"));

  parameter Boolean use_Ts_start=true
    "Use T_start if true, otherwise h_start" annotation (Evaluate=true, Dialog(
        tab="Coolant Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start[geometry.nV]=linspace_1D(
      T_a_start,
      T_b_start,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Coolant Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.Temperature T_a_start=Medium.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.Temperature T_b_start=T_a_start
    "Temperature at port b" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));

  parameter SI.SpecificEnthalpy[geometry.nV] hs_start=if not
      use_Ts_start then linspace_1D(
      h_a_start,
      h_b_start,
      geometry.nV) else {Medium.specificEnthalpy_pTX(
      ps_start[i],
      Ts_start[i],
      Xs_start[i, 1:Medium.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.SpecificEnthalpy h_a_start=Medium.specificEnthalpy_pTX(
      p_a_start,
      T_a_start,
      X_a_start) "Specific enthalpy at port a" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.SpecificEnthalpy h_b_start=Medium.specificEnthalpy_pTX(
      p_b_start,
      T_b_start,
      X_b_start) "Specific enthalpy at port b" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));

  parameter SI.MassFraction Xs_start[geometry.nV,Medium.nX]=
      linspaceRepeat_1D(
      X_a_start,
      X_b_start,
      geometry.nV) "Mass fraction" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SI.MassFraction X_a_start[Medium.nX]=Medium.X_default
    "Mass fraction at port a" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start[Medium.nX]=X_a_start
    "Mass fraction at port b" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Species Mass Fraction"));

  parameter SI.MassFraction Cs_start[geometry.nV,Medium.nC]=
      linspaceRepeat_1D(
      C_a_start,
      C_b_start,
      geometry.nV) "Mass fraction" annotation (Dialog(
      tab="Coolant Initialization",
      group="Start Value: Trace Substances Mass Fraction",
      enable=Medium.nC > 0));
  parameter SI.MassFraction C_a_start[Medium.nC]=fill(0, Medium.nC)
    "Mass fraction at port a" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Trace Substances Mass Fraction"));
  parameter SI.MassFraction C_b_start[Medium.nC]=C_a_start
    "Mass fraction at port b" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Trace Substances Mass Fraction"));

  parameter SI.MassFlowRate[geometry.nV + 1] m_flows_start=linspace(
      m_flow_a_start,
      -m_flow_b_start,
      geometry.nV + 1) "Mass flow rates" annotation (Evaluate=true, Dialog(tab="Coolant Initialization",
        group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_a_start=0 "Mass flow rate at port_a"
    annotation (Dialog(tab="Coolant Initialization", group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_b_start=-m_flow_a_start
    "Mass flow rate at port_b" annotation (Dialog(tab="Coolant Initialization",
        group="Start Value: Mass Flow Rate"));

  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances {coolant}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics energyDynamics_fuel=Dynamics.DynamicFreeInitial
    "Formulation of energy balances {fuel}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics
    "Formulation of mass balances {coolant}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances {coolant}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics momentumDynamics=Dynamics.SteadyState "Formulation of momentum balances {coolant}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));

  parameter Dynamics kineticDynamics=energyDynamics_fuel
    "Formulation of nuclear kinetics balances" annotation (Dialog(tab="Advanced", group="Dynamics: Kinetics"));
  parameter Dynamics precursorDynamics=kineticDynamics
    "Formulation of neutron precursor balances" annotation (Dialog(tab="Advanced", group="Dynamics: Kinetics"));
  parameter Dynamics decayheatDynamics=kineticDynamics
    "Formulation of decay-heat balances" annotation (Dialog(tab="Advanced", group="Dynamics: Kinetics"));
  parameter Dynamics fissionProductDynamics=kineticDynamics
    "Formulation of fission product balances" annotation (Dialog(tab="Advanced", group="Dynamics: Kinetics"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Advanced", group="Coolant"));
  parameter Boolean exposeState_a=true
    "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(tab="Advanced", group="Coolant"));
  parameter Boolean exposeState_b=false
    "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(tab="Advanced", group="Coolant"));
  parameter Boolean useLumpedPressure=false
    "=true to lump pressure states together"
    annotation (Dialog(tab="Advanced", group="Coolant"), Evaluate=true);
  parameter LumpedLocation lumpPressureAt=LumpedLocation.port_a
    "Location of pressure for flow calculations" annotation (Dialog(
      tab="Advanced",
      group="Coolant",
      enable=if useLumpedPressure and modelStructure <>
          ModelStructure.av_vb then true else false), Evaluate=true);
  parameter Boolean useInnerPortProperties=false
    "=true to take port properties for flow models from internal control volumes"
    annotation (Dialog(tab="Advanced", group="Coolant"), Evaluate=true);

  // Visualization
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  parameter Boolean showDesignFlowDirection = true annotation(Dialog(tab="Visualization"));

  Real SF_mC_add[geometry.nV,Medium.nC] = {{coolantSubchannel.mCs[i, j]/sum(coolantSubchannel.mCs[:, j]) for j in 1:Medium.nC} for i in 1:geometry.nV};

  Modelica.Blocks.Sources.RealExpression Q_total(y=kinetics.Q_total)
    "Total power (fission+decay heat)"
    annotation (Placement(transformation(extent={{50,26},{34,36}})));

  TRANSFORM.Nuclear.ReactorKinetics.PointKinetics_L1_powerBased kinetics(
    Q_nominal=Q_nominal,
    specifyPower=specifyPower,
    redeclare record Data_DH = Data_DH,
    redeclare record Data_FP = Data_FP,
    nC_add=Medium.nC,
    sigmasA_add_start=sigmasA_add_start,
    redeclare record Data = Data_PG,
    dsigmasA_add=dsigmasA_add,
    Lambda_start=Lambda_start,
    use_history=use_history,
    history=history,
    includeDH=includeDH,
    nFeedback=2,
    dlambdas=dlambdas,
    dalphas=dalphas,
    dBeta=dBeta,
    dLambda=dLambda,
    dlambdas_dh=dlambdas_dh,
    defs_dh=defs_dh,
    fissionSources_start=fissionSources_start,
    fissionTypes_start=fissionTypes_start,
    nu_bar_start=nu_bar_start,
    w_f_start=w_f_start,
    SigmaF_start=SigmaF_start,
    dfissionSources=dfissionSources,
    dfissionTypes=dfissionTypes,
    dnu_bar=dnu_bar,
    dw_f=dw_f,
    dSigmaF=dSigmaF,
    dsigmasA=dsigmasA,
    dfissionYields=dfissionYields,
    dlambdas_FP=dlambdas_FP,
    energyDynamics=kineticDynamics,
    traceDynamics=precursorDynamics,
    decayheatDynamics=decayheatDynamics,
    fissionProductDynamics=fissionProductDynamics,
    Q_fission_input=Q_fission_input,
    Q_external=Q_external,
    rho_input=rho_input,
    alphas_feedback={alpha_fuel,alpha_coolant},
    vals_feedback={fuelModel.region_1.solutionMethod.T_effective,
        coolantSubchannel.summary.T_effective},
    vals_feedback_reference={Teffref_fuel,Teffref_coolant},
    Q_fission_start=Q_fission_start,
    Cs_start=Cs_pg_start,
    Es_start=Es_start,
    V=fuelModel.region_1.solutionMethod.V_total*fuelModel.nParallel,
    mCs_start=mCs_fp_start,
    mCs_add={sum(coolantSubchannel.mCs[:, j])*coolantSubchannel.nParallel for j
         in 1:Medium.nC},
    Vs_add=coolantSubchannel.geometry.V_total*coolantSubchannel.nParallel,
    toggle_ReactivityFP=toggle_ReactivityFP)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface
                                       coolantSubchannel(
    use_HeatTransfer=true,
    redeclare package Medium = Medium,
    p_a_start=p_a_start,
    p_b_start=p_b_start,
    nParallel=nParallel,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    allowFlowReversal=allowFlowReversal,
    redeclare model FlowModel = FlowModel,
    redeclare model HeatTransfer = HeatTransfer,
    useLumpedPressure=useLumpedPressure,
    lumpPressureAt=lumpPressureAt,
    useInnerPortProperties=useInnerPortProperties,
    use_Ts_start=use_Ts_start,
    T_a_start=T_a_start,
    T_b_start=T_b_start,
    Ts_start=Ts_start,
    h_a_start=h_a_start,
    h_b_start=h_b_start,
    hs_start=hs_start,
    ps_start=ps_start,
    Ts_wall(start={{fuelModel.Ts_start_2[end, i] for j in 1:coolantSubchannel.heatTransfer.nSurfaces} for i in 1:coolantSubchannel.nV}),
    Xs_start=Xs_start,
    Cs_start=Cs_start,
    X_a_start=X_a_start,
    X_b_start=X_b_start,
    C_a_start=C_a_start,
    C_b_start=C_b_start,
    m_flow_a_start=m_flow_a_start,
    m_flow_b_start=m_flow_b_start,
    m_flows_start=m_flows_start,
    exposeState_a=exposeState_a,
    exposeState_b=exposeState_b,
    energyDynamics=energyDynamics,
    traceDynamics=traceDynamics,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=geometry.nV,
        dimension=geometry.dimension,
        crossArea=geometry.crossArea,
        perimeter=geometry.perimeter,
        length=geometry.length,
        roughness=geometry.roughness,
        surfaceArea=geometry.surfaceArea,
        dheight=geometry.dheight,
        nSurfaces=geometry.nSurfaces,
        height_a=geometry.height_a,
        angle=geometry.angle),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens={{SF_mC_add[i, j]*kinetics.fissionProducts.mC_gens_add[j] for
            j in 1:Medium.nC} for i in 1:coolantSubchannel.nV}))
                                             annotation (Placement(
        transformation(
        extent={{-15,-13},{15,13}},
        rotation=0,
        origin={0,-14})));

  TRANSFORM.Nuclear.FuelModels.Regions_2_FD2DCyl
                               fuelModel(
    energyDynamics=energyDynamics_fuel,
    length=geometry.length,
    nParallel=geometry.nPins*nParallel,
    nZ=geometry.nV,
    redeclare package Material_1 = Material_1,
    redeclare package Material_2 = Material_2,
    T_start_1=T_start_1,
    T_start_2=T_start_2,
    Ts_start_1=Ts_start_1,
    Ts_start_2=Ts_start_2,
    nR_1=geometry.nRs[1],
    nR_2=geometry.nRs[2],
    r_1_outer=geometry.rs_outer[1],
    r_2_outer=geometry.rs_outer[2])
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,10})));

  Blocks.ShapeFactor shapeFactor(n=geometry.nV, SF_start=SF_start_power)
    annotation (Placement(transformation(extent={{24,26},{14,36}})));
  parameter Boolean toggle_ReactivityFP=true
    "=true to include fission product reacitivity feedback"
    annotation (Dialog(tab="Kinetics", group="Fission Products"));
equation

  connect(port_a, coolantSubchannel.port_a) annotation (Line(points={{-100,0},{-70,
          0},{-40,0},{-40,-14},{-15,-14}}, color={0,127,255}));
  connect(coolantSubchannel.port_b, port_b) annotation (Line(points={{15,-14},{40,
          -14},{40,0},{100,0}}, color={0,127,255}));
  connect(fuelModel.heatPorts_b, coolantSubchannel.heatPorts[:, 1]) annotation (
     Line(points={{0.1,-0.2},{0.1,-4.1},{0,-4.1},{0,-7.5}}, color={127,0,0}));
  connect(shapeFactor.u, Q_total.y)
    annotation (Line(points={{25,31},{33.2,31}}, color={0,0,127}));
  connect(shapeFactor.y, fuelModel.Power_in)
    annotation (Line(points={{13.5,31},{0,31},{0,21}}, color={0,0,127}));
  annotation (defaultComponentName="coreSubchannel",
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),        Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={        Ellipse(
          extent={{-92,30},{-108,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a),
        Ellipse(
          extent={{108,30},{92,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b),    Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,24},{100,-24}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-65,5},{-55,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-5,5},{5,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{55,5},{65,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,40},{30,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Line(
          points={{-30,40},{-30,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName)),
        Polygon(
          points={{20,-45},{60,-60},{20,-75},{20,-45}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Polygon(
          points={{20,-50},{50,-60},{20,-70},{20,-50}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Line(
          points={{55,-60},{-60,-60}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=DynamicSelect(true,showDesignFlowDirection))}));
end Regions_2;
