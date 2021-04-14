within TRANSFORM.Chemistry.Thermochimica.Models;
model ThermochimicaOffgas "Off-gas separator based on Thermochimica-derived partial pressures"
  parameter Integer nC "Number of substances";
  HeatAndMassTransfer.Interfaces.MolePort_Flow  mass_port_a(nC=nC) annotation (Placement(transformation(
          extent={{-80,-60},{-60,-40}}),iconTransformation(extent={{-80,-60},{-60,-40}})));
  HeatAndMassTransfer.Interfaces.MolePort_State mass_port_b(nC=nC) annotation (Placement(transformation(
          extent={{60,-60},{80,-40}}),iconTransformation(extent={{60,-60},{80,-40}})));

  input SI.Temperature T "Temperature"
      annotation (Dialog(group="Inputs"));
  input SI.Pressure p "Pressure"
      annotation (Dialog(group="Inputs"));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

  parameter Real F_tolerance = 1e-3;

    // Species tracked in the gas
  constant String extraPropertiesNames_gas[:]={"Li","LiF","Na","NaF","F2Na2","F3Na3","K","KF","K2F2","Cs"};
  constant Integer nC_gas=size(extraPropertiesNames_gas, 1) "Number of species";
  constant Integer speciesIndex[nC_gas]={1,2,3,4,5,6,7,8,9,10};
  // Species tracked in the salt
  constant String extraPropertiesNames_salt[:]={"Li","F","Na","K","Cs"};
  constant Integer nC_salt=size(extraPropertiesNames_salt, 1) "Number of species";
  constant Integer atomicNumbers[nC_salt]={3,9,11,19,55};

  // Method to relate gas species to salt species
  constant Real relationMatrix[nC_salt,nC_gas]=
  {
  {1,1,0,0,0,0,0,0,0,0},
  {0,1,0,1,2,3,0,1,2,0},
  {0,0,1,1,2,3,0,0,0,0},
  {0,0,0,0,0,0,1,1,2,0},
  {0,0,0,0,0,0,0,0,0,1}}
    "Element (row) to species (column) molar relation matrix";
  Real moleFractionGas[nC_gas] = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMoleFraction(T,p,mass_port_a.C,atomicNumbers,speciesIndex) "Thermochimica-derived mole fractions";
  SI.Pressure partialPressureThermochimica[nC_gas] = p*moleFractionGas "Thermochimica-derived partial pressures";
  SI.Concentration Cmolar_interface_gas[nC_salt]=
       {sum(partialPressureThermochimica[:].*relationMatrix[i,:])/(Modelica.Constants.R*T) for i in 1:nC_salt};
  Real F_surplus = (2*mass_port_a.C[2] - sum(mass_port_a.C))/mass_port_a.C[2]; // Need to write function to find F concentration
  Real tempConcentration[nC_salt];
equation
  mass_port_a.n_flow + mass_port_b.n_flow = zeros(nC);
  when {F_surplus<F_tolerance,F_surplus>-F_tolerance} then
    tempConcentration = Cmolar_interface_gas;
  end when;
  if F_surplus<F_tolerance and F_surplus>-F_tolerance then
    mass_port_b.C = tempConcentration;
  else
    mass_port_b.C = Cmolar_interface_gas;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ThermochimicaOffgas;
