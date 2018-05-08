within TRANSFORM.HeatExchangers.BellDelaware_STHX;
model STHX_BellDelaware
  "Shell and tube heat exchanger model using: tube-side: MSL dynamic pipe model; shell-side: Bell Delaware dP and heat transfer method"

  import Modelica.Constants.pi;
  outer Modelica.Fluid.System system "System wide properties";

  parameter Real nParallel = 1 "# of identical parallel STHXs";

  replaceable package Medium_tube =
      Modelica.Media.Interfaces.PartialMedium "Tube side medium"
    annotation (__Dymola_choicesAllMatching=true,Dialog(group="Tube Parameters"));
  replaceable package Tube_Material =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
                                              "Tube wall material"
                         annotation (
     __Dymola_choicesAllMatching=true,Dialog(group="Tube Parameters"));

  replaceable package Medium_shell =
      Modelica.Media.Interfaces.PartialMedium "Shell side medium"
    annotation (__Dymola_choicesAllMatching=true,Dialog(group="Shell Parameters"));
  parameter Boolean isGas=false "true if Medium is a gas"
    annotation(Dialog(group="Shell Parameters"));
  parameter Real np=0
    "Gas specific exponential correction factor (e.g., air = 0; N2 = 0.12)"
    annotation(Dialog(group="Shell Parameters"));

  parameter SI.Length height_a_shell=0
    "Shell Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(group="Shell Parameters"), Evaluate=true);
  parameter SI.Length dheight_entryPipe_a=0
    "Height(shell inlet nozzle midpoint) - Shell Height(port_a)"
    annotation (Dialog(group="Shell Parameters"), Evaluate=true);
  parameter SI.Length dheight_shell=0
    "Height(shell outlet nozzle midpoint) - Height(shell inlet nozzle midpoint)"
    annotation (Dialog(group="Shell Parameters"), Evaluate=true);
  parameter SI.Length dheight_entryPipe_b=0
    "Shell Height(port_b) - Height(shell outlet nozzle midpoint)"
    annotation (Dialog(group="Shell Parameters"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a_tube(redeclare package Medium =
        Medium_tube)
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_tube(redeclare package Medium =
        Medium_tube)
    annotation (Placement(transformation(extent={{-70,90},{-50,110}}),
        iconTransformation(extent={{-10,90},{10,110}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a_shell(redeclare package Medium
      = Medium_shell)
    annotation (Placement(transformation(extent={{50,90},{70,110}}),
        iconTransformation(extent={{45,90},{65,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_shell(redeclare package Medium
      = Medium_shell)
    annotation (Placement(transformation(extent={{50,-110},{70,-90}}),
        iconTransformation(extent={{45,-110},{65,-90}})));

  // General Shell Parameters
  parameter Boolean counterCurrent=true
    "Swap temperature and flux vector order"
 annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  parameter Boolean toggleStaggered = true
    "true = staggered grid type; false = in-line"
 annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  parameter Real n_tubes(min=1)=1
    "Total # of heat transfer tubes (n_T = n_bs + n_tubes)"
 annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  parameter Real n_bs=0 "Total # of blind and support rods"
 annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  final parameter Real n_T = n_tubes + n_bs
    "Total # of tubes (including blind and support)";

  parameter SI.Length DB=D_i "Tube bundle diameter"
annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  parameter SI.Length D_BE = DB
    "Diameter of circle that touches outermost tubes"
annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  parameter SI.Length d_o "Outer diameter of tubes"
annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  parameter SI.Length e1=0 "Space between tubes and shell"
annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  parameter Real nes "# of shortest connections connecting neighboring tubes"
annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));

  // Cross Flow Section Parameters
  parameter SI.Length D_i "Inside shell diameter"
  annotation(Dialog(tab="Shell Side Part 1",group="Cross Flow Section Parameters"));
  parameter Real n_MR "# of  main resistances in cross flow path"
annotation(Dialog(tab="Shell Side Part 1",group="Cross Flow Section Parameters"));
  parameter Real n_MRE "# of main resistances in end cross flow path"
annotation(Dialog(tab="Shell Side Part 1",group="Cross Flow Section Parameters"));

  // Window Section Parameters
  parameter Real n_W_tubes
    "Total # of heat transfer tubes in both the upper and lower window"
annotation(Dialog(tab="Shell Side Part 1",group="Window Section Parameters"));
  parameter Real n_W_bs=0
    "Total # of blind and support rods in uppper and lower window"
annotation(Dialog(tab="Shell Side Part 1",group="Window Section Parameters"));
  final parameter Real n_W(max=n_T) = n_W_tubes + n_W_bs
    "Total # of tubes in both the upper and lower window (including blind and support)";

  parameter Real n_RW "# of tube rows in a window section"
annotation(Dialog(tab="Shell Side Part 1",group="Window Section Parameters"));
  parameter Real n_s=0 "# of pairs of sealing strips"
annotation(Dialog(tab="Shell Side Part 1",group="Window Section Parameters"));

  // Baffle Parameters
  parameter Integer nb(min=2)=2 "# of baffles"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));
  parameter SI.Length H=D_i/5 "Height of baffle cut"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));
  parameter SI.Length D_l=D_i "Baffle Diameter"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));
  parameter SI.Length d_B=d_o "Diameter of holes in baffles"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));
  parameter SI.Length s1 "Tube to tube pitch parallel to baffel edge"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));
  parameter SI.Length s2 "Tube to tube pitch perpindicular to baffel edge"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));
  parameter SI.Length S "Baffle spacing between baffles"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));
  parameter SI.Length S_E_a=S
    "port a baffle spacing between the heat exchanger sheets and adjacent baffles"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));
  parameter SI.Length S_E_b=S
    "port b baffle spacing between the heat exchanger sheets and adjacent baffles"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));

  parameter SI.Length th_B = 0 "Baffle thickness"
annotation(Dialog(tab="Shell Side Part 2",group="Baffle Parameters"));

  // Nozzle and Entry Parameters
  parameter SI.Length d_N_a "Nozzle a diameter"
annotation(Dialog(tab="Shell Side Part 2",group="Entry/Exit Region Parameters"));
  parameter SI.Length d_N_b "Nozzle b diameter"
annotation(Dialog(tab="Shell Side Part 2",group="Entry/Exit Region Parameters"));
  parameter SI.Length length_entryPipe_a=0.001 "Length of entryPipe_a"
annotation(Dialog(tab="Shell Side Part 2",group="Entry/Exit Region Parameters"));
  parameter SI.Length length_entryPipe_b=0.001 "Length of entryPipe_b"
annotation(Dialog(tab="Shell Side Part 2",group="Entry/Exit Region Parameters"));
  parameter SI.Height roughness_entryPipe_a=2.5e-5
    "Avg. height of surface asperities"
    annotation(Dialog(tab="Shell Side Part 2",group="Entry/Exit Region Parameters"));
  parameter SI.Height roughness_entryPipe_b=2.5e-5
    "Avg. height of surface asperities"
    annotation(Dialog(tab="Shell Side Part 2",group="Entry/Exit Region Parameters"));

  // General Tube Parameters
  parameter Real nPasses=1 "Number of tube passes through the shell"
    annotation (Dialog(group="Tube Parameters"));
  parameter SI.Length th_tube=0.001 "Tube wall thickness"
annotation (Dialog(group="Tube Parameters"));
  final parameter SI.Length r_inner = 0.5*d_o-th_tube "Inner radius of tube";
  parameter Integer nRadial(min=3)=3 "Nodes in radial direction in tube wall"
    annotation (Dialog(group="Tube Parameters"));
  parameter SI.Height roughness_tube=2.5e-5
    "Average height of the inner tube surface asperities"
    annotation (Dialog(group="Tube Parameters"));

  parameter SI.Length height_a_tube=0
    "Tube Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(group="Tube Parameters"), Evaluate=true);
  parameter SI.Length dheight_tube=0
    "Tube Height(port_b) - Height(port_a)"
    annotation (Dialog(group="Tube Parameters"), Evaluate=true);

  replaceable model FlowModel_tube =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
    "Tube flow model"
    annotation (choicesAllMatching=true,Dialog(group="Tube Parameters"));
  replaceable model HeatTransfer_tube =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.PartialHeatTransfer_setT
    "Tube side heat transfer coefficient model"
    annotation (choicesAllMatching=true,Dialog(group="Tube Parameters"));

  // Assumptions Tab Parameters
  parameter Boolean allowFlowReversal=system.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics_shell=system.energyDynamics
    "Formulation of energy balances"
    annotation (Dialog(tab="Assumptions", group="Shell Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics_shell=system.massDynamics
    "Formulation of mass balances"
    annotation (Dialog(tab="Assumptions", group="Shell Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics momentumDynamics_shell=system.momentumDynamics
    "Formulation of momentum balances"
    annotation (Dialog(tab="Assumptions", group="Shell Dynamics"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics_tube=system.energyDynamics
    "Formulation of energy balances"
    annotation (Dialog(tab="Assumptions", group="Tube Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics_tube=system.massDynamics
    "Formulation of mass balances"
    annotation (Dialog(tab="Assumptions", group="Tube Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics momentumDynamics_tube=system.momentumDynamics
    "Formulation of momentum balances"
    annotation (Dialog(tab="Assumptions", group="Tube Dynamics"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics_wall=system.energyDynamics
    "Formulation of energy balances"
    annotation (Dialog(tab="Assumptions", group="Tube Wall Dynamics"));

  // Initialization Tab Shell Parameters
  parameter SI.AbsolutePressure p_a_start_shell=system.p_start
    "Pressure at port a" annotation (Dialog(tab="Shell Initialization",group="Start Value: Pressure"));
  parameter SI.AbsolutePressure p_b_start_shell=p_a_start_shell
    "Pressure at port b" annotation (Dialog(tab="Shell Initialization",group="Start Value: Pressure"));
  parameter Medium_shell.AbsolutePressure[nNodes_Total] ps_start_shell=
    linspace(p_a_start_shell,p_b_start_shell,nNodes_Total)
    "Pressures {port_a,...,port_b}"
    annotation(Dialog(tab = "Shell Initialization",group="Start Value: Pressure"));

  parameter Boolean use_Ts_start_shell=true
    "Use T_start if true, otherwise h_start"
    annotation (Dialog(tab="Shell Initialization",group="Start Value: Temperature"));
  parameter Modelica.Media.Interfaces.Types.Temperature T_a_start_shell=system.T_start
    "Temperature at port a" annotation (Dialog(tab="Shell Initialization",group="Start Value: Temperature", enable = use_Ts_start_shell));
  parameter Modelica.Media.Interfaces.Types.Temperature T_b_start_shell=shell.T_a_start
    "Temperature at port b" annotation (Dialog(tab="Shell Initialization",group="Start Value: Temperature", enable = use_Ts_start_shell));
  parameter Medium_shell.Temperature[nNodes_Total] Ts_start_shell=
    if use_Ts_start_shell then
      cat(1,fill(T_a_start_shell,nNodes_entryPipe_a+nNodes_nozzle),linspace(T_a_start_shell,T_b_start_shell,nNodes_intTotal),fill(T_b_start_shell,nNodes_entryPipe_b+nNodes_nozzle))
    else
      {Medium_shell.temperature_phX(
        ps_start_shell[i],
        hs_start_shell[i],
        X_start_shell) for i in 1:nNodes_Total} "Temperatures {a,...,b}"
    annotation(Evaluate=true, Dialog(tab = "Shell Initialization",group="Start Value: Temperature", enable = use_Ts_start_shell));

  parameter Modelica.Media.Interfaces.Types.SpecificEnthalpy h_a_start_shell=
      Medium_shell.specificEnthalpy_pTX(
      shell.p_a_start,
      shell.T_a_start,
      shell.X_start) "Specific enthalpy at port a"
    annotation (Dialog(tab="Shell Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start_shell));
  parameter Modelica.Media.Interfaces.Types.SpecificEnthalpy h_b_start_shell=
      Medium_shell.specificEnthalpy_pTX(
      shell.p_b_start,
      shell.T_b_start,
      shell.X_start) "Specific enthalpy at port b"
    annotation (Dialog(tab="Shell Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start_shell));
  parameter Medium_shell.SpecificEnthalpy[nNodes_Total] hs_start_shell=
    if use_Ts_start_shell then
      {Medium_shell.specificEnthalpy_pTX(
        ps_start_shell[i],
        Ts_start_shell[i],
        X_start_shell) for i in 1:nNodes_Total}
    else
      cat(1,fill(h_a_start_shell,nNodes_entryPipe_a+nNodes_nozzle),linspace(h_a_start_shell,h_b_start_shell,nNodes_intTotal),fill(h_b_start_shell,nNodes_entryPipe_b+nNodes_nozzle))
    "Specific enthalpies {a,...,b}"
    annotation(Evaluate=true, Dialog(tab = "Shell Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start_shell));

  final parameter Modelica.Media.Interfaces.Types.MassFraction X_start_shell[Medium_shell.nX]=
      Medium_shell.X_default "Mass fractions m_i/m"
      annotation (Dialog(tab="Shell Initialization",group="Start Value: Mass Fractions"));
  final parameter Modelica.Media.Interfaces.Types.ExtraProperty C_start_shell[Medium_shell.nC]=
      fill(0, Medium_shell.nC) "Trace substances"
      annotation (Dialog(tab="Shell Initialization",group="Start Value: Trace Substances"));
  parameter SI.MassFlowRate m_flow_start_shell=system.m_flow_start
    "Mass flow rate" annotation (Dialog(tab="Shell Initialization",group="Start Value: Mass Flow Rate"));

  // Initialization Tab Tube Parameters
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure p_a_start_tube=
      system.p_start "Pressure at port a"
    annotation (Dialog(tab = "Tube Initialization",group="Start Value: Absolute Pressure"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure p_b_start_tube=
      tube.p_a_start "Pressure at port b"
    annotation (Dialog(tab = "Tube Initialization",group="Start Value: Absolute Pressure"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure ps_start_tube[tube.nV]=
      if tube.nV > 1 then linspace(
      tube.p_a_start,
      tube.p_b_start,
      tube.nV) else {(tube.p_a_start + tube.p_b_start)/2}
    "Pressures {port_a,...,port_b}"
    annotation (Dialog(tab = "Tube Initialization",group="Start Value: Absolute Pressure"));

  parameter Boolean use_Ts_start_tube=true
    "Use T_start if true, otherwise h_start"
    annotation (Dialog(tab = "Tube Initialization",group="Start Value: Temperature"));

  parameter Modelica.Media.Interfaces.Types.Temperature T_a_start_tube=system.T_start
    "Temperature at port a" annotation (Dialog(tab = "Tube Initialization",group="Start Value: Temperature", enable = use_Ts_start_tube));
  parameter Modelica.Media.Interfaces.Types.Temperature T_b_start_tube=tube.T_a_start
    "Temperature at port b" annotation (Dialog(tab = "Tube Initialization",group="Start Value: Temperature", enable = use_Ts_start_tube));
  parameter Modelica.Media.Interfaces.Types.Temperature Ts_start_tube[tube.nV]=if
      tube.use_Ts_start then if tube.nV > 1 then linspace(
      tube.T_a_start,
      tube.T_b_start,
      tube.nV) else {(tube.T_a_start + tube.T_b_start)/2} else {
      Medium_tube.temperature_phX(
      tube.ps_start[i],
      tube.hs_start[i],
      tube.Xs_start) for i in 1:tube.nV} "Temperatures {port_a,...,port_b}"
    annotation(Evaluate=true, Dialog(tab = "Tube Initialization",group="Start Value: Temperature", enable = use_Ts_start_tube));

  parameter Modelica.Media.Interfaces.Types.SpecificEnthalpy h_a_start_tube=
      Medium_tube.specificEnthalpy_pTX(tube.p_a_start, tube.T_a_start,tube.Xs_start)
    "Specific enthalpy at port a" annotation (Dialog(tab = "Tube Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start_tube));
  parameter Modelica.Media.Interfaces.Types.SpecificEnthalpy h_b_start_tube=
      Medium_tube.specificEnthalpy_pTX(tube.p_b_start, tube.T_b_start,tube.Xs_start)
    "Specific enthalpy at port b" annotation (Dialog(tab = "Tube Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start_tube));
  parameter Modelica.Media.Interfaces.Types.SpecificEnthalpy hs_start_tube[tube.nV]=
      if tube.use_Ts_start then {Medium_tube.specificEnthalpy_pTX(
      tube.ps_start[i],
      tube.Ts_start[i],
      tube.Xs_start) for i in 1:tube.nV} else if tube.nV > 1 then linspace(
      tube.h_a_start,
      tube.h_b_start,
      tube.nV) else {(tube.h_a_start + tube.h_b_start)/2}
    "Specific enthalpies {port_a,...,port_b}"
    annotation (Evaluate=true, Dialog(tab = "Tube Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start_tube));

  parameter Modelica.Media.Interfaces.Types.MassFraction Xs_start_tube[Medium_tube.nX]=
     Medium_tube.X_default "Mass fractions m_i/m"
    annotation (Dialog(tab="Tube Initialization",group="Start Value: Mass Fractions", enable=Medium_tube.nXi > 0));

  parameter Modelica.Media.Interfaces.Types.ExtraProperty Cs_start_tube[Medium_tube.nC]=
     fill(0, Medium_tube.nC) "Trace substances"
    annotation (Dialog(tab="Tube Initialization",group="Start Value: Trace Substances", enable=Medium_tube.nC > 0));

  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    m_flow_a_start_tube=system.m_flow_start "Mass flow rate at port_a"
    annotation (Dialog(tab = "Tube Initialization",group="Start Value: Mass Flow Rate"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    m_flow_b_start_tube=-tube.m_flow_a_start "Mass flow rate at port_b"
    annotation (Dialog(tab = "Tube Initialization",group="Start Value: Mass Flow Rate"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate
    m_flows_start_tube[tube.nV + 1]=linspace(
      tube.m_flow_a_start,
      -tube.m_flow_b_start,
      tube.nV + 1) "Mass flow rates {port_a,...,port_b}"
    annotation (Evaluate=true, Dialog(tab = "Tube Initialization",group="Start Value: Mass Flow Rate"));

  // Advanced Parameters
  parameter Integer nNodes_entryPipe_a(min=1)=1
    "Number of discrete flow volumes in entryPipe_a"
    annotation(Dialog(tab="Advanced"));
  parameter Integer nNodes_entryPipe_b(min=1)=1
    "Number of discrete flow volumes in entryPipe_a"
    annotation(Dialog(tab="Advanced"));
  parameter Integer nNodes_nozzle(min=1)=1
    "Number of discrete flow volumes in each nozzle"
    annotation(Dialog(tab="Advanced"));
  parameter Integer nNodes_endCross(min=1)=1
    "Number of discrete flow volumes in each endCross segment"
    annotation(Dialog(tab="Advanced"));
  parameter Integer nNodes_window(min=1)=1
    "Number of discrete flow volumes in each window segment"
    annotation(Dialog(tab="Advanced"));
  parameter Integer nNodes_centerCross(min=1)=1
    "Number of discrete flow volumes in each centerCross segment"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.ModelStructure modelStructure_shell=Modelica.Fluid.Types.ModelStructure.av_b
    "Determines whether flow or volume models are present at the ports" annotation (Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.ModelStructure modelStructure_tube=Modelica.Fluid.Types.ModelStructure.av_b
    "Set ports as flow or volume models"
    annotation (Dialog(tab="Advanced"));

  final parameter Integer nNodes_intTotal = nNodes_endCross + (nb-1)*(nNodes_window+nNodes_centerCross) + nNodes_window + nNodes_endCross
    "Total number of nodes internal to the shell (i.e., not including nozzles and entry pipes)";
  final parameter Integer nNodes_Total = nNodes_entryPipe_a +  nNodes_nozzle + nNodes_intTotal +  nNodes_nozzle + nNodes_entryPipe_b
    "Total number of nodes in the shell-side (i.e., including nozzles and entry pipes)";

  Fluid.Pipes.GenericPipe              tube(
    use_HeatTransfer=true,
    redeclare package Medium = Medium_tube,
    nParallel=nParallel*shell.n_tubes,
    allowFlowReversal=allowFlowReversal,
    redeclare model FlowModel = FlowModel_tube,
    redeclare model HeatTransfer = HeatTransfer_tube,
    T_a_start=T_a_start_tube,
    T_b_start=T_b_start_tube,
    h_a_start=h_a_start_tube,
    h_b_start=h_b_start_tube,
    m_flow_a_start=m_flow_a_start_tube,
    m_flow_b_start=m_flow_b_start_tube,
    p_a_start=p_a_start_tube,
    p_b_start=p_b_start_tube,
    ps_start=ps_start_tube,
    use_Ts_start=use_Ts_start_tube,
    Ts_start=Ts_start_tube,
    hs_start=hs_start_tube,
    Xs_start=Xs_start_tube,
    Cs_start=Cs_start_tube,
    m_flows_start=m_flows_start_tube,
    Ts_wall(start=tubewall.Ts_start[1, :]),
    energyDynamics=energyDynamics_tube,
    massDynamics=massDynamics_tube,
    momentumDynamics=momentumDynamics_tube,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=2*r_inner,
        length=nPasses*(S_E_a + th_B + S_E_b + (nb - 1)*(S + th_B)),
        roughness=roughness_tube,
        dheight=dheight_tube,
        height_a=height_a_tube,
        nV=shell.nNodes_intTotal))          annotation (Placement(
        transformation(
        extent={{-22,22},{22,-22}},
        rotation=90,
        origin={-60,0})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylinder_FD
    tubewall(
    redeclare package material = Tube_Material,
    r_inner=r_inner,
    nR=nRadial,
    length=sum(tube.lengths),
    nZ=tube.nV,
    r_outer=0.5*d_o,
    redeclare model SolutionMethod_FD =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.SolutionMethods.AxVolCentered_2D,
    rs=linspace(
        tubewall.r_inner,
        tubewall.r_outer,
        tubewall.nR),
    zs=linspace(
        0.5*tubewall.length/tubewall.nZ,
        tubewall.length*(1 - 0.5/tubewall.nZ),
        tubewall.nZ),
    Tref=0.5*(sum(shell.Ts_start[nNodes_entryPipe_a + nNodes_nozzle + 1:
        nNodes_Total - (nNodes_nozzle + nNodes_entryPipe_b)])/nNodes_intTotal
         + sum(tube.Ts_start)/nNodes_intTotal),
    Ts_start=[fill(
        tubewall.Tref,
        tubewall.nR - 1,
        tubewall.nZ); {if counterCurrent then Modelica.Math.Vectors.reverse(
        shell.Ts_start[nNodes_entryPipe_a + nNodes_nozzle + 1:nNodes_Total - (
        nNodes_nozzle + nNodes_entryPipe_b)]) else shell.Ts_start[
        nNodes_entryPipe_a + nNodes_nozzle + 1:nNodes_Total - (nNodes_nozzle +
        nNodes_entryPipe_b)]}],
    energyDynamics=energyDynamics_wall)
    annotation (Placement(transformation(extent={{-22,-22},{22,22}})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_FD(nNodes=tubewall.nR) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={0,-27})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Adiabatic_FD
    adiabatic_FD1(nNodes=tubewall.nR) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={0,27})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces.ScalePower
    scalePower_WallToTube(nParallel=integer(tube.nParallel), nNodes=tube.nV)
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces.ScalePower
    scalePower_WallToShell(
    nParallel=integer(tube.nParallel),
    counterCurrent=counterCurrent,
    nNodes=tube.nV)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

  BaseClasses.STHX_ShellSide_BellDelaware shell(
    redeclare package Medium = Medium_shell,
    toggleStaggered=toggleStaggered,
    n_tubes=n_tubes,
    n_bs=n_bs,
    DB=DB,
    D_BE=D_BE,
    d_o=d_o,
    e1=e1,
    nes=nes,
    D_i=D_i,
    n_MR=n_MR,
    n_MRE=n_MRE,
    n_W_tubes=n_W_tubes,
    n_W_bs=n_W_bs,
    n_RW=n_RW,
    n_s=n_s,
    nb=nb,
    H=H,
    D_l=D_l,
    d_B=d_B,
    s1=s1,
    s2=s2,
    S=S,
    S_E_a=S_E_a,
    S_E_b=S_E_b,
    th_B=th_B,
    d_N_a=d_N_a,
    d_N_b=d_N_b,
    allowFlowReversal=allowFlowReversal,
    p_a_start=p_a_start_shell,
    ps_start=ps_start_shell,
    use_Ts_start=use_Ts_start_shell,
    Ts_start=Ts_start_shell,
    hs_start=hs_start_shell,
    m_flow_start=m_flow_start_shell,
    nNodes_nozzle=nNodes_nozzle,
    nNodes_endCross=nNodes_endCross,
    nNodes_window=nNodes_window,
    nNodes_centerCross=nNodes_centerCross,
    modelStructure= modelStructure_shell,
    isGas=isGas,
    np=np,
    nParallel=nParallel,
    nNodes_entryPipe_a=nNodes_entryPipe_a,
    nNodes_entryPipe_b=nNodes_entryPipe_b,
    p_b_start=p_b_start_shell,
    T_a_start=T_a_start_shell,
    T_b_start=T_b_start_shell,
    h_a_start=h_a_start_shell,
    h_b_start=h_b_start_shell,
    height_a=height_a_shell,
    dheight_entryPipe_a=dheight_entryPipe_a,
    dheight_shell=dheight_shell,
    dheight_entryPipe_b=dheight_entryPipe_b,
    energyDynamics=energyDynamics_shell,
    massDynamics=massDynamics_shell,
    momentumDynamics=momentumDynamics_shell)
                                         annotation (Placement(transformation(
        extent={{31,-32},{-31,32}},
        rotation=90,
        origin={60,-1})));

  // Estimate of U and UA
  SI.TemperatureDifference DT1_output "Temperature Difference 1 of LMTD";
  SI.TemperatureDifference DT2_output "Temperature Difference 2 of LMTD";
  SI.TemperatureDifference LMTD_output "Log Mean Temperature Difference";

  SI.CoefficientOfHeatTransfer alphas_tubeAvg_output
    "Average tube side heat transfer coefficient";

  SI.ThermalResistance R_tube_output "Tube side thermal resistivity";

  SI.ThermalConductance UA_output "U*Area_heatTransfer";
  SI.Area surfaceArea_total_output
    "Total heat transfer area scaled by # of STHX. Based on outer tube diameter, d_o.";
  SI.CoefficientOfHeatTransfer Uoverall_output
    "Overall heat transfer coefficientOverall heat transfer coeffient based on the outside surface area";

  SI.CoefficientOfHeatTransfer[shell.nNodes_intTotal] alphas_tube_output
    "per Node tube side heat transfer coefficient";
  SI.Temperature[shell.nNodes_intTotal] Ts_medium_tube_output
    "Tube side wall temperature";

algorithm
  if counterCurrent then
    DT1_output :=shell.endCross_a.mediums[1].T - tube.mediums[shell.nNodes_intTotal].T;
    DT2_output :=shell.endCross_b.mediums[shell.nNodes_endCross].T - tube.mediums[1].T;
  else
    DT1_output :=shell.endCross_a.mediums[1].T - tube.mediums[1].T;
    DT2_output :=shell.endCross_b.mediums[shell.nNodes_endCross].T - tube.mediums[shell.nNodes_intTotal].T;
  end if;

  LMTD_output :=smooth(1, if abs(DT1_output - DT2_output) <= 1e-4 then 0
                   else (DT1_output - DT2_output)/log(DT1_output/DT2_output));

  alphas_tubeAvg_output :=sum(alphas_tube_output)/shell.nNodes_intTotal;

  R_tube_output :=1/(alphas_tubeAvg_output*pi*sum(tube.dimensions)/nNodes_intTotal*sum(tube.lengths));

  UA_output := 1/(R_tube_output + tubewall.solutionMethod.R_cond_radial + shell.R_conv_output);
  surfaceArea_total_output :=shell.surfaceArea_total_output*nParallel;
  Uoverall_output :=UA_output/surfaceArea_total_output;

equation

  alphas_tube_output = tube.heatTransfer.alphas;
  Ts_medium_tube_output = tube.mediums.T;

  connect(adiabatic_FD1.port, tubewall.heatPorts_top)
    annotation (Line(points={{0,22},{0,13.42}}, color={191,0,0}));
  connect(adiabatic_FD.port, tubewall.heatPorts_bottom)
    annotation (Line(points={{0,-22},{0,-12.98}}, color={191,0,0}));
  connect(tube.port_b, port_b_tube)
    annotation (Line(points={{-60,22},{-60,100}}, color={0,127,255}));
  connect(tube.port_a, port_a_tube) annotation (Line(points={{-60,-22},{-60,-22},
          {-60,-100}}, color={0,127,255}));
  connect(scalePower_WallToTube.heatPorts_a, tubewall.heatPorts_inner)
    annotation (Line(points={{-20,0},{-12.98,0}}, color={127,0,0}));
  connect(scalePower_WallToTube.heatPorts_b, tube.heatPorts) annotation (Line(
        points={{-40,0},{-49,0},{-49,-6.66134e-016}},
                                                   color={127,0,0}));

  connect(tubewall.heatPorts_outer, scalePower_WallToShell.heatPorts_a)
    annotation (Line(points={{12.98,0},{19.49,0},{26,0}}, color={127,0,0}));
  connect(scalePower_WallToShell.heatPorts_b, shell.heatPorts_a)
    annotation (Line(points={{46,0},{65.12,0},{65.12,-1}}, color={127,0,0}));
  connect(port_b_shell, shell.port_b) annotation (Line(points={{60,-100},{60,
          -100},{60,-44},{60,-32}},             color={0,127,255}));
  connect(port_a_shell, shell.port_a) annotation (Line(points={{60,100},{60,30}},
                            color={0,127,255}));
  annotation (defaultComponentName="STHX",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{19,20},{19,-6},{3,2},{-9,2},{-9,-20},{-19,-20},{-19,12},{3,12},
              {19,20}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={48,-70},
          rotation=270),
        Polygon(
          points={{-19,20},{-19,-6},{-3,2},{9,2},{9,-20},{19,-20},{19,12},{-3,12},
              {-19,20}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={48,70},
          rotation=-90),
        Rectangle(
          extent={{-80,42},{80,-42}},
          lineColor={0,0,0},
          fillColor={124,186,186},
          fillPattern=FillPattern.VerticalCylinder,
          origin={0,0},
          rotation=-90),
        Rectangle(
          extent={{-70,1},{70,-1}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          origin={28,0},
          rotation=-90),
        Rectangle(
          extent={{-70,1},{70,-1}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          origin={14,0},
          rotation=-90),
        Rectangle(
          extent={{-70,1},{70,-1}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          origin={2,0},
          rotation=-90),
        Rectangle(
          extent={{-70,1},{70,-1}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          origin={-14,0},
          rotation=-90),
        Rectangle(
          extent={{-70,1},{70,-1}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          origin={-32,0},
          rotation=-90),
        Rectangle(
          extent={{-5,40},{5,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          origin={0,75},
          rotation=-90),
        Rectangle(
          extent={{-5,40},{5,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          origin={0,-75},
          rotation=-90),
        Rectangle(
          extent={{-5,30},{5,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          origin={10,-35},
          rotation=-90),
        Rectangle(
          extent={{-5,30},{5,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          origin={-10,0},
          rotation=-90),
        Rectangle(
          extent={{-80,-1},{80,1}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          origin={-41,0},
          rotation=-90),
        Rectangle(
          extent={{-4.5,30},{4.5,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          origin={10.5,35},
          rotation=-90),
        Rectangle(
          extent={{-80,1},{80,-1}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          origin={41,0},
          rotation=-90)}),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">The Bell-Delaware shell and tube heat exchanger model is based on the method presented by Edward S. Gaddis and Volker Gnielinski in the VDI Heat Atlas 2nd Edition (2010). This method is based off of the extensive work performed at the University of Delaware. The Bell-Delaware method consists of breaking down the pressure drop (dP) model into various sections of the heat exchanger (see Figure 1) while the heat transfer correlation model is more of a lumped parameter type approach. The traditional Bell-Delaware method employs diagrams while the Gaddis Gnielinski version has translated the information to equations. The tube side of the shell and tube heat exchanger is independent of the Bell-Delaware method and thus can be exchanged with any appropriate pipe model, dP model, and/or heat transfer model.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TRANSFORM/../Resources/Images/Fluid/Dissipation/HeatExchangers/BellDelawareShell/BellDelaware_dPlayout.PNG\"/></span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 1: Pressure drop model breakdown into repeated sections</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Notes: </span></b></p>
<ol>
<li><span style=\"font-family: MS Shell Dlg 2;\">The pipe models for nozzle_a/b do NOT account for long lengths where dP_friction may be important. For this reason a nozzle_pipe has been added to nozzle_a/b which enables long entrance regions to have frictional dP and static head contributions to be accounted.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Variables noted in the literature are the same as in this model. They have been kept identical as possible as to facililate reference to the source material to improve error catching, ability to reference the source material, and interpretation of the results.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Figures identifying each of the variables is given below. If additional information is needed, the source material provides two excellent examples.</span></li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Application:</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This method was developed for use with single phase (shell side - oil/water), cylindrical, single baffle segmented, shell and tube heat exchangers. The range of reported validity (+/- 35&percnt;) for the pressure drop and heat transfer correlation models are as follows:</span></p>
<p><u><i><span style=\"font-family: MS Shell Dlg 2;\">Pressure Drop Model (pgs. 1092 - 1105):</span></i></u></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1 &LT; Re &LT; 5*10^4</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">3 &LT;= Pr &LT;= 10^3</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">0.2 &LT;= S/D_i &LT;= 1.0</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">0.15 &LT;= H/D_i &LT;= 0.4</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">R_B &LT;= 0.5</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1.2 &LT;= t/d_o &LT;= 2.0</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">D_i/d_o &GT; 10</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f_L &GT;= 0.4</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f_B &GT;= 0.4</span></p>
<p><u><i><span style=\"font-family: MS Shell Dlg 2;\">Heat Transfer Model (pgs. 731 - 741)</span></i></u></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">10 &LT; Re_psil &LT; 10^5</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">3 &LT; Pr &LT; 10^3</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">0.2 &LT;= S/D_i &LT;= 1</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">R_G &LT;= 0.8</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">R_L &LT;= 0.8</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">R_B &LT;= 0.5</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1.2 &LT;= t/d_o &LT;= 2.2</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f_w &GT;= 0.3</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TRANSFORM/../Resources/Images/Fluid/Dissipation/HeatExchangers/BellDelawareShell/BellDelaware_nMR.PNG\"/></span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 2: Definition of S_1, S_2, d_o, and n_MR. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Note: In these examples -&GT;</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">n_tubes = a) 69, b) 73, and c) 73. (n_bs assumed = 0)</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">n_MRE = a) 7, b) 9, and c) 13.</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">n_W_tubes = a) 12, b) 7, and c) 12. (n_W_bs assumed = 0)</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">n_RW = a) 2, b) 2, and c) 2.</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"></p><p></span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"></p><p><img src=\"modelica://TRANSFORM/../Resources/Images/Fluid/Dissipation/HeatExchangers/BellDelawareShell/BellDelaware_e.PNG\"/></span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 3: Definition of e and e_1 ( a, b, and L_E are internall calculated). </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">S_1, S_2, and d_o are identical to what is presented in Figure 2. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Note: nes for these examples are a) 8, b) 8, c) 10.</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TRANSFORM/../Resources/Images/Fluid/Dissipation/HeatExchangers/BellDelawareShell/BellDelaware_S_E.PNG\"/></span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 4: Definition of d_N, S_E, and S. Specific values are just examples. In this example n_B = 8 and nPasses = 2. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Note: S_E_a/d_N_a is tubesheet to baffle spacing/nozzle diameter on the port_a side. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">S_E_b/d_N_b is tubesheet to baffle spacing/nozzle diameter on the port_b side. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">height_ab_shell is evenly distributed between windows as a simple means of capturing static pressure. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">In this example height_ab_shell = D_i while nozzle elevation changes can be assigned with height_ab_nozzle_a/b.</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TRANSFORM/../Resources/Images/Fluid/Dissipation/HeatExchangers/BellDelawareShell/BellDelaware_Ds.PNG\"/></span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 5: Definition of H, D_i, D_l, and D_B. Specific values are just examples.</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Note: D_BE is not shown as it is often equal to D_B for most heat exchanger layouts.</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">DB is the diameter of a circle, which touches the outermost tubes in the space between the upper and lower edges of adjacent baffles</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">D_BE is the diameter of a circle, which touches the outermost tubes of all tubes in the shell of the heat exchanger</span></b></p>
</html>"));
end STHX_BellDelaware;
