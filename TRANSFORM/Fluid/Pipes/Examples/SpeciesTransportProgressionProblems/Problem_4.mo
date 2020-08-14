within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_4 "Core | Decay | Advection | Periodic"
  extends Problem_2(boundary(use_C_in=true));

//   extends TRANSFORM.Icons.Example;
//
//   package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames=
//           fill("dummy", nC), C_nominal=fill(1.0, nC));
//
//   constant Integer nC=1;
//   parameter Integer nV=10;
//   parameter SI.Length length=1.0;
//   parameter SI.Length dimension=0.01;
//   parameter SI.Temperature T_start=20 + 273.15;
//   parameter SI.Pressure p_start=1e5;
//
//   parameter TRANSFORM.Units.InverseTime lambda_i[nC]=fill(0.1, nC);
//   parameter SIadd.ExtraPropertyConcentration C_i_start[nV,nC]=1000*ones(nV, nC);
//
//   // Convert from volume based to mass based
//   final parameter SIadd.ExtraProperty Cs_start[nV,nC]={{C_i_start[i, j]/
//       Medium.density_pT(p_start, T_start) for j in 1:nC} for i in 1:nV};
//
//   // Pipe cell centers are a shifted from linspace in the pipe due to volume centered geometry
//   //parameter SI.Length x[nV]={if i == 1 then 0.5*length/nV else x[i - 1] + length/nV for i in 1:nV};
//   parameter SI.Length x[nV]=linspace(
//       0,
//       length,
//       nV);
//
//   SIadd.ExtraPropertyConcentration C_i[nV,nC];
//   SIadd.ExtraPropertyConcentration C_i_analytical[nV,nC];
//
//   SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens={{-lambda_i[j]*pipe.mCs[i, j]*pipe.nParallel
//       for j in 1:nC} for i in 1:nV};
//
//   parameter SIadd.ExtraPropertyConcentration C_i_inlet[nC]=1000*ones(nC);
//   final parameter SIadd.ExtraProperty Cs_inlet[nC]={C_i_inlet[j]/
//       Medium.density_pT(p_start, T_start) for j in 1:nC};
//
//   parameter SI.Velocity v=0.02;
//   final parameter SI.MassFlowRate m_flow=Medium.density_pT(p_start, T_start)*
//       Modelica.Constants.pi*dimension^2/4*v;
//
//   Pipes.GenericPipe_MultiTransferSurface pipe(
//     redeclare package Medium = Medium,
//     Cs_start=Cs_start,
//     p_a_start=p_start,
//     T_a_start=T_start,
//     m_flow_a_start=m_flow,
//     redeclare model Geometry =
//         TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
//         (
//         dimension=dimension,
//         length=length,
//         nV=nV),
//     redeclare model InternalTraceGen =
//         TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
//         (mC_gens=mC_gens))
//     annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
//   BoundaryConditions.MassFlowSource_T boundary(
//     redeclare package Medium = Medium,
//     use_C_in=true,
//     m_flow=m_flow,
//     T=T_start,
//     nPorts=1)
//     annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
//
//   BoundaryConditions.Boundary_pT boundary1(
//     redeclare package Medium = Medium,
//     p=p_start,
//     T=T_start,
//     nPorts=1) annotation (Placement(transformation(extent={{80,-10},{60,10}})));
//   Sensors.TraceSubstancesTwoPort_multi sensor_C(redeclare package Medium =
//         Medium, allowFlowReversal=false)
//     annotation (Placement(transformation(extent={{30,10},{50,-10}})));
//
// equation
//
//   // Create variable for volume based concentration
//   for j in 1:nV loop
//     for i in 1:nC loop
//       C_i[j, i] = pipe.Cs[j, i]*pipe.mediums[j].d;
//     end for;
//   end for;
//
//   // Analytical Solution
//   for j in 1:nV loop
//     if x[j] < v*time then
//       for i in 1:nC loop
//         C_i_analytical[j, i] = C_i_inlet[i]*exp(-lambda_i[i]*x[j]/v);
//       end for;
//     else
//       for i in 1:nC loop
//         C_i_analytical[j, i] = C_i_start[j, i]*exp(-lambda_i[i]*time);
//       end for;
//     end if;
//   end for;
//
//   connect(boundary.ports[1], pipe.port_a)
//     annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
//   connect(sensor_C.C, boundary.C_in) annotation (Line(points={{40,-3.6},{40,-20},
//           {-90,-20},{-90,-8},{-80,-8}}, color={0,0,127}));
//   connect(pipe.port_b, sensor_C.port_a)
//     annotation (Line(points={{-20,0},{30,0}}, color={0,127,255}));
//   connect(sensor_C.port_b, boundary1.ports[1])
//     annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
//   annotation (
//     Icon(coordinateSystem(preserveAspectRatio=false)),
//     Diagram(coordinateSystem(preserveAspectRatio=false)),
//     experiment(
//       StopTime=100,
//       __Dymola_NumberOfIntervals=1000,
//       Tolerance=1e-06,
//       __Dymola_Algorithm="Dassl"));
equation
  connect(sensor_C.C, boundary.C_in) annotation (Line(points={{40,-3.6},{40,-20},
          {-90,-20},{-90,-8},{-80,-8}}, color={0,0,127}));
end Problem_4;
