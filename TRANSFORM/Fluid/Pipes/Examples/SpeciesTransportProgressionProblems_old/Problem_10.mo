within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems_old;
model Problem_10
  "Uranium Isotopes Decay"

  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames=fill("dummy", nC), C_nominal=fill(1.0,
          nC));

  constant Integer nC=9;
  parameter Integer nV=1;
  parameter SI.Length length=1.0;
  parameter SI.Length dimension=0.01;
  parameter SI.Temperature T_start=20 + 273.15;
  parameter SI.Pressure p_start=1e5;

  parameter TRANSFORM.Units.InverseTime lambda_ij[nC,nC]={{-1.3797E-13,0,0,0,0,0,0,0,0},{0,-8.947E-14,0,0,0,0,0,
      0,0},{0,0,-3.1209E-17,0,0,0,0,9.1103E-13,0},{0,0,0,-9.3787E-16,0,0,0,0,0},{0,0,0,0,-1.1885E-06,0,0,0,0},{0,
      0,0,0,0,-4.9161E-18,0,0,0},{0,0,0,0,0,0,-0.00049262,0,0},{0,0,0,0,0,0,0,-9.1103E-13,3.4052E-06},{0,0,0,0,0,
      0,0.00049262,0,-3.4052E-06}};

  parameter SIadd.ExtraPropertyConcentration C_i_start[nV,nC]=fill(
      100,
      nV,
      nC);

  final parameter SIadd.ExtraProperty Cs_start[nV,nC]={{C_i_start[i, j]/Medium.density_pT(p_start, T_start)
       for j in 1:nC} for i in 1:nV};

  // Pipe cell centers are a shifted from linspace in the pipe due to volume centered geometry
  parameter SI.Length x[nV]={if i == 1 then 0.5*length/nV else x[i - 1] + length/nV for i in 1:nV};
  //   parameter SI.Length x[nV]=linspace(
  //       0,
  //       length,
  //       nV);

  SIadd.ExtraPropertyConcentration C_i[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_basic[nV,nC](start=C_i_start);
  SIadd.ExtraPropertyConcentration C_i_analytical[nV,nC];

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens={{sum({lambda_ij[i, j]*pipe.mCs[k, j] for j in 1:nC})*pipe.nParallel
      for i in 1:nC} for k in 1:nV};

  Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    showName=false,
    Cs_start=Cs_start,
    p_a_start=p_start,
    T_a_start=T_start,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens)) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    showName=false,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    showName=false,
    p=p_start,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{60,-10},{40,10}})));

equation

  // Create variable for volume based concentration
  for k in 1:nV loop
    for i in 1:nC loop
      C_i[k, i] = pipe.Cs[k, i]*pipe.mediums[k].d;
      der(C_i_basic[k, i]) = sum({lambda_ij[i, j]*C_i_basic[k, j] for j in 1:nC});
    end for;
  end for;

  // Analytical Solution
  for j in 1:nV loop
    C_i_analytical[j, 1] = exp(time*lambda_ij[1, 1])*C_i_start[j, 1];
    C_i_analytical[j, 2] = exp(time*lambda_ij[2, 2])*C_i_start[j, 2];

    C_i_analytical[j, 3] = exp(time*lambda_ij[3, 3])*C_i_start[j, 3] + (lambda_ij[8, 8]*((exp(time*lambda_ij[3,
      3]) - exp(time*lambda_ij[8, 8]))*C_i_start[j, 8]*(-lambda_ij[3, 3] + lambda_ij[7, 7])*(lambda_ij[7, 7] -
      lambda_ij[8, 8])*(lambda_ij[7, 7] - lambda_ij[9, 9])*(-lambda_ij[3, 3] + lambda_ij[9, 9])*(-lambda_ij[8, 8]
       + lambda_ij[9, 9]) + lambda_ij[9, 9]*(C_i_start[j, 9]*(lambda_ij[3, 3] - lambda_ij[7, 7])*(-lambda_ij[7,
      7] + lambda_ij[8, 8])*(lambda_ij[7, 7] - lambda_ij[9, 9])*((exp(time*lambda_ij[8, 8]) - exp(time*
      lambda_ij[9, 9]))*lambda_ij[3, 3] + (-exp(time*lambda_ij[3, 3]) + exp(time*lambda_ij[9, 9]))*lambda_ij[8,
      8] + (exp(time*lambda_ij[3, 3]) - exp(time*lambda_ij[8, 8]))*lambda_ij[9, 9]) + C_i_start[j, 7]*lambda_ij[
      7, 7]*((exp(time*lambda_ij[3, 3]) - exp(time*lambda_ij[7, 7]))*lambda_ij[8, 8]*lambda_ij[9, 9]*(-
      lambda_ij[8, 8] + lambda_ij[9, 9]) + lambda_ij[7, 7]^2*((-exp(time*lambda_ij[3, 3]) + exp(time*lambda_ij[9,
      9]))*lambda_ij[8, 8] + (exp(time*lambda_ij[3, 3]) - exp(time*lambda_ij[8, 8]))*lambda_ij[9, 9]) +
      lambda_ij[3, 3]^2*((-exp(time*lambda_ij[8, 8]) + exp(time*lambda_ij[9, 9]))*lambda_ij[7, 7] + (exp(time*
      lambda_ij[7, 7]) - exp(time*lambda_ij[9, 9]))*lambda_ij[8, 8] - (exp(time*lambda_ij[7, 7]) - exp(time*
      lambda_ij[8, 8]))*lambda_ij[9, 9]) + lambda_ij[7, 7]*((exp(time*lambda_ij[3, 3]) - exp(time*lambda_ij[9, 9]))
      *lambda_ij[8, 8]^2 - (exp(time*lambda_ij[3, 3]) - exp(time*lambda_ij[8, 8]))*lambda_ij[9, 9]^2) +
      lambda_ij[3, 3]*((exp(time*lambda_ij[8, 8]) - exp(time*lambda_ij[9, 9]))*lambda_ij[7, 7]^2 + (-exp(time*
      lambda_ij[7, 7]) + exp(time*lambda_ij[9, 9]))*lambda_ij[8, 8]^2 + (exp(time*lambda_ij[7, 7]) - exp(time*
      lambda_ij[8, 8]))*lambda_ij[9, 9]^2)))))/((lambda_ij[3, 3] - lambda_ij[7, 7])*(lambda_ij[3, 3] -
      lambda_ij[8, 8])*(lambda_ij[7, 7] - lambda_ij[8, 8])*(lambda_ij[3, 3] - lambda_ij[9, 9])*(lambda_ij[7, 7] -
      lambda_ij[9, 9])*(lambda_ij[8, 8] - lambda_ij[9, 9]));

    C_i_analytical[j, 7] = exp(time*lambda_ij[7, 7])*C_i_start[j, 7];

    C_i_analytical[j, 8] = (-(exp(time*lambda_ij[8, 8])*C_i_start[j, 8]*(-lambda_ij[7, 7] + lambda_ij[8, 8])) +
      (lambda_ij[9, 9]*((exp(time*lambda_ij[8, 8]) - exp(time*lambda_ij[9, 9]))*C_i_start[j, 9]*(-lambda_ij[7, 7]
       + lambda_ij[8, 8])*(lambda_ij[7, 7] - lambda_ij[9, 9]) - C_i_start[j, 7]*lambda_ij[7, 7]*((exp(time*
      lambda_ij[8, 8]) - exp(time*lambda_ij[9, 9]))*lambda_ij[7, 7] + (-exp(time*lambda_ij[7, 7]) + exp(time*
      lambda_ij[9, 9]))*lambda_ij[8, 8] + (exp(time*lambda_ij[7, 7]) - exp(time*lambda_ij[8, 8]))*lambda_ij[9, 9])))
      /((lambda_ij[7, 7] - lambda_ij[9, 9])*(lambda_ij[8, 8] - lambda_ij[9, 9])))/(lambda_ij[7, 7] - lambda_ij[8,
      8]);

    C_i_analytical[j, 9] = -(((exp(time*lambda_ij[7, 7]) - exp(time*lambda_ij[9, 9]))*C_i_start[j, 7]*lambda_ij[
      7, 7] + exp(time*lambda_ij[9, 9])*C_i_start[j, 9]*(-lambda_ij[7, 7] + lambda_ij[9, 9]))/(lambda_ij[7, 7] -
      lambda_ij[9, 9]));

    C_i_analytical[j, 4] = exp(time*lambda_ij[4, 4])*C_i_start[j, 4];
    C_i_analytical[j, 5] = exp(time*lambda_ij[5, 5])*C_i_start[j, 5];
    C_i_analytical[j, 6] = exp(time*lambda_ij[6, 6])*C_i_start[j, 6];
  end for;

  connect(boundary.ports[1], pipe.port_a) annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(pipe.port_b, boundary1.ports[1]) annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=4320,
      __Dymola_NumberOfIntervals=6000,
      __Dymola_Algorithm="Dassl"));
end Problem_10;
