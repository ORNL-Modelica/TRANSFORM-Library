within TRANSFORM.HeatExchangers.BellDelaware_STHX.BaseClasses.HeatTransfer.Examples;
model BellDelaware_Test

//     parameter SI.VolumeFlowRate V_flow = 20/60^2;
//     parameter SI.Density rho_in = Medium.density_pT(p[1],T[1]);
//
//     replaceable package Medium = Modelica.Media.Water.StandardWater;
//     parameter Integer nHT = 1;
//     parameter Real nParallel=1;
//     parameter SI.Length[nHT] lengths=fill(1/nHT,nHT);
//     parameter SI.Area[nHT]  crossAreas=fill(1,nHT);
//     parameter SI.Length[nHT]  dimensions=fill(1,nHT);
//     parameter SI.Area[nHT]  surfaceAreas=fill(1,nHT);
//     parameter SI.Height[nHT]  roughnesses=fill(1,nHT);
//     parameter SI.MassFlowRate[nHT]  m_flows = {rho_in*V_flow};
//     parameter Boolean  use_k = true;
//
//
//    BellDelaware bellDelaware(
//      nHT = nHT,
//      nParallel=nParallel,
//      lengths=lengths,
//      crossAreas=crossAreas,
//      dimensions=dimensions,
//      surfaceAreas=surfaceAreas,
//      roughnesses=roughnesses,
//      states={states[1]},
//      m_flows= m_flows,
//      use_k = true,
//      d_B=0.026,
//      d_o=0.025,
//      D_i=0.310,
//      D_l=0.307,
//      DB=0.285,
//      H=0.076,
//      s1=0.032,
//      s2=0.0277,
//      S=0.184,
//      S_E=0.184,
//      e1=0.0125,
//      nes=8,
//      n_W=25,
//      n_T=66,
//      n_MR=5,
//      n_s=0) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
//    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(each T=
//          323.15)
//      annotation (Placement(transformation(extent={{-26,54},{-14,66}})));
//
//   parameter SI.Pressure p[2] = {1e5,1e5};
//   parameter SI.SpecificEnthalpy T[2] = {336.45,329.85};
//   Medium.ThermodynamicState states[2];
// equation
//   for i in 1:2 loop
//     states[i]=Medium.setState_pT(p[i],T[i]);
//   end for;

//
//   connect(fixedTemperature.port, bellDelaware.heatPorts[1])
//     annotation (Line(points={{-14,60},{0,60},{0,7}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BellDelaware_Test;
