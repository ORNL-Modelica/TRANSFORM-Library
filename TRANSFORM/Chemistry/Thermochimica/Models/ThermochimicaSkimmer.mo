within TRANSFORM.Chemistry.Thermochimica.Models;
model ThermochimicaSkimmer "Off-gas separator based on Thermochimica-derived partial pressures"
  parameter Integer nC "Number of substances";

  package Medium_salt = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_9999Li7_pT (
        extraPropertiesNames=extraPropertiesNames_salt);

  input SI.Temperature T "Temperature"
      annotation (Dialog(group="Inputs"));
  input SI.Pressure p "Pressure"
      annotation (Dialog(group="Inputs"));
  input SIadd.ExtraProperty Cin[nC]=C_start;
  parameter SIadd.ExtraProperty C_start[nC];
  input Units.HydraulicResistance R "Hydraulic resistance" annotation(Dialog(group="Inputs"));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

  // Species tracked in the salt
  constant String extraPropertiesNames_salt[:]={"Li","F","Na","K","Pu"};
  constant Integer nC_salt=size(extraPropertiesNames_salt, 1) "Number of species";
  constant Integer atomicNumbers[nC_salt]={3,9,11,19,94};

  Boolean init;
  constant String filename="/home/max/proj/thermochimica/data/MSAX+CationVacancies.dat";
  constant String phaseNames[:]={"gas_ideal","LIQUsoln"};
  constant Integer nPhase=size(phaseNames, 1) "Number of phases";
  Real placeholder[nC_salt+nPhase] = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMolesFluid(filename,T,p,Cin,atomicNumbers,extraPropertiesNames_salt,phaseNames,init) "Thermochimica-derived mole fractions";
  SIadd.ExtraProperty Cfluid[nC_salt] = {placeholder[i] for i in 1:nC_salt};
  Real molesPhases[nPhase] = {placeholder[nC_salt+i] for i in 1:nPhase};
  Fluid.Interfaces.FluidPort_Flow           port_a(
    redeclare package Medium = Medium_salt)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}},  rotation=
           0), iconTransformation(extent={{-80,-70},{-60,-50}})));
  Fluid.Interfaces.FluidPort_Flow           port_b(
    redeclare package Medium = Medium_salt)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{40,-20},{80,20}},  rotation=0),
        iconTransformation(extent={{60,-70},{80,-50}})));
equation
  if time > 1 then
    init = false;
  else
    init = true;
  end if;
  port_a.m_flow + port_b.m_flow = 0;
  port_a.m_flow*R = port_a.p-port_b.p;
  port_a.C_outflow = Cfluid;
  port_b.C_outflow = Cfluid;
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ThermochimicaSkimmer;
