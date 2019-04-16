within TRANSFORM.Fluid.Machines;
model TurboPump

  extends BaseClasses.PartialTurboPump;
extends TRANSFORM.Icons.UnderConstruction;
  SIadd.NonDim theta;
  SIadd.NonDim v;
  SIadd.NonDim n;
  SIadd.NonDim h;
  SIadd.NonDim beta;
  SIadd.NonDim n2v2;
  final parameter SI.Torque tau_nominal = Modelica.Constants.g_n*d_nominal*head_nominal*V_flow_nominal/(eta_nominal*omega_nominal) "Rated or design torque";
  final parameter SI.AngularVelocity omega_nominal = N_nominal*2*Modelica.Constants.pi/60;
  parameter SI.Efficiency eta_nominal = 0.8 "Rated or design efficiency";

  Modelica.Blocks.Tables.CombiTable1D h_table(table=[0,-0.565181376; 0.182839121,
        -0.490866478; 0.27346905,-0.397154364; 0.361235972,-0.275257384; 0.449126181,
        -0.089805755; 0.627728511,0.231727754; 0.797495245,0.510706566; 0.973138677,
        0.810993548; 1.151617719,1.068972407; 1.324110474,1.249150076; 1.490603243,
        1.344464926; 1.761958784,1.350197789; 2.105916899,1.180931055; 2.455696918,
        1.00472598; 2.811381033,0.86395233; 3.152489839,0.72993209; 3.493598645,
        0.595911849; 3.837721143,0.511384646; 4.185049112,0.575213267; 4.538226384,
        0.646226802; 4.888102293,0.519453121; 5.236786424,-0.221682164; 5.589196574,
        -0.546119776; 5.939031388,-0.69407834; 6.111236472,-0.662194852; 6.283185307,
        -0.565181376])
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Tables.CombiTable1D beta_table(table=[0,-0.438078373; 0.084718586,
        -0.263581371; 0.170870044,-0.109115798; 0.25737972,-0.047563051; 0.43597704,
        0.128757026; 0.611555093,0.338199485; 0.78444651,0.494488132; 0.966267794,
        0.584592783; 1.131048129,0.594693254; 1.301739064,0.571732113; 1.478442945,
        0.489162836; 1.750765478,0.355505898; 2.094885157,0.349464165; 2.446655352,
        0.609069955; 2.789828311,0.848583546; 3.139602719,0.875846504; 3.484515595,
        0.66406923; 3.829991386,0.306286088; 4.178153812,0.001656759; 4.53519493,
        -0.355883306; 4.878930804,-1.012375583; 5.230931282,-1.562499467; 5.586872159,
        -1.634664426; 5.940791662,-1.182535587; 6.112889882,-0.820511399; 6.283185307,
        -0.438078373])
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation

theta = Modelica.Constants.pi + Modelica.Math.atan2(n,v);
n2v2 = max(1,n^2+v^2);

v = V_flow/V_flow_nominal;
n = N/N_nominal;

//head = 1
h = head/head_nominal/n2v2;

theta = h_table.u[1];
h = h_table.y[1];

//tau = 1;

beta = tau/tau_nominal/n2v2;

theta = beta_table.u[1];
beta = beta_table.y[1];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TurboPump;
