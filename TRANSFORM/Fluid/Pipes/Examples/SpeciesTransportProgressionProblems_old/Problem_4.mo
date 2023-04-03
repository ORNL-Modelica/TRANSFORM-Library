within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems_old;
model Problem_4
  "Delayed Neutron Precursor Drift w/ Production and Decay"
  extends TRANSFORM.Icons.Example;
  extends TRANSFORM.Icons.UnderConstruction;

  // sort of working. periodic boundary condition is messed up though

  package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames=fill("a", nC), C_nominal=fill(1.0,
          nC));

  constant Integer nC=6;
  parameter Integer nV=10;
  parameter SI.Length length=1.0;
  parameter SI.Length length_loop=3.0;
  parameter SI.Length dimension=0.01;
  parameter SI.Temperature T_start=20 + 273.15;
  parameter SI.Pressure p_start=1e5;

  parameter SI.Velocity v=0.25;
  final parameter SI.MassFlowRate m_flow=Medium.density_pT(p_start, T_start)*Modelica.Constants.pi*dimension^2/4
      *v;

  parameter TRANSFORM.Units.InverseTime lambda_i[nC]={0.0127,0.0317,0.115,0.311,1.4,3.87};
  final parameter SI.Time t_half[nC]={log(2)/lambda_i[i] for i in 1:nC};
  final parameter SIadd.ExtraPropertyConcentration C_i_start[nV,nC]=zeros(nV, nC);
  parameter Real phi_0=1e10;
  parameter Real beta_i[nC]=fill(1, nC);
  //{0.0006,0.00364,0.00349,0.00628,0.00179,0.00070};

  final parameter SIadd.ExtraProperty Cs_start[nV,nC]={{C_i_start[i, j]/Medium.density_pT(p_start, T_start)
      for j in 1:nC} for i in 1:nV};
  final parameter SI.Length x[nV]=linspace(
      0,
      length,
      nV);
  //pipe.summary.xpos;
  final parameter SI.Length x_loop[nV]=linspace(
      0,
      0.3,
      nV);

  SIadd.ExtraPropertyConcentration C_i[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_loop[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_analytical[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_loop_analytical[nV,nC];

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens={{-lambda_i[j]*pipe.mCs[i, j]*pipe.nParallel + beta_i[j]*phi_0*sin(
       Modelica.Constants.pi*pipe.summary.xpos_norm[j]) for j in 1:nC} for i in 1:nV};
  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens_loop={{-lambda_i[j]*pipe_loop.mCs[i, j]*pipe_loop.nParallel for j in
          1:nC} for i in 1:nV};
  Real cool=v*time;
  //         Real fun[nC] = {C_i_loop_analytical[end,i] for i in 1:nC};
  Real teset[nV]={sin(Modelica.Constants.pi*pipe.summary.xpos_norm[j]) for j in 1:nV};
  Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    Cs_start=Cs_start,
    p_a_start=p_start,
    T_a_start=T_start,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration (
         mC_gens=mC_gens)) annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_C_in=true,
    m_flow=m_flow,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));

  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p=p_start,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{90,-10},{70,10}})));

  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_loop(
    redeclare package Medium = Medium,
    p_a_start=p_start,
    T_a_start=T_start,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        dimension=dimension,
        length=length_loop,
        nV=nV),
    redeclare model InternalTraceGen =
        ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration (
          mC_gens=mC_gens_loop)) annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Sensors.TraceSubstancesTwoPort_multi sensor_C(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{40,10},{60,-10}})));
equation

  // Create variable for volume based concentration
  for j in 1:nV loop
    for i in 1:nC loop
      C_i[j, i] = pipe.Cs[j, i]*pipe.mediums[j].d;
      C_i_loop[j, i] = pipe_loop.Cs[j, i]*pipe_loop.mediums[j].d;
    end for;
  end for;

  // Analytical Solution
  for j in 1:nV loop
    if x_loop[j] < v*time then
      for i in 1:nC loop
        C_i_loop_analytical[j, i] = C_i_analytical[end, i]*exp(-lambda_i[i]*x_loop[j]/v);
      end for;
    else
      for i in 1:nC loop
        C_i_loop_analytical[j, i] = C_i_start[j, i]*exp(-lambda_i[i]*time);
      end for;
    end if;
if x[j] < v*time then
       for i in 1:nC loop
         C_i_analytical[j, i] = (C_i_loop_analytical[end, i]-(beta_i[i]*phi_0*(Modelica.Constants.pi*v*(exp(lambda_i[i]*x[j]/v)*cos(
           Modelica.Constants.pi*x[j])-1) - exp(lambda_i[i]*x[j]/v)*sin(Modelica.Constants.pi*x[j])*lambda_i[i]))
           /(Modelica.Constants.pi^2*v^2 + lambda_i[i]^2))*exp(-lambda_i[i]*x[j]/v);
       end for;
     else
       for i in 1:nC loop
         C_i_analytical[j, i] = (beta_i[i]*phi_0*(Modelica.Constants.pi*v*exp(-time*lambda_i[i])*(cos(Modelica.Constants.pi*(time*v - x[j])) -
           cos(Modelica.Constants.pi*x[j])) + exp(-time*lambda_i[i])*(sin(Modelica.Constants.pi*(time*v - x[j])) +
           sin(Modelica.Constants.pi*x[j]))*lambda_i[i]))/(
           Modelica.Constants.pi^2*v^2 + lambda_i[i]^2);
       end for;
     end if;

  end for;

  connect(boundary.ports[1], pipe.port_a) annotation (Line(points={{-48,0},{-30,0}}, color={0,127,255}));
  connect(pipe.port_b, pipe_loop.port_a) annotation (Line(points={{-10,0},{10,0}}, color={0,127,255}));
  connect(pipe_loop.port_b, sensor_C.port_a) annotation (Line(points={{30,0},{40,0}}, color={0,127,255}));
  connect(sensor_C.port_b, boundary1.ports[1]) annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(sensor_C.C, boundary.C_in)
    annotation (Line(points={{50,-3.6},{50,-20},{-80,-20},{-80,-8},{-68,-8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=40,
      __Dymola_NumberOfIntervals=400,
      __Dymola_Algorithm="Dassl"));
end Problem_4;
