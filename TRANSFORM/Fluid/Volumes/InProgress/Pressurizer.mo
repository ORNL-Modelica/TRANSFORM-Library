within TRANSFORM.Fluid.Volumes.InProgress;
model Pressurizer
  "internal pressurizer region two phase drum model with 3 fluid ports and 4 heat ports"
  extends TRANSFORM.Fluid.Volumes.InProgress.PartialDrum2Phase2Volume;
  /* General */
  replaceable model DrumType =
      TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes.PartialDrumType
    "1. Select model 2. Set parameters (Total volume must match V_total)"
    annotation (choicesAllMatching=true, Dialog(group="Geometry"));
  DrumType drumType(
    Vfrac_liquid=Vfrac_liquid,
    V_liquid=V_liquid,
    V_vapor=V_vapor);
  /* Constitutive/Closure Models*/
  replaceable model BulkEvaporation =
      TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.ConstantTimeDelay
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.PartialMassTransfer
    "Vapor bubble transport from liquid to vapor phase" annotation (
      choicesAllMatching=true, Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  BulkEvaporation bulkEvaporation(redeclare final package Medium = Medium,
      final state=state_liquid);
  replaceable model BulkCondensation =
      TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.ConstantTimeDelay
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.PartialMassTransfer
    "Liquid droplet transport from vapor to liquid phase" annotation (
      choicesAllMatching=true, Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  BulkCondensation bulkCondensation(redeclare final package Medium = Medium,
      final state=state_vapor);
//   replaceable model MassTransfer_VL =
//       TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface.PartialPhase_m_flow
//     "Vapor-liquid interface mass transport coefficient" annotation (
//       choicesAllMatching=true, Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
//
//   MassTransfer_VL massTransfer_VL(
//     redeclare final package Medium = Medium,
//     state_liquid=state_liquid,
//     state_vapor=state_vapor,
//     surfaceArea=surfaceArea_VL);
  //   replaceable model HeatTransfer_VL =
  //       TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface.PartialPhase_alpha
  //     "Vapor-liquid interface heat transfer coefficient"
  //     annotation(choicesAllMatching=true, Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  //
  //   HeatTransfer_VL heatTransfer_VL(
  //     redeclare final package Medium = Medium,
  //     state_liquid=state_liquid,
  //     state_vapor=state_vapor,
  //     surfaceArea=surfaceArea_VL);
  replaceable model HeatTransfer_WL =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.PartialHeatTransfer_setT
    "Wall-liquid heat transfer coefficient" annotation (choicesAllMatching=true,
      Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  HeatTransfer_WL heatTransfer_WL(
    redeclare each final package Medium = Medium,
    final v=0,
    final state=state_liquid,
    final crossArea=drumType.crossArea_liquid,
    final surfaceArea=drumType.surfaceArea_WL,
    final dimension=V_liquid/drumType.crossArea_liquid,
    final nParallel=1) annotation (Placement(transformation(extent={{64,-46},{76,
            -34}}, rotation=0)));
  replaceable model HeatTransfer_WV =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.PartialHeatTransfer_setT
    "Wall-vapor heat transfer coefficient" annotation (choicesAllMatching=true,
      Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  HeatTransfer_WV heatTransfer_WV(
    redeclare each final package Medium = Medium,
    final v=0,
    final state=state_vapor,
    final crossArea=drumType.crossArea_vapor,
    final surfaceArea=drumType.surfaceArea_WL,
    final dimension=V_vapor/drumType.crossArea_vapor,
    final nParallel=1) annotation (Placement(transformation(extent={{64,46},{76,
            34}}, rotation=0)));
  /* Redefiniation of Port Parameters */
  SI.MassFlowRate W_surge "Mass flowrate of surgePort";
  SI.SpecificEnthalpy h_surge "Specific enthalpy of surgePort";
  SI.MassFlowRate W_relief "Mass flowrate of steamPort";
  SI.SpecificEnthalpy h_relief "Specific enthalpy of steamPort";
  SI.MassFlowRate W_spray "Mass flowrate of sprayPort";
  SI.SpecificEnthalpy h_spray "Specific enthalpy of sprayPort";
  /* Constitutive Parameters */
  // Geometry
  SI.Height level=drumType.level "Measured fluid level";
  SI.Area surfaceArea_Wall_total=drumType.surfaceArea_Wall_total
    "Total inner wall surface area of pressurizer";
  SI.Area surfaceArea_WL=drumType.surfaceArea_WL "Wall-Liquid surface area";
  SI.Area surfaceArea_WV=drumType.surfaceArea_WV "Wall-Vapor surface area";
  SI.Area surfaceArea_VL=drumType.surfaceArea_VL
    "Vapor-Liquid interfacial area";
  // Bulk Behavior
  SI.MassFlowRate W_cBulk "Mass flowrate of bulk condensation";
  SI.MassFlowRate W_eBulk "Mass flowrate of bulk evaporation";
  // Spray
  //   SI.QualityFactor x_th_spray "Thermodynamic quality of sprayPort";
  //   SI.MassFlowRate W_cSpray "Mass flowrate of condensate from sprayPort";
  //   SI.MassFlowRate W_vapSpray
  //     "Mass flowrate of of liquid after heat/mass balance from sprayPort";
  //   SI.MassFlowRate W_liqSpray
  //     "Mass flowrate of of liquid after heat/mass balance from sprayPort";
  //   SI.EnthalpyFlowRate H_cSpray "Mass flowrate of condensate from sprayPort";
  //   SI.EnthalpyFlowRate H_vapSpray
  //     "Mass flowrate of of liquid after heat/mass balance from sprayPort";
  //   SI.EnthalpyFlowRate H_liqSpray
  //     "Mass flowrate of of liquid after heat/mass balance from sprayPort";
  // Vapor-Liquid Interface
  SI.MassFlowRate W_vl "Mass flowrate from vapor-liquid interface model";
  SI.Power Q_vl "Heat transfer at vapor-liquid interface";
  // Wall-Liquid/Vapor Interfaces
  SI.Power Q_wl "Heat transfer at wall-liquid surface";
  SI.Power Q_wv "Heat transfer at wall-vapor surface";
  SI.MassFlowRate W_cWall
    "Mass flowrate from condensate due to wall-vapor heat transfer";
  /* Additional Parameters */
  SI.QualityFactor x_th_liquid "Thermodynamic quality of liquid region";
  SI.QualityFactor x_abs_liquid "Absolute quality of liquid region";
  SI.QualityFactor x_th_vapor "Thermodynamic quality of vapor region";
  SI.QualityFactor x_abs_vapor "Absolute quality of liquid region";
  Modelica.Fluid.Interfaces.FluidPort_b surgePort(
    p(start=p_start),
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    annotation (Placement(transformation(extent={{-18,-116},{16,-82}}, rotation=
           0)));
  Modelica.Fluid.Interfaces.FluidPort_b sprayPort(
    p(start=p_start),
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    annotation (Placement(transformation(extent={{-77,83},{-43,117}}, rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b steamPort(
    p(start=p_start),
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    annotation (Placement(transformation(extent={{42,82},{78,118}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a vaporHeater
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a liquidHeater
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  SI.Power Q_hl "Heat transfer at heater-liquid";
  SI.Power Q_hv "Heat transfer at heater-vapor";
  SI.SpecificEnthalpy h_vl
    "Specific enthalpy of fluid flow at vapor-liquid interface";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_WV
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_WL
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  HeatAndMassTransfer.Resistances.Heat.Convection heatTransfer_VL(
    surfaceArea=surfaceArea_VL,
    alpha=alpha,
    port_a(T=medium_liquid.T),
    port_b(T=medium_vapor.T)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,0})));
  parameter SI.CoefficientOfHeatTransfer alpha=0
    "Vapor-Liquid convection heat transfer coefficient" annotation (Dialog(
        group="Closure Models: 1. Select Model 2. Set parameters"));
  FittingsAndResistances.MassTranportCoefficient massTransfer_VL(
    redeclare package Medium = Medium,
    alphaM0=alphaM0,
    surfaceArea=surfaceArea_VL,
    port_a(
      p=medium_liquid.p,
      h_outflow=medium_liquid.h,
      Xi_outflow=medium_liquid.Xi,
      C_outflow=fill(0, Medium.nC)),
    port_b(
      p=medium_vapor.p,
      h_outflow=medium_vapor.h,
      Xi_outflow=medium_vapor.Xi,
      C_outflow=fill(0, Medium.nC))) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,0})));
  parameter Real alphaM0(unit="kg/(s.m2.K)")=0 "Vapor-Liquid coefficient of mass transfer"
    annotation (Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
equation
  assert(abs(V_total - drumType.V_total) < 0.001, "Total volumes don't equate, check that V_total is equal to the volume calculated from the drum type geometry parameters");
  /* Mass Conservation Equations */
  // === Liquid ===
  mb_flow_liquid = W_surge + W_cBulk + W_vl + W_cWall - W_eBulk;
  //mb_flow_liquid = W_cBulk - W_eBulk + W_surge + W_liqSpray + W_cSpray + W_vl + W_cWall;
  // === Vapor ===
  mb_flow_vapor = W_spray + W_relief + W_eBulk - W_cBulk - W_vl - W_cWall;
  //mb_flow_vapor = W_eBulk - W_cBulk + W_relief - W_cSpray + W_vapSpray - W_vl - W_cWall;
  //Consider adding evaporation from spray term (applicable when vapor is superheated
  /* Energy Conservation Equations */
  // === Liquid ===
  Hb_flow_liquid = W_surge*h_surge + W_cBulk*h_fsat + W_vl*h_vl + W_cWall*
    h_fsat - W_eBulk*h_gsat;
  Qb_flow_liquid = Q_hl + Q_wl + Q_vl;
  Wb_flow_liquid = -p*der(V_liquid);
  //   Hb_flow_liquid = W_cBulk*h_fsat
  //                       - W_eBulk*h_gsat
  //                       + W_surge*h_surge
  //                       + H_liqSpray + H_cSpray
  //                       + W_vl*h_gsat
  //                       + W_cWall*(h_gsat-h_fsat);
  //   Qb_flow_liquid = liquidHeater.Q_flow + Q_vl + Q_wl;
  //   Wb_flow_liquid = -p*der(V_liquid);
  // === Vapor ===
  Hb_flow_vapor = W_spray*h_spray + W_relief*h_relief + W_eBulk*h_gsat -
    W_cBulk*h_fsat - W_vl*h_vl - W_cWall*h_fsat;
  Qb_flow_vapor = Q_hv + Q_wv - Q_vl;
  Wb_flow_vapor = -p*der(V_vapor);
  //   Hb_flow_vapor = W_eBulk*h_gsat
  //                     - W_cBulk*h_gsat
  //                     + W_relief*h_relief
  //                     - H_cSpray + H_vapSpray
  //                     - W_vl*h_gsat
  //                     - W_cWall*(h_gsat-h_fsat);
  //   Qb_flow_vapor = vaporHeater.Q_flow - Q_vl + Q_wv;
  //   Wb_flow_vapor =  -p*der(V_vapor);
  /* Constitutive Models */
  Q_hv = 0;
  Q_hl = 0;
  h_vl = h_gsat;
  //if W_vl >= 0 then h_fsat else h_gsat;
  W_cWall = noEvent(if Q_wv < 0 then -Q_wv/(h_gsat - h_fsat) else 0);
  W_eBulk = bulkEvaporation.m_flow;
  W_cBulk = bulkCondensation.m_flow;
  W_vl = massTransfer_VL.m_flow;
  Q_vl = heatTransfer_VL.Q_flow;
  Q_wl = heatPort_WL.Q_flow;
  Q_wv = heatPort_WV.Q_flow;
  // Spray Port physics. Flow into liquid is defined as positive direction.
  // Spray is assumed to reach saturation conditions immediately upon entering
  // which has been shown by experiment to be a reasonable approximation.
  //    x_th_spray = (h_spray - h_fsat)/(h_gsat-h_fsat);
  //    if h_spray <= h_fsat then
  //      W_cSpray = W_spray*(h_fsat-h_spray)/(h_vapor-h_fsat);
  //      H_cSpray = W_cSpray*h_fsat;
  //      W_vapSpray = 0;
  //      H_vapSpray = 0;
  //      W_liqSpray = W_spray;
  //      H_liqSpray = W_spray*h_fsat;
  //    elseif h_spray >= h_gsat then
  //      W_cSpray = 0;
  //      H_cSpray = 0;
  //      W_vapSpray = W_spray;
  //      H_vapSpray = W_vapSpray*h_spray;
  //      W_liqSpray = 0;
  //      H_liqSpray = 0;
  //    else
  //      W_cSpray = 0;
  //      H_cSpray = 0;
  //      W_vapSpray = W_spray*x_th_spray;
  //      H_vapSpray = W_vapSpray*h_gsat;
  //      W_liqSpray = W_spray-W_vapSpray;
  //      H_liqSpray = W_liqSpray*h_fsat;
  //    end if;
  /* Additional Parameter Definitions */
  x_th_liquid = (h_liquid - h_fsat)/(h_gsat - h_fsat);
  x_abs_liquid = homotopy(noEvent(if h_liquid <= h_fsat then 0 else x_th_liquid),
    0);
  x_th_vapor = (h_vapor - h_fsat)/(h_gsat - h_fsat);
  x_abs_vapor = homotopy(noEvent(if h_vapor >= h_gsat then 1 else x_th_vapor), 1);
  /* Connector Stream Definitions */
  // Surge Port
  surgePort.p = p + rho_liquid*Modelica.Constants.g_n*level;
  surgePort.m_flow = W_surge;
  surgePort.h_outflow = h_liquid;
  h_surge = homotopy(if not allowFlowReversal then inStream(surgePort.h_outflow)
     else noEvent(actualStream(surgePort.h_outflow)), inStream(surgePort.h_outflow));
  // Spray Port
  sprayPort.p = p;
  sprayPort.m_flow = W_spray;
  sprayPort.h_outflow = h_vapor;
  h_spray = homotopy(if not allowFlowReversal then inStream(sprayPort.h_outflow)
     else noEvent(actualStream(sprayPort.h_outflow)), inStream(sprayPort.h_outflow));
  // Steam Port
  steamPort.p = p;
  steamPort.m_flow = W_relief;
  steamPort.h_outflow = h_vapor;
  h_relief = homotopy(if not allowFlowReversal then inStream(steamPort.h_outflow)
     else noEvent(actualStream(steamPort.h_outflow)), inStream(steamPort.h_outflow));
  // Heat Ports
  liquidHeater.T = T_liquid;
  vaporHeater.T = T_vapor;
  //   heatPort_WL = T_wl;
  //   heatPort_WV = T_vl;
  mbXi_liquid_flow = zeros(Medium.nXi);
  mbXi_liquid_flow = zeros(Medium.nXi);
  connect(heatTransfer_WV.heatPorts, heatPort_WV)
    annotation (Line(points={{76,40},{100,40},{100,40}}, color={191,0,0}));
  connect(heatTransfer_WL.heatPorts, heatPort_WL)
    annotation (Line(points={{76,-40},{100,-40},{100,-40}}, color={191,0,0}));
  annotation (
    defaultComponentName="drum2Phase",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,1},{99,-99}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-66,46},{-60,38}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-82,72},{-76,64}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,54},{-10,46}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-28,84},{-22,76}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,36},{26,28}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,28},{-32,20}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{64,66},{70,58}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,74},{30,66}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{66,34},{72,26}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-72,-16},{-66,-24}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-36,-40},{-30,-48}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-72,-44},{-66,-52}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{14,-32},{20,-40}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{64,-48},{70,-56}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{48,-12},{54,-20}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{32,-64},{38,-72}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-12,-14},{-6,-22}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-52,-68},{-46,-76}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>Spray stream is assumed to be saturated liquid. This means there is no equation for condensing due to spray.... this was causing solver problems... Should be addressed.</p>
<p><br>This model describes the cylindrical drum of a drum boiler, without assuming thermodynamic equilibrium between the liquid and vapour holdups. Connectors are provided for surgePort inlet, steamPort outlet, downcomer outlet, riser inlet, and blowdown outlet. </p>
<p>The model is based on dynamic mass and energy balance equations of the liquid volume and vapour volume inside the drum. Mass and energy tranfer between the two phases is provided by bulk condensation and surface condensation of the vapour phase, and by bulk boiling of the liquid phase. Additional energy transfer can take place at the surface if the steamPort is superheated. </p>
<p>The riser flowrate is separated before entering the drum, at the vapour pressure. The (saturated) liquid fraction goes into the liquid volume; the (wet) vapour fraction goes into the vapour volume, vith a steamPort quality depending on the liquid/vapour density ratio and on the <code><span style=\"font-family: Courier New,courier;\">avr</span></code> parameter. </p>
<p>The enthalpy of the liquid going to the downcomer is computed by assuming that a fraction of the total mass flowrate (<code><span style=\"font-family: Courier New,courier;\">afd</span></code>) comes directly from the surgePort inlet. The pressure at the downcomer connector is equal to the vapour pressure plus the liquid head. </p>
<p>The metal wall dynamics is taken into account, assuming uniform temperature. Heat transfer takes place between the metal wall and the liquid phase, vapour phase, and external atmosphere, the corresponding heat transfer coefficients being <code><span style=\"font-family: Courier New,courier;\">gl</span></code>, <code><span style=\"font-family: Courier New,courier;\">gv</span></code>, and <code><span style=\"font-family: Courier New,courier;\">gext</span></code>. </p>
<p>The drum level is referenced to the centreline. </p>
<p>The start values of drum pressure, liquid specific enthalpy, vapour specific enthalpy, and metal wall temperature can be specified by setting the parameters <code><span style=\"font-family: Courier New,courier;\">p_start</span></code>, <code><span style=\"font-family: Courier New,courier;\">h_liquid_start</span></code>, <code><span style=\"font-family: Courier New,courier;\">h_vapor_start</span></code>, <code><span style=\"font-family: Courier New,courier;\">Tmstart</span></code> </p>
<h4>Modelling options</h4>
<p>The following options are available to specify the orientation of the cylindrical drum: </p>
<ul>
<li><code><span style=\"font-family: Courier New,courier;\">DrumOrientation = 0</span></code>: horizontal axis. </li>
<li><code><span style=\"font-family: Courier New,courier;\">DrumOrientation = 1</span></code>: vertical axis. </li>
</ul>
</html>", revisions="<htm_liquid>
<ul>
<li><i>30 May 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Initialisation support added.</li>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Standard medium definition added.</li>
<li><i>5 Jul 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Adapted to Modelica.Media.</li>
<li><i>1 Feb 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Improved equations for drum geometry.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Pressurizer;
