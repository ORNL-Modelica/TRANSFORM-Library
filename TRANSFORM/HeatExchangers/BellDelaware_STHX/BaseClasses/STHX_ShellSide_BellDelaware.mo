within TRANSFORM.HeatExchangers.BellDelaware_STHX.BaseClasses;
model STHX_ShellSide_BellDelaware
  import Modelica.Constants.pi;
  import Modelica.Constants.inf;
  extends Modelica.Fluid.Interfaces.PartialTwoPort(final showDesignFlowDirection=true);
  // Additional Model Parameters
  parameter Real nParallel = 1 "# of identical parallel shell-sides";
  Modelica.Fluid.Interfaces.HeatPorts_a[nNodes_intTotal] heatPorts_a annotation (Placement(
        transformation(extent={{-15,53},{15,81}}), iconTransformation(extent={{-19,-20},
            {19,-12}})));
  parameter Boolean isGas=false "true if Medium is a gas";
  parameter Real np=0
    "Gas specific exponential correction factor (e.g., air = 0; N2 = 0.12)";
  parameter SI.Length height_a=0
    "Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(group="Static head"), Evaluate=true);
  parameter SI.Length dheight_entryPipe_a=0
    "Height(shell inlet nozzle midpoint) - Height(port_a)"
    annotation (Dialog(group="Static head"), Evaluate=true);
  parameter SI.Length dheight_shell=0
    "Height(shell outlet nozzle midpoint) - Height(shell inlet nozzle midpoint)"
    annotation (Dialog(group="Static head"), Evaluate=true);
  parameter SI.Length dheight_entryPipe_b=0
    "Height(port_b) - Height(shell outlet nozzle midpoint)"
    annotation (Dialog(group="Static head"), Evaluate=true);
  // General Shell Parameters
  parameter Boolean toggleStaggered = true
    "true = staggered grid type; false = in-line"
 annotation(Dialog(tab="Shell Side Part 1",group="General Shell Parameters"));
  parameter Real n_tubes
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
  // Nozzle, Entry, and Elevation Parameters
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
  // Assumptions Tab Parameters
  parameter Boolean allowFlowReversal=system.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=system.energyDynamics
    "Formulation of energy balances"
    annotation (Dialog(tab="Assumptions", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=system.massDynamics
    "Formulation of mass balances"
    annotation (Dialog(tab="Assumptions", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics momentumDynamics=system.momentumDynamics
    "Formulation of momentum balances"
    annotation (Dialog(tab="Assumptions", group="Dynamics"));
  // Initialization Tab Parameters
  parameter Medium.AbsolutePressure p_a_start=system.p_start
      "Pressure at port a"
    annotation(Dialog(tab = "Initialization",group="Start Value: Absolute Pressure"));
  parameter Medium.AbsolutePressure p_b_start=p_a_start
      "Pressure at port b"
    annotation(Dialog(tab = "Initialization",group="Start Value: Absolute Pressure"));
  parameter Medium.AbsolutePressure[nNodes_Total] ps_start=
    linspace(p_a_start,p_b_start,nNodes_Total)
    "Pressures {port_a,...,port_b}"
    annotation(Dialog(tab = "Initialization",group="Start Value: Absolute Pressure"));
  parameter Boolean use_Ts_start=true "Use T_start if true, otherwise h_start"
     annotation(Evaluate=true, Dialog(tab = "Initialization",group="Start Value: Temperature"));
  parameter Medium.Temperature T_a_start=system.T_start
      "Temperature at port a"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature", enable = use_Ts_start));
  parameter Medium.Temperature T_b_start=T_a_start
      "Temperature at port b"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature", enable = use_Ts_start));
  parameter Medium.Temperature[nNodes_Total] Ts_start=
    if use_Ts_start then
      cat(1,fill(T_a_start,nNodes_entryPipe_a+nNodes_nozzle),linspace(T_a_start,T_b_start,nNodes_intTotal),fill(T_b_start,nNodes_entryPipe_b+nNodes_nozzle))
    else
      {Medium.temperature_phX(
        ps_start[i],
        hs_start[i],
        X_start) for i in 1:nNodes_Total} "Temperatures {a,...,b}"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature", enable = use_Ts_start));
  parameter Medium.SpecificEnthalpy h_a_start=Medium.specificEnthalpy_pTX(p_a_start,T_a_start,X_start)
      "Specific enthalpy at port a"
    annotation(Dialog(tab = "Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start));
  parameter Medium.SpecificEnthalpy h_b_start=Medium.specificEnthalpy_pTX(p_b_start,T_b_start,X_start)
      "Specific enthalpy at port b"
    annotation(Dialog(tab = "Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start));
  parameter Medium.SpecificEnthalpy[nNodes_Total] hs_start=
    if use_Ts_start then
      {Medium.specificEnthalpy_pTX(
        ps_start[i],
        Ts_start[i],
        X_start) for i in 1:nNodes_Total}
    else
      cat(1,fill(h_a_start,nNodes_entryPipe_a+nNodes_nozzle),linspace(h_a_start,h_b_start,nNodes_intTotal),fill(h_b_start,nNodes_entryPipe_b+nNodes_nozzle))
    "Specific enthalpies {a,...,b}"
    annotation(Dialog(tab = "Initialization",group="Start Value: Specific Enthalpy", enable = not use_Ts_start));
  final parameter Modelica.Media.Interfaces.Types.MassFraction X_start[Medium.nX]=
      Medium.X_default "Mass fractions m_i/m"
    annotation (Dialog(tab="Initialization",group="Start Value: Mass Fractions", enable=Medium.nXi > 0));
  final parameter Modelica.Media.Interfaces.Types.ExtraProperty C_start[Medium.nC]=
      fill(0, Medium.nC) "Trace substances"
    annotation (Dialog(tab="Initialization",group="Start Value: Trace Substances", enable=Medium.nC > 0));
  parameter SI.MassFlowRate m_flow_start=system.m_flow_start
    "Mass flow rate"
     annotation(Evaluate=true, Dialog(tab = "Initialization",group="Start Value: Mass Flow Rate"));
  // Advanced Tab Parameters
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
  parameter Modelica.Fluid.Types.ModelStructure modelStructure=Modelica.Fluid.Types.ModelStructure.av_b
    "Determines whether flow or volume models are present at the ports" annotation (Dialog(tab="Advanced"));
  final parameter Integer nNodes_intTotal = nNodes_endCross + (nb-1)*(nNodes_window+nNodes_centerCross) + nNodes_window + nNodes_endCross
    "Total number of nodes internal to the shell (i.e., not including nozzles and entry pipes)";
  final parameter Integer nNodes_Total = nNodes_entryPipe_a + nNodes_nozzle + nNodes_intTotal + nNodes_nozzle + nNodes_entryPipe_b
    "Total number of nodes in the shell-side (i.e., including nozzles and entry pipes)";
  // Static Head Calculations
  final parameter SI.Length dheight_windows = dheight_shell/nb;
  final parameter SI.Length[nb+1] heights_shell = {if i == 1 then entryPipe_a.height_b else heights_shell[i-1]+dheight_windows for i in 1:nb+1};
  final parameter SI.Length[nb] heights_shell_a=heights_shell[1:nb];
  final parameter SI.Length[nb] heights_shell_b=heights_shell[2:nb+1];
  // Characteristic parameters from Shell Flow Model Parameters
  final parameter Real gamma = 2*Modelica.Math.acos(1 - 2*H/D_l)*180/pi;
  final parameter Real a = s1/d_o;
  final parameter Real b = s2/d_o;
  final parameter Real c = ((a/2)^2 + b^2)^(0.5);
  final parameter SI.Length e = (if toggleStaggered then
                    (if b >= 0.5*(2*a+1)^(0.5) then (a - 1)*d_o else (c - 1)*d_o)
                 else (a - 1)*d_o);
  final parameter SI.Length L_E = 2*e1 + e*nes;
  final parameter SI.Area A_Ecenter = S*L_E
    "Approximate flow area for centerCross region";
  final parameter SI.Length U_Ecenter = 2*pi*D_i*(360-gamma)/360 + 2*S*(nes+1) +2*L_E
    "Approximate wetted perimeter for centerCross region";
  final parameter SI.Area A_Eend_a = S_E_a*L_E
    "Approximate flow area for endCross region";
  final parameter SI.Length U_Eend_a = 2*pi*D_i*(360-gamma)/360 + 2*S_E_a*(nes+1) +2*L_E
    "Approximate wetted perimeter for endCross region";
  final parameter SI.Area A_Eend_b = S_E_b*L_E
    "Approximate flow area for endCross region";
  final parameter SI.Length U_Eend_b = 2*pi*D_i*(360-gamma)/360 + 2*S_E_b*(nes+1) +2*L_E
    "Approximate wetted perimeter for endCross region";
  final parameter SI.Area A_WT = pi/4*D_i^2*gamma/360 - (D_l-2*H)*D_l/4*Modelica.Math.sin(gamma/2*pi/180);
  final parameter SI.Area A_T = pi/4*d_o^2*n_W/2;
  final parameter SI.Area A_W = A_WT-A_T
    "Approximate flow area for window region";
  final parameter SI.Length U_W = pi*D_i*gamma/360+pi*d_o*n_W/2
    "Approximate wetted perimeter for window region";
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface entryPipe_a(
    nParallel=nParallel,
    length=length_entryPipe_a,
    diameter=d_N_a,
    roughness=roughness_entryPipe_a,
    redeclare package Medium = Medium,
    p_a_start=ps_start[1],
    p_b_start=ps_start[nNodes_entryPipe_a],
    modelStructure=if modelStructure == Modelica.Fluid.Types.ModelStructure.a_v_b
         then Modelica.Fluid.Types.ModelStructure.a_vb elseif
        modelStructure == Modelica.Fluid.Types.ModelStructure.a_vb then
        Modelica.Fluid.Types.ModelStructure.a_vb else Modelica.Fluid.Types.ModelStructure.av_b,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    nV=nNodes_entryPipe_a,
    ps_start=ps_start[1:nNodes_entryPipe_a],
    T_a_start=Ts_start[1],
    T_b_start=Ts_start[nNodes_entryPipe_a],
    Ts_start=Ts_start[1:nNodes_entryPipe_a],
    m_flow_a_start=m_flow_start,
    height_a=height_a,
    dheight=dheight_entryPipe_a)
    "This pipe serves to capture the pressure drop not captued by the nozzle dP (i.e., length and static dP), if any, for nozzle_a"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-70,50})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface nozzle_a(
    redeclare package Medium = Medium,
    redeclare model FlowModel = FlowModels.ShellNozzleFlow (
        d_o=d_o,
        n_T=n_T,
        D_i=D_i,
        D_BE=D_BE,
        d_N=d_N_a),
    modelStructure=modelStructure,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    diameter=d_N_a,
    use_HeatTransfer=false,
    nParallel=nParallel,
    length=0.01,
    nV=nNodes_nozzle,
    p_a_start=ps_start[nNodes_entryPipe_a + 1],
    p_b_start=ps_start[nNodes_entryPipe_a + nNodes_nozzle],
    ps_start=ps_start[nNodes_entryPipe_a + 1:nNodes_entryPipe_a +
        nNodes_nozzle],
    T_a_start=Ts_start[nNodes_entryPipe_a + 1],
    T_b_start=Ts_start[nNodes_entryPipe_a + nNodes_nozzle],
    Ts_start=Ts_start[nNodes_entryPipe_a + 1:nNodes_entryPipe_a +
        nNodes_nozzle],
    m_flow_a_start=m_flow_start,
    height_a=entryPipe_a.height_b) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-70,20})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface endCross_a(
    redeclare package Medium = Medium,
    modelStructure=if modelStructure == Modelica.Fluid.Types.ModelStructure.a_v_b
         then Modelica.Fluid.Types.ModelStructure.av_vb elseif
        modelStructure == Modelica.Fluid.Types.ModelStructure.av_vb then
        Modelica.Fluid.Types.ModelStructure.a_v_b else modelStructure,
    nParallel=nParallel,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    length=(D_i - H),
    isCircular=false,
    crossArea=A_Eend_a,
    perimeter=U_Eend_a,
    nV=nNodes_endCross,
    redeclare model FlowModel = FlowModels.ShellEndCrossFlow (
        d_o=d_o,
        D_i=D_i,
        DB=DB,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_MR=n_MR,
        n_MRE=n_MRE,
        n_s=n_s,
        toggleStaggered=toggleStaggered,
        S_E=S_E_a),
    redeclare model HeatTransfer = HeatTransfer.BellDelaware (
        toggleStaggered=toggleStaggered,
        d_B=d_B,
        d_o=d_o,
        D_i=D_i,
        D_l=D_l,
        DB=DB,
        H=H,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_W=n_W,
        n_T=n_T,
        n_MR=n_MR,
        n_s=n_s,
        toggleEndChannel=true,
        S_E=S_E_a,
        isGas=isGas,
        np=np),
    use_HeatTransfer=true,
    surfaceAreas=fill((n_tubes - 0.5*n_W_tubes)*pi*d_o*(S_E_a + 0.5*th_B)
        /nNodes_endCross, nNodes_endCross),
    p_a_start=ps_start[nNodes_entryPipe_a + nNodes_nozzle + 1],
    p_b_start=ps_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross],
    ps_start=ps_start[nNodes_entryPipe_a + nNodes_nozzle + 1:
        nNodes_entryPipe_a + nNodes_nozzle + nNodes_endCross],
    use_Ts_start=use_Ts_start,
    T_a_start=Ts_start[nNodes_entryPipe_a + nNodes_nozzle + 1],
    T_b_start=Ts_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross],
    Ts_start=Ts_start[nNodes_entryPipe_a + nNodes_nozzle + 1:
        nNodes_entryPipe_a + nNodes_nozzle + nNodes_endCross],
    h_a_start=hs_start[nNodes_entryPipe_a + nNodes_nozzle + 1],
    h_b_start=hs_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross],
    hs_start=hs_start[nNodes_entryPipe_a + nNodes_nozzle + 1:
        nNodes_entryPipe_a + nNodes_nozzle + nNodes_endCross],
    m_flow_a_start=m_flow_start,
    height_a=nozzle_a.height_b) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-70,-20})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface[nb - 1] window(
    redeclare each package Medium = Medium,
    each modelStructure=modelStructure,
    each nParallel=nParallel,
    length={if i == 1 then (S_E_a + S + th_B)/nNodes_window else (2*S +
        th_B)/nNodes_window for i in 1:nb - 1},
    each isCircular=false,
    each crossArea=A_W,
    each perimeter=U_W,
    each allowFlowReversal=allowFlowReversal,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each momentumDynamics=momentumDynamics,
    each nV=nNodes_window,
    redeclare each model FlowModel = FlowModels.ShellWindowFlow (
        toggleStaggered=toggleStaggered,
        d_B=d_B,
        d_o=d_o,
        D_i=D_i,
        D_l=D_l,
        H=H,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_RW=n_RW,
        n_W=n_W,
        n_T=n_T),
    redeclare each model HeatTransfer = HeatTransfer.BellDelaware (
        toggleStaggered=toggleStaggered,
        d_B=d_B,
        d_o=d_o,
        D_i=D_i,
        D_l=D_l,
        DB=DB,
        H=H,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_W=n_W,
        n_T=n_T,
        n_MR=n_MR,
        n_s=n_s,
        S_E=(S_E_a + S_E_b)/2,
        isGas=isGas,
        np=np),
    each use_HeatTransfer=true,
    surfaceAreas={0.5*n_W_tubes*pi*d_o*window[i].lengths for i in 1:nb -
        1},
    p_a_start={ps_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + 1 + (i - 1)*(nNodes_window + nNodes_centerCross)]
        for i in 1:nb - 1},
    p_b_start={ps_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + (i - 1)*(nNodes_window +
        nNodes_centerCross)] for i in 1:nb - 1},
    ps_start={ps_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + 1 + (i - 1)*(nNodes_window + nNodes_centerCross)
        :nNodes_entryPipe_a + nNodes_nozzle + nNodes_endCross +
        nNodes_window + (i - 1)*(nNodes_window + nNodes_centerCross)]
        for i in 1:nb - 1},
    each use_Ts_start=use_Ts_start,
    T_a_start={Ts_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + 1 + (i - 1)*(nNodes_window + nNodes_centerCross)]
        for i in 1:nb - 1},
    T_b_start={Ts_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + (i - 1)*(nNodes_window +
        nNodes_centerCross)] for i in 1:nb - 1},
    Ts_start={Ts_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + 1 + (i - 1)*(nNodes_window + nNodes_centerCross)
        :nNodes_entryPipe_a + nNodes_nozzle + nNodes_endCross +
        nNodes_window + (i - 1)*(nNodes_window + nNodes_centerCross)]
        for i in 1:nb - 1},
    h_a_start={hs_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + 1 + (i - 1)*(nNodes_window + nNodes_centerCross)]
        for i in 1:nb - 1},
    h_b_start={hs_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + (i - 1)*(nNodes_window +
        nNodes_centerCross)] for i in 1:nb - 1},
    hs_start={hs_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + 1 + (i - 1)*(nNodes_window + nNodes_centerCross)
        :nNodes_entryPipe_a + nNodes_nozzle + nNodes_endCross +
        nNodes_window + (i - 1)*(nNodes_window + nNodes_centerCross)]
        for i in 1:nb - 1},
    each m_flow_a_start=m_flow_start,
    height_a=heights_shell_a,
    each dheight=dheight_windows) if (nb > 1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-60})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface[nb - 1] centerCross(
    redeclare each package Medium = Medium,
    each modelStructure=if modelStructure == Modelica.Fluid.Types.ModelStructure.a_v_b
         then Modelica.Fluid.Types.ModelStructure.av_vb elseif
        modelStructure == Modelica.Fluid.Types.ModelStructure.av_vb then
        Modelica.Fluid.Types.ModelStructure.a_v_b else modelStructure,
    each nParallel=nParallel,
    each length=(D_i - 2*H),
    each isCircular=false,
    each crossArea=A_Ecenter,
    each perimeter=U_Ecenter,
    each allowFlowReversal=allowFlowReversal,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each momentumDynamics=momentumDynamics,
    each nV=nNodes_centerCross,
    redeclare each model FlowModel = FlowModels.ShellCentralCrossFlow (
        toggleStaggered=toggleStaggered,
        d_B=d_B,
        d_o=d_o,
        D_i=D_i,
        D_l=D_l,
        DB=DB,
        H=H,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_W=n_W,
        n_T=n_T,
        n_MR=n_MR,
        n_s=n_s),
    redeclare each model HeatTransfer = HeatTransfer.BellDelaware (
        toggleStaggered=toggleStaggered,
        d_B=d_B,
        d_o=d_o,
        D_i=D_i,
        D_l=D_l,
        DB=DB,
        H=H,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_W=n_W,
        n_T=n_T,
        n_MR=n_MR,
        n_s=n_s,
        S_E=(S_E_a + S_E_b)/2,
        isGas=isGas,
        np=np),
    each use_HeatTransfer=true,
    each surfaceAreas=fill((n_tubes - n_W_tubes)*pi*d_o*(S + th_B)/
        nNodes_centerCross, nNodes_centerCross),
    p_a_start={ps_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + 1 + (i - 1)*(nNodes_window +
        nNodes_centerCross)] for i in 1:nb - 1},
    p_b_start={ps_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + nNodes_centerCross + (i - 1)*(
        nNodes_window + nNodes_centerCross)] for i in 1:nb - 1},
    ps_start={ps_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + 1 + (i - 1)*(nNodes_window +
        nNodes_centerCross):nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + nNodes_centerCross + (i - 1)*(
        nNodes_window + nNodes_centerCross)] for i in 1:nb - 1},
    each use_Ts_start=use_Ts_start,
    T_a_start={Ts_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + 1 + (i - 1)*(nNodes_window +
        nNodes_centerCross)] for i in 1:nb - 1},
    T_b_start={Ts_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + nNodes_centerCross + (i - 1)*(
        nNodes_window + nNodes_centerCross)] for i in 1:nb - 1},
    Ts_start={Ts_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + 1 + (i - 1)*(nNodes_window +
        nNodes_centerCross):nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + nNodes_centerCross + (i - 1)*(
        nNodes_window + nNodes_centerCross)] for i in 1:nb - 1},
    h_a_start={hs_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + 1 + (i - 1)*(nNodes_window +
        nNodes_centerCross)] for i in 1:nb - 1},
    h_b_start={hs_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + nNodes_centerCross + (i - 1)*(
        nNodes_window + nNodes_centerCross)] for i in 1:nb - 1},
    hs_start={hs_start[nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + 1 + (i - 1)*(nNodes_window +
        nNodes_centerCross):nNodes_entryPipe_a + nNodes_nozzle +
        nNodes_endCross + nNodes_window + nNodes_centerCross + (i - 1)*(
        nNodes_window + nNodes_centerCross)] for i in 1:nb - 1},
    each m_flow_a_start=m_flow_start,
    height_a=heights_shell_b) if (nb > 1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-20})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface window_b(
    redeclare package Medium = Medium,
    modelStructure=modelStructure,
    nParallel=nParallel,
    length=if nb == 1 then (S_E_a + S_E_b + th_B) else (S + S_E_b + th_B),
    isCircular=false,
    crossArea=A_W,
    perimeter=U_W,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    nV=nNodes_window,
    redeclare model FlowModel = FlowModels.ShellWindowFlow (
        toggleStaggered=toggleStaggered,
        d_B=d_B,
        d_o=d_o,
        D_i=D_i,
        D_l=D_l,
        H=H,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_RW=n_RW,
        n_W=n_W,
        n_T=n_T),
    redeclare each model HeatTransfer = HeatTransfer.BellDelaware (
        toggleStaggered=toggleStaggered,
        d_B=d_B,
        d_o=d_o,
        D_i=D_i,
        D_l=D_l,
        DB=DB,
        H=H,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_W=n_W,
        n_T=n_T,
        n_MR=n_MR,
        n_s=n_s,
        S_E=(S_E_a + S_E_b)/2,
        isGas=isGas,
        np=np),
    use_HeatTransfer=true,
    surfaceAreas=0.5*n_W_tubes*pi*d_o*window_b.lengths,
    p_a_start=ps_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross + nNodes_window)],
    p_b_start=ps_start[nNodes_Total - (nNodes_entryPipe_b + nNodes_nozzle
         + nNodes_endCross)],
    ps_start=ps_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross + nNodes_window):nNodes_Total - (
        nNodes_entryPipe_b + nNodes_nozzle + nNodes_endCross)],
    use_Ts_start=use_Ts_start,
    T_a_start=Ts_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross + nNodes_window)],
    T_b_start=Ts_start[nNodes_Total - (nNodes_entryPipe_b + nNodes_nozzle
         + nNodes_endCross)],
    Ts_start=Ts_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross + nNodes_window):nNodes_Total - (
        nNodes_entryPipe_b + nNodes_nozzle + nNodes_endCross)],
    h_a_start=hs_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross + nNodes_window)],
    h_b_start=hs_start[nNodes_Total - (nNodes_entryPipe_b + nNodes_nozzle
         + nNodes_endCross)],
    hs_start=hs_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross + nNodes_window):nNodes_Total - (
        nNodes_entryPipe_b + nNodes_nozzle + nNodes_endCross)],
    height_a=heights_shell_a[nb],
    dheight=dheight_windows) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-60})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface endCross_b(
    redeclare package Medium = Medium,
    modelStructure=if modelStructure == Modelica.Fluid.Types.ModelStructure.a_v_b
         then Modelica.Fluid.Types.ModelStructure.av_vb elseif
        modelStructure == Modelica.Fluid.Types.ModelStructure.av_vb then
        Modelica.Fluid.Types.ModelStructure.a_v_b else modelStructure,
    length=(D_i - H),
    isCircular=false,
    crossArea=A_Eend_b,
    perimeter=U_Eend_b,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    nV=nNodes_endCross,
    redeclare model FlowModel = FlowModels.ShellEndCrossFlow (
        d_o=d_o,
        D_i=D_i,
        DB=DB,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_MR=n_MR,
        n_MRE=n_MRE,
        n_s=n_s,
        toggleStaggered=toggleStaggered,
        S_E=S_E_b),
    redeclare model HeatTransfer = HeatTransfer.BellDelaware (
        toggleStaggered=toggleStaggered,
        d_B=d_B,
        d_o=d_o,
        D_i=D_i,
        D_l=D_l,
        DB=DB,
        H=H,
        s1=s1,
        s2=s2,
        S=S,
        e1=e1,
        nes=nes,
        n_W=n_W,
        n_T=n_T,
        n_MR=n_MR,
        n_s=n_s,
        toggleEndChannel=true,
        S_E=S_E_b,
        isGas=isGas,
        np=np),
    nParallel=nParallel,
    use_HeatTransfer=true,
    surfaceAreas=fill((n_tubes - 0.5*n_W_tubes)*pi*d_o*(S_E_b + 0.5*th_B)
        /nNodes_endCross, nNodes_endCross),
    p_a_start=ps_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross)],
    p_b_start=ps_start[nNodes_Total - (nNodes_entryPipe_b + nNodes_nozzle)],
    ps_start=ps_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross):nNodes_Total - (
        nNodes_entryPipe_b + nNodes_nozzle)],
    use_Ts_start=use_Ts_start,
    T_a_start=Ts_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross)],
    T_b_start=Ts_start[nNodes_Total - (nNodes_entryPipe_b + nNodes_nozzle)],
    Ts_start=Ts_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross):nNodes_Total - (
        nNodes_entryPipe_b + nNodes_nozzle)],
    h_a_start=hs_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross)],
    h_b_start=hs_start[nNodes_Total - (nNodes_entryPipe_b + nNodes_nozzle)],
    hs_start=hs_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle + nNodes_endCross):nNodes_Total - (
        nNodes_entryPipe_b + nNodes_nozzle)],
    m_flow_a_start=m_flow_start,
    height_a=window_b.height_b) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={70,-20})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface nozzle_b(
    redeclare package Medium = Medium,
    redeclare model FlowModel = FlowModels.ShellNozzleFlow (
        d_o=d_o,
        n_T=n_T,
        D_i=D_i,
        D_BE=D_BE,
        d_N=d_N_b),
    modelStructure=if modelStructure == Modelica.Fluid.Types.ModelStructure.a_vb
         then Modelica.Fluid.Types.ModelStructure.av_b elseif
        modelStructure == Modelica.Fluid.Types.ModelStructure.av_b then
        Modelica.Fluid.Types.ModelStructure.a_vb else modelStructure,
    p_a_start=ps_start[nNodes_Total - nNodes_entryPipe_b],
    p_b_start=ps_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle)],
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    diameter=d_N_b,
    use_HeatTransfer=false,
    nParallel=nParallel,
    length=0.01,
    nV=nNodes_nozzle,
    ps_start=ps_start[nNodes_Total - nNodes_entryPipe_b:nNodes_Total + 1
         - (nNodes_entryPipe_b + nNodes_nozzle)],
    T_a_start=Ts_start[nNodes_Total - nNodes_entryPipe_b],
    T_b_start=Ts_start[nNodes_Total + 1 - (nNodes_entryPipe_b +
        nNodes_nozzle)],
    Ts_start=Ts_start[nNodes_Total - nNodes_entryPipe_b:nNodes_Total + 1
         - (nNodes_entryPipe_b + nNodes_nozzle)],
    height_a=endCross_b.height_a,
    m_flow_a_start=-m_flow_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={70,20})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface entryPipe_b(
    nParallel=nParallel,
    length=length_entryPipe_b,
    diameter=d_N_b,
    roughness=roughness_entryPipe_b,
    redeclare package Medium = Medium,
    p_a_start=ps_start[nNodes_Total + 1 - nNodes_entryPipe_b],
    p_b_start=ps_start[nNodes_Total],
    modelStructure=if modelStructure == Modelica.Fluid.Types.ModelStructure.a_v_b
         then Modelica.Fluid.Types.ModelStructure.av_b elseif
        modelStructure == Modelica.Fluid.Types.ModelStructure.av_b then
        Modelica.Fluid.Types.ModelStructure.av_b else Modelica.Fluid.Types.ModelStructure.a_vb,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    momentumDynamics=momentumDynamics,
    nV=nNodes_entryPipe_b,
    ps_start=ps_start[nNodes_Total + 1 - nNodes_entryPipe_b:nNodes_Total],
    T_a_start=Ts_start[nNodes_Total + 1 - nNodes_entryPipe_b],
    T_b_start=Ts_start[nNodes_Total],
    Ts_start=Ts_start[nNodes_Total + 1 - nNodes_entryPipe_b:nNodes_Total],
    m_flow_a_start=m_flow_start,
    dheight=dheight_entryPipe_b,
    height_a=nozzle_b.height_a)
    "This pipe serves to capture the pressure drop not captued by the nozzle dP (i.e., length and static dP), if any, for nozzle_b"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={70,50})));
  // Summary Calculation Variables
  SI.Area surfaceArea_total_output "Total heat transfer surface area";
  SI.CoefficientOfHeatTransfer alpha_avg_output
    "Average heat transfer coefficient";
  SI.ThermalResistance R_conv_output
    "Averagethermal resistance to convective heat transfer";
  // Key variables for diagnostics
  SI.CoefficientOfHeatTransfer[nNodes_intTotal] alphas_output
    "Volume node heat transfer coefficient";
  SI.Area[nNodes_intTotal]   surfaceAreas_output "Heat transfer surface area";
  SI.Temperature[nNodes_intTotal] Ts_medium_output "Medium temperature";
  SI.Temperature[nNodes_intTotal] Ts_wall_output "Wall temperature";
equation
  connect(nozzle_a.port_b, endCross_a.port_a) annotation (Line(points={{-70,10},
          {-70,10},{-70,-10}},  color={0,127,255}));
  if nb == 1 then
    connect(endCross_a.port_b,window_b.port_a);
  elseif nb == 2 then
    connect(endCross_a.port_b,window[1].port_a);
    connect(window[nb-1].port_b,centerCross[nb-1].port_a);
    connect(centerCross[nb-1].port_b,window_b.port_a);
  else
    connect(endCross_a.port_b,window[1].port_a);
    for i in 1:nb-2 loop
      connect(window[i].port_b,centerCross[i].port_a);
      connect(centerCross[i].port_b,window[i+1].port_a);
    end for;
    connect(window[nb-1].port_b,centerCross[nb-1].port_a);
    connect(centerCross[nb-1].port_b,window_b.port_a);
  end if;
  connect(window_b.port_b, endCross_b.port_a)
    annotation (Line(points={{60,-60},{70,-60},{70,-30}}, color={0,127,255}));
  connect(endCross_b.port_b, nozzle_b.port_b)
    annotation (Line(points={{70,-10},{70,0},{70,10}}, color={0,127,255}));
  connect(endCross_a.heatPorts, heatPorts_a[1:nNodes_endCross]);
  for i in 1:nb-1 loop
    connect(window[i].heatPorts, heatPorts_a[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window]);
    connect(centerCross[i].heatPorts, heatPorts_a[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+nNodes_centerCross]);
  end for;
  connect(window_b.heatPorts, heatPorts_a[nNodes_endCross+(nb-1)*(nNodes_window+nNodes_centerCross)+1:nNodes_endCross+ (nb-1)*(nNodes_window+nNodes_centerCross)+ nNodes_window]);
  connect(endCross_b.heatPorts, heatPorts_a[nNodes_intTotal-nNodes_endCross+1:nNodes_intTotal]);
  connect(entryPipe_a.port_a, port_a) annotation (Line(points={{-80,50},
          {-90,50},{-90,0},{-100,0}}, color={0,127,255}));
  connect(entryPipe_a.port_b, nozzle_a.port_a) annotation (Line(points={
          {-60,50},{-50,50},{-50,40},{-70,40},{-70,30}}, color={0,127,255}));
  connect(entryPipe_b.port_a, nozzle_b.port_a) annotation (Line(points={
          {60,50},{50,50},{50,40},{70,40},{70,30}}, color={0,127,255}));
  connect(entryPipe_b.port_b, port_b) annotation (Line(points={{80,50},{
          90,50},{90,0},{100,0}}, color={0,127,255}));
  /* Gather key outputs under single variabls names for diagnostics. */
  // 1
  alphas_output[1:nNodes_endCross] = endCross_a.heatTransfer.alphas;
  // 2
  surfaceAreas_output[1:nNodes_endCross] = endCross_a.surfaceAreas;
  // 3
  Ts_medium_output[1:nNodes_endCross] = endCross_a.mediums.T;
  // 4
  Ts_wall_output[1:nNodes_endCross] = endCross_a.heatPorts.T;
  for i in 1:nb-1 loop
    // 1
    alphas_output[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window]= window[i].heatTransfer.alphas;
    alphas_output[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+nNodes_centerCross]= centerCross[i].heatTransfer.alphas;
    // 2
    surfaceAreas_output[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window]= window[i].surfaceAreas;
    surfaceAreas_output[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+nNodes_centerCross]= centerCross[i].surfaceAreas;
    // 3
    Ts_medium_output[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window]= window[i].mediums.T;
    Ts_medium_output[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+nNodes_centerCross]= centerCross[i].mediums.T;
    // 4
    Ts_wall_output[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window]= window[i].heatPorts.T;
    Ts_wall_output[nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+1:nNodes_endCross+(i-1)*(nNodes_window+nNodes_centerCross)+nNodes_window+nNodes_centerCross]= centerCross[i].heatPorts.T;
  end for;
  // 1
  alphas_output[nNodes_intTotal-nNodes_endCross-nNodes_window+1:nNodes_intTotal-nNodes_endCross] =  window_b.heatTransfer.alphas;
  alphas_output[nNodes_intTotal-nNodes_endCross+1:nNodes_intTotal] = endCross_b.heatTransfer.alphas;
  // 2
  surfaceAreas_output[nNodes_intTotal-nNodes_endCross-nNodes_window+1:nNodes_intTotal-nNodes_endCross] =  window_b.surfaceAreas;
  surfaceAreas_output[nNodes_intTotal-nNodes_endCross+1:nNodes_intTotal] = endCross_b.surfaceAreas;
  // 3
  Ts_medium_output[nNodes_intTotal-nNodes_endCross-nNodes_window+1:nNodes_intTotal-nNodes_endCross] =  window_b.mediums.T;
  Ts_medium_output[nNodes_intTotal-nNodes_endCross+1:nNodes_intTotal] = endCross_b.mediums.T;
  // 4
  Ts_wall_output[nNodes_intTotal-nNodes_endCross-nNodes_window+1:nNodes_intTotal-nNodes_endCross] =  window_b.heatPorts.T;
  Ts_wall_output[nNodes_intTotal-nNodes_endCross+1:nNodes_intTotal] = endCross_b.heatPorts.T;
  /* Summary Calculations */
  surfaceArea_total_output = sum(surfaceAreas_output);
  alpha_avg_output = sum(alphas_output*surfaceAreas_output/surfaceArea_total_output);
  R_conv_output = 1/(alpha_avg_output*surfaceArea_total_output);
  annotation (defaultComponentName="shell",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Polygon(
          points={{88,13},{88,-13},{72,-5},{60,-5},{60,-27},{50,-27},{50,5},{72,
              5},{88,13}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-88,13},{-88,-13},{-72,-5},{-60,-5},{-60,-27},{-50,-27},{-50,
              5},{-72,5},{-88,13}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-16},{80,-100}},
          lineColor={0,0,0},
          fillColor={124,186,186},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-80,-98},{80,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-42},{70,-44}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-28},{70,-30}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-57},{70,-59}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-72},{70,-74}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-86},{70,-88}},
          lineColor={0,0,0},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,-18},{80,-98}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-80,-18},{-70,-98}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-40,-18},{-30,-78}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-5,-38},{4,-98}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Rectangle(
          extent={{30,-18},{40,-78}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-80,-18},{80,-16}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(points={{-52,4}}, color={28,108,200}),
        Line(points={{-28,-20}}, color={0,0,0})}),
                         Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>Entry pipes (a/b) and nozzels do not participate in heat transfer in the shell.</p>
<p>Staic pressure head (elevation change) is assumed to be linear spaced between nozzles in the window sections.</p>
</html>"));
end STHX_ShellSide_BellDelaware;
