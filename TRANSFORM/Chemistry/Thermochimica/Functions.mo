within TRANSFORM.Chemistry.Thermochimica;
package Functions

  function runThermochimica
    import Thermochimica;
    input Real temp, pres;
    input Real[:] mass;
    input Integer[:] elements;
  algorithm
    TRANSFORM.Chemistry.Thermochimica.Functions.ResetThermoAll();
    TRANSFORM.Chemistry.Thermochimica.Functions.SetStandardUnits();
    TRANSFORM.Chemistry.Thermochimica.Functions.ParseMSTDB();
    TRANSFORM.Chemistry.Thermochimica.Functions.SetTemperaturePressure(temp,pres);
    for i in 1:size(mass,1) loop
      TRANSFORM.Chemistry.Thermochimica.Functions.SetElementMass(elements[i],mass[i]);
    end for;
    TRANSFORM.Chemistry.Thermochimica.Functions.Thermochimica();
  end runThermochimica;

  function Thermochimica
  external "FORTRAN 77" thermochimica() annotation(Library={"thermochimica","gfortran"});
  end Thermochimica;

  function ResetThermoAll
  external "FORTRAN 77" resetthermoall() annotation(Library={"thermochimica","gfortran"});
  end ResetThermoAll;

  function SetStandardUnits
    external "FORTRAN 77" setstandardunits() annotation(Library={"thermochimica","gfortran"});
  end SetStandardUnits;

  function ParseMSTDB
    external "FORTRAN 77" parsemstdb() annotation(Library={"thermochimica","gfortran"});
  end ParseMSTDB;

  function SetTemperaturePressure
  input Real dTemp, dPress;
  external "FORTRAN 77" settemperaturepressure(dTemp,dPress) annotation(Library={"thermochimica","gfortran"});
  end SetTemperaturePressure;

  function SetElementMass
    input Integer iAtom;
    input Real dMass;
    external "FORTRAN 77" setelementmass(iAtom,dMass) annotation(Library={"thermochimica","gfortran"});
  end SetElementMass;

  function RunAndGetElementPotential
    import runThermochimica;
    input Real temp,press;
    input Real[:] mass;
    input Integer[:] elements;
    output Real[size(mass,1)] mu;
  algorithm
    TRANSFORM.Chemistry.Thermochimica.Functions.runThermochimica(
      temp,
      press,
      mass,
      elements);
    for i in 1:size(mass,1) loop
      mu[i] := TRANSFORM.Chemistry.Thermochimica.Functions.GetElementPotential(i);
    end for;
  end RunAndGetElementPotential;

  function GetElementPotential
  input Integer i;
  output Real value;
  output Integer ierr;
    external "FORTRAN 77" getelementpotential(i,value,ierr) annotation(Library={"thermochimica","gfortran"});
  end GetElementPotential;

  function GetMoleFraction
  input Integer i;
  output Real value;
  output Integer ierr;
    external "FORTRAN 77" getmolfraction(i,value,ierr) annotation(Library={"thermochimica","gfortran"});
  end GetMoleFraction;

  function RunAndGetMoleFraction
    import runThermochimica;
    input Real temp;
    input Real press;
    input Real[:] mass;
    input Integer[:] elements;
    input Integer[:] species;
    output Real[size(species,1)] moleFraction;
  algorithm
    TRANSFORM.Chemistry.Thermochimica.Functions.runThermochimica(
      temp,
      press,
      mass,
      elements);
    for i in 1:size(species,1) loop
      moleFraction[i] := TRANSFORM.Chemistry.Thermochimica.Functions.GetMoleFraction(species[i]);
    end for;
  end RunAndGetMoleFraction;
end Functions;
