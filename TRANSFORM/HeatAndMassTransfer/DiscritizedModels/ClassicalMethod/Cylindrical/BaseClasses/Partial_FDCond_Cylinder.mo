within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.BaseClasses;
partial model Partial_FDCond_Cylinder "BaseClass for 2D Cylindrical FD"
  import      Modelica.Units.SI;
  import Modelica.Fluid.Types.Dynamics;
  import Modelica.Constants.pi;
  extends
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.BaseClasses.Partial_BaseFDCond_Cylinder;
  SI.Volume V_total=pi*(r_outer^2 - r_inner^2)*length
    "Total cylinder volume";
  SI.Volume Vs[nR,nZ] "Volume each node";
  SI.Temperature T_max "Maximum temperature";
  SI.Temperature T_effective
    "Effective (volume weighted average) temperature";
  SI.Temperature T_innerAvg "Average temperature of outer edge";
  SI.Temperature T_outerAvg "Average temperature of outer edge";
  SI.Temperature T_topAvg "Average temperature of outer edge";
  SI.Temperature T_bottomAvg "Average temperature of outer edge";
  SI.Temperature Ts[nR,nZ](start=Ts_start, stateSelect=StateSelect.prefer)
    "Nodal temperatures";
  SI.Power Q_gen_total "Total power generated";
  SI.Power[nR,nZ] Q_gen "Power generated per node";
  SI.Power Q_flow_innerTotal "Total heat flow across inner";
  SI.Power Q_flow_outerTotal "Total heat flow across outer";
  SI.Power Q_flow_topTotal "Total heat flow across top";
  SI.Power Q_flow_bottomTotal "Total heat flow across bottom";
  SI.Area[nZ] A_inner "Inner nodes boundary area";
  SI.Area[nZ] A_outer "Outer nodes boundary area";
  SI.Area[nR] A_bottom "Bottom nodes boundary area";
  SI.Area[nR] A_top "Top nodes boundary area";
  SI.Density d_effective "Volume averaged effective density";
  SI.Density d[nR,nZ] "Density";
  SI.ThermalConductivity lambda_effective
    "Volume averaged effective thermal conductivity";
  SI.ThermalConductivity[nR,nZ] lambda "Thermal conductivity";
  SI.SpecificHeatCapacity cp_effective
    "Volume averaged effective heat capacity";
  SI.HeatCapacity[nR,nZ] cp "Heat capacity";
  SI.ThermalResistance R_cond_axial
    "Approximate resistance to conduction in axial direction";
  SI.ThermalResistance R_cond_radial
    "Approximate resistance to conduction in radial direction";
protected
  Modelica.Blocks.Interfaces.RealInput[nR,nZ] q_ppp(unit="W/m3")
    "Needed to connect to conditional connector";
  SI.Temperature[nR,nZ] T_volavg "Volume weighted temperature";
  SI.Density d_volavg[nR,nZ] "Volume weighted density";
  SI.ThermalConductivity[nR,nZ] lambda_volavg
    "Volume weighted thermal conductivity";
  SI.SpecificHeatCapacity[nR,nZ] cp_volavg
    "Volume weighted heat capacity";
initial equation
  if energyDynamics == Dynamics.SteadyStateInitial then
    der(Ts) = zeros(nR, nZ);
  elseif energyDynamics == Dynamics.FixedInitial then
    Ts = Ts_start;
  end if;
equation
  T_effective = sum(T_volavg);
T_innerAvg =sum(heatPorts_inner.T)/nZ;
T_outerAvg =sum(heatPorts_outer.T)/nZ;
T_topAvg =sum(heatPorts_top.T)/nZ;
T_bottomAvg =sum(heatPorts_bottom.T)/nZ;
connect(q_ppp,q_ppp_input);
if not use_q_ppp then
  q_ppp =zeros(nR, nZ);
end if;
  for i in 1:nR loop
    for j in 1:nZ loop
    Q_gen[i,j] =q_ppp[i, j]*Vs[i, j];
    T_volavg[i,j] =Ts[i, j]*Vs[i, j]/V_total;
  end for;
end for;
Q_gen_total = sum(Q_gen);
Q_flow_innerTotal = sum(heatPorts_inner.Q_flow);
Q_flow_outerTotal = sum(heatPorts_outer.Q_flow);
Q_flow_topTotal = sum(heatPorts_top.Q_flow);
Q_flow_bottomTotal = sum(heatPorts_bottom.Q_flow);
  T_max = max(Ts);
  for i in 1:nR loop
    for j in 1:nZ loop
      d[i, j] = Material.density_T(T=Ts[i, j]);
    lambda[i,j] =Material.thermalConductivity_T(T=Ts[i, j]);
    cp[i,j] =Material.specificHeatCapacityCp_T(T=Ts[i, j]);
      d_volavg[i, j] = d[i, j]*Vs[i, j]/V_total;
    lambda_volavg[i,j] =lambda[i, j]*Vs[i, j]/V_total;
    cp_volavg[i,j] =cp[i, j]*Vs[i, j]/V_total;
  end for;
end for;
  d_effective = sum(d_volavg);
  lambda_effective = sum(lambda_volavg);
  cp_effective = sum(cp_volavg);
R_cond_axial =length/(lambda_effective*pi*(r_outer^2 - r_inner^2));
// log(1/0.001) is assuming an r_inner of 1% of r_outer providing an approximation for r_inner = 0.
R_cond_radial =noEvent(if r_inner < Modelica.Constants.eps then log(1/0.01)
    /(2*pi*lambda_effective*length) else log(r_outer/r_inner)/(2*pi*
    lambda_effective*length));
  annotation (experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000),
      __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={
        Line(
          points={{-80,-80},{-20,-80}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-80,-80},{-80,-20}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-104,-18},{-78,-40}},
          lineColor={0,0,0},
          textString="z"),
        Text(
          extent={{-42,-76},{-16,-98}},
          lineColor={0,0,0},
          textString="r"),
      Text(
        extent={{-12,-4},{12,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j"),
      Ellipse(
        extent={{4,4},{-4,-4}},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Ellipse(
        extent={{64,4},{56,-4}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{-56,4},{-64,-4}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{4,64},{-4,56}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{4,-56},{-4,-64}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Text(
        extent={{42,-4},{82,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i+1, j"),
      Text(
        extent={{-18,58},{18,40}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j+1"),
      Text(
        extent={{-18,-62},{18,-80}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i, j-1"),
      Text(
        extent={{-78,-4},{-38,-22}},
        lineColor={0,0,0},
        fontName="Cambria Math",
        fontSize=48,
        textString="i-1, j")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
        graphics={
        Rectangle(
          extent={{-50,54},{52,-52}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),                                                             Text(
          extent={{54,-56},{146,-100}},
          lineColor={28,108,200},
          textString="%name"),
      Ellipse(
        extent={{2,2},{-2,-2}},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Ellipse(
        extent={{2,-38},{-2,-42}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
        Text(
          extent={{-30,-46},{-22,-52}},
          lineColor={0,0,0},
          textString="r"),
        Line(
          points={{-42,-44},{-22,-44}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-50,-24},{-44,-30}},
          lineColor={0,0,0},
          textString="z"),
        Line(
          points={{-42,-44},{-42,-24}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
      Ellipse(
        extent={{42,2},{38,-2}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{2,42},{-2,38}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{-38,2},{-42,-2}},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
        Line(
          points={{20,-20},{20,0},{20,20},{-20,20},{-20,-20},{20,-20}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5)}));
end Partial_FDCond_Cylinder;
