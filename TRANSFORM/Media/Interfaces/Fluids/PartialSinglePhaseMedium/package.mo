within TRANSFORM.Media.Interfaces.Fluids;
partial package PartialSinglePhaseMedium "Base class for single phase medium of one substance"
  extends TRANSFORM.Media.Interfaces.Fluids.PartialPureSubstance(redeclare record FluidConstants =
        Modelica.Media.Interfaces.Types.Basic.FluidConstants);
  constant FluidConstants[nS] fluidConstants "Constant data for the fluid";

  redeclare replaceable record extends ThermodynamicState
    "A selection of variables that uniquely defines the thermodynamic state"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
  end ThermodynamicState;

  redeclare replaceable function extends molarMass
    "Return the molar mass of the medium"
  algorithm
    MM := fluidConstants[1].molarMass;
  end molarMass;
end PartialSinglePhaseMedium;
