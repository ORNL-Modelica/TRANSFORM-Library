within TRANSFORM.Chemistry.Thermochimica.Models;
model ThermochimicaOffgas "Off-gas separator based on Thermochimica-derived partial pressures"
  parameter Integer nC=1 "Number of substances";
  HeatAndMassTransfer.Interfaces.MolePort_State port_a(nC=nC) annotation (Placement(transformation(
          extent={{-80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,
            10}})));
  HeatAndMassTransfer.Interfaces.MolePort_State port_b(nC=nC) annotation (Placement(transformation(
          extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,
            10}})));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

  parameter Boolean use_T_start=false annotation (Dialog(tab="Initialization"));
  parameter SI.Temperature T_start=293.15
    annotation (Dialog(tab="Initialization",enable=use_T_start));
  parameter SI.Pressure p_start = 1e5 annotation(Dialog(tab="Initialization"));
  parameter SIadd.ExtraProperty C_start[nC]=fill(0,nC)
    "Mass-Specific value" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances",
      enable=Medium.nC > 0));
//   SIadd.ExtraProperty C[nC](stateSelect=StateSelect.prefer, start=C_start) "Trace substance mass-specific value";


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
  parameter Real partialPressureThermochimica_start[nC_gas] = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMoleFraction(T_start,p_start/1e5,C_start,atomicNumbers,speciesIndex) "Thermochimica-derived initial partial pressures";
  Real partialPressureThermochimica[nC_gas] = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMoleFraction(T_start,p_start/1e5,port_a.C,atomicNumbers,speciesIndex) "Thermochimica-derived initial partial pressures";
  parameter SI.Concentration Cmolar_start_interface_gas[nC_salt]={p_start*
      sum(TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_atm(
      partialPressureThermochimica_start[:].*relationMatrix[i,:]))/(Modelica.Constants.R*T_start)
      for i in 1:nC_salt};
  SI.Concentration Cmolar_interface_gas[nC_salt](start=Cmolar_start_interface_gas)=
       {p_start*
    sum(TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_atm(partialPressureThermochimica[
    :].*relationMatrix[i,:]))/(Modelica.Constants.R*T_start) for i in 1:nC_salt};
  Real F_surplus = (2*port_a.C[2] - sum(port_a.C))/port_a.C[2];
  Real tempConcentration[nC_salt];
equation
  port_a.n_flow + port_b.n_flow = zeros(nC);
  when {F_surplus<0.001,F_surplus>-0.001} then
    tempConcentration = Cmolar_interface_gas;
  end when;
  if F_surplus<0.001 and F_surplus>-0.001 then
    port_b.C = tempConcentration;
  else
    port_b.C = Cmolar_interface_gas;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ThermochimicaOffgas;
