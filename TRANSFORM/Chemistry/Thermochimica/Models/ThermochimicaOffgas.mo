within TRANSFORM.Chemistry.Thermochimica.Models;
model ThermochimicaOffgas "Off-gas separator based on Thermochimica-derived partial pressures"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);
  HeatAndMassTransfer.Interfaces.MolePort_Flow  mass_port_a(nC=Medium.nC) annotation (Placement(transformation(
          extent={{-80,-60},{-60,-40}}),iconTransformation(extent={{-80,-60},{-60,-40}})));
  HeatAndMassTransfer.Interfaces.MolePort_State mass_port_b(nC=Medium.nC) annotation (Placement(transformation(
          extent={{60,-60},{80,-40}}),iconTransformation(extent={{60,-60},{80,-40}})));

  input SI.Temperature T "Temperature"
      annotation (Dialog(group="Inputs"));
  input SI.Pressure p "Pressure"
      annotation (Dialog(group="Inputs"));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

  Boolean init;
  constant String filename="/home/max/proj/thermochimica/data/MSAX+CationVacancies.dat";
  TRANSFORM.Chemistry.Thermochimica.BaseClasses.ThermochimicaOutput thermochimicaOutput = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetPartialPressure(filename,T,p,mass_port_a.C,Medium.extraPropertiesNames,init) "Thermochimica-derived mole fractions";
  SI.Concentration Cmolar_interface_gas[Medium.nC]=thermochimicaOutput.partialPressure/(Modelica.Constants.R*T);
equation
  if time > 1 then
    init = false;
  else
    init = true;
  end if;
  mass_port_a.n_flow + mass_port_b.n_flow = zeros(Medium.nC);
  mass_port_b.C = Cmolar_interface_gas;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ThermochimicaOffgas;
