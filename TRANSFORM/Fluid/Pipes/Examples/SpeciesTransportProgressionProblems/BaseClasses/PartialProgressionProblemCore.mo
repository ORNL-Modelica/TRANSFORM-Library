within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems.BaseClasses;
partial model PartialProgressionProblemCore
  extends TRANSFORM.Icons.Example;

  package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_9999Li7_pT (            extraPropertiesNames=
          fill("dummy", nC), C_nominal=fill(1.0, nC));

  constant Integer nC=1;
  parameter Integer nV=10;
  parameter SI.Length length=1.0;
  parameter SI.Length dimension=0.01;
  parameter SI.Temperature T_start=20 + 273.15;
  parameter SI.Pressure p_start=1e5;

  parameter SI.Velocity v=0.0;

  parameter TRANSFORM.Units.InverseTime lambda_i[nC]=fill(0.1, nC);
  parameter SIadd.ExtraPropertyConcentration C_i_start[nV,nC]=1000*ones(nV, nC);
  parameter SIadd.ExtraPropertyConcentration C_i_inlet[nC]=zeros(nC);

  final parameter SI.MassFlowRate m_flow=Medium.density_pT(p_start, T_start)*
      Modelica.Constants.pi*dimension^2/4*v;
  final parameter SI.Time t_half[nC]={log(2)/lambda_i[i] for i in 1:nC};
  SI.Time t_residence = if pipe.m_flows[1] < Modelica.Constants.eps then Modelica.Constants.inf else pipe.ms[1]/pipe.m_flows[1];

  // Convert from volume based to mass based
  final parameter SIadd.ExtraProperty Cs_start[nV,nC]={{C_i_start[i, j]/
      Medium.density_pT(p_start, T_start) for j in 1:nC} for i in 1:nV};
  final parameter SIadd.ExtraProperty Cs_inlet[nC]={C_i_inlet[j]/
      Medium.density_pT(p_start, T_start) for j in 1:nC};

  SIadd.ExtraPropertyConcentration C_i[nV,nC];

  parameter Boolean use_generation = false;
  parameter Boolean use_PtoD = false;
  parameter Boolean use_capture = false;
  parameter Real parents[nC,nC]=if nC == 4 then
 {{0.0,0.0,0.0,0.0},
  {1.0,0.0,0.0,0.0},
  {0.0,1.0,0.0,0.0},
  {0.0,0.0,1.0,0.0}} else fill(0,nC,nC)
    "Matrix of parent sources (sum(column) = 0 or 1) for each fission product 'daughter'. Row is daughter, Column is parent.";

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens={{mC_decay[i, j]
  + (if use_generation then mC_generation[i, j] else 0)
  + (if use_PtoD then mC_gens_PtoD[i, j] else 0)
  + (if use_capture then mC_gens_capture[i, j] else 0)
  for j in 1:nC} for i in 1:nV};

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_decay = {{-lambda_i[j]*pipe.mCs[i, j]*pipe.nParallel for j in 1:nC} for i in 1:nV};
  Real[nV] mC_generationShape = {sin(Modelica.Constants.pi*pipe.summary.xpos_norm[i]) for i in 1:nV};
  //Real[nV] mC_captureShape = {sum({sin(k*Modelica.Constants.pi*pipe.summary.xpos_norm[i])/k for k in 1:100}) for i in 1:nV};
  Real[nV] mC_captureShape = {sum({-sin(k*Modelica.Constants.pi*(pipe.summary.xpos_norm[i]+1))/k for k in 1:100}) for i in 1:nV};
  SIadd.ExtraPropertyFlowRate[nV,nC] mC_generation = {{0.0005*mC_generationShape[i] for j in 1:nC} for i in 1:nV};
  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens_PtoD={{sum({lambda_i[k]*pipe.mCs[i, k]*pipe.nParallel*parents[j, k] for k in 1:nC}) for j in 1:nC} for i in 1:nV};
  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens_capture={{-0.1*mC_captureShape[i]* pipe.mCs[i, j]*pipe.nParallel for j in 1:nC} for i in 1:nV};

  Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    Cs_start=Cs_start,
    p_a_start=p_start,
    T_a_start=T_start,
    m_flow_a_start=m_flow,
    redeclare replaceable model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare replaceable model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens))
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_C_in=false,
    m_flow=m_flow,
    T=T_start,
    C=Cs_inlet,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p=p_start,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{80,-10},{60,10}})));

  Sensors.TraceSubstancesTwoPort_multi sensor_C(redeclare package Medium =
        Medium, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{30,10},{50,-10}})));

equation

  // Create variable for volume based concentration
  for j in 1:nV loop
    for i in 1:nC loop
      C_i[j, i] = pipe.Cs[j, i]*pipe.mediums[j].d;
    end for;
  end for;

  connect(boundary.ports[1], pipe.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(sensor_C.port_b, boundary1.ports[1])
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=40,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end PartialProgressionProblemCore;
