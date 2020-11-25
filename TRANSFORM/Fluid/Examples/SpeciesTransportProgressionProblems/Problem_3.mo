within TRANSFORM.Fluid.Examples.SpeciesTransportProgressionProblems;
model Problem_3
  "Single species drift with decay non-uniform concentration"
  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames=fill(
           "a", nC), C_nominal=fill(1.0, nC));

  constant Integer nC=1;
  parameter Integer nV=10;
  parameter SI.Length length=0.100;
  parameter SI.Length dimension=0.01;

  parameter SI.Velocity v=0.02;
  final parameter SI.MassFlowRate m_flow = Medium.density_pT(1e5,293.15)*Modelica.Constants.pi*dimension^2/4*v;

  parameter TRANSFORM.Units.InverseTime lambda_i[nC]=fill(0.1, nC);
  parameter SIadd.ExtraPropertyConcentration C_i_start[nV,nC]=ones(nV, nC);
  parameter SIadd.ExtraPropertyConcentration C_i_w_start[nV,nC]=zeros(nV, nC);

  final parameter SIadd.ExtraProperty Cs_start[nV,nC]={{C_i_start[i, j]/
      Medium.density_pT(pipe.p_a_start, pipe.T_a_start) for j in 1:nC} for i in 1
      :nV};
  SI.Length x[nV]=pipe.summary.xpos;

  SIadd.ExtraPropertyConcentration C_i[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_analytical[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_w_analytical[nV,nC];

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens={{-lambda_i[j]*pipe.mCs[i, j]*pipe.nParallel
      for j in 1:nC} for i in 1:nV};

  Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    Cs_start=Cs_start,
    p_a_start=100000,
    T_a_start=293.15,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    m_flow=m_flow,
    T=293.15,
    C=Cs_start[1, :],
    nPorts=1) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p=100000,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{60,-10},{40,10}})));

equation

  // Create variable for volume based concentration
  for j in 1:nV loop
    for i in 1:nC loop
      C_i[j, i] = pipe.Cs[j, i]*pipe.mediums[j].d;
    end for;
  end for;

  // Analytical Solution
  for j in 1:nV loop
    if x[j] < v*time then
      for i in 1:nC loop
        C_i_analytical[j, i] = C_i_start[j, i]*exp(-lambda_i[i]*x[j]/v);
        C_i_w_analytical[j,i] = C_i_start[j, i]*(1-exp(-lambda_i[i]*x[j]/v)+lambda_i[i]*exp(-lambda_i[i]*x[j]/v)*(time-x[j]/v));
      end for;
    else
      for i in 1:nC loop
        C_i_analytical[j, i] = C_i_start[j, i]*exp(-lambda_i[i]*time);
        C_i_w_analytical[j,i] = C_i_start[j, i]*(1-exp(-lambda_i[i]*x[j]/v));
      end for;
    end if;
  end for;

  connect(boundary.ports[1], pipe.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(pipe.port_b, boundary1.ports[1])
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=20,
      __Dymola_NumberOfIntervals=400,
      __Dymola_Algorithm="Dassl"));
end Problem_3;
