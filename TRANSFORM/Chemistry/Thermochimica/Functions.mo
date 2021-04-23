within TRANSFORM.Chemistry.Thermochimica;
package Functions

  function RunThermochimica
    import Thermochimica;
    input Real temp, pres;
    input Real[:] mass;
    input Integer[:] elements;
    input Integer reinit = 0;
  protected
    Integer ierr;
  algorithm
    TRANSFORM.Chemistry.Thermochimica.Functions.SetStandardUnits();
    TRANSFORM.Chemistry.Thermochimica.Functions.ResetThermo();
    TRANSFORM.Chemistry.Thermochimica.Functions.SetTemperaturePressure(temp,pres);
    for i in 1:size(mass,1) loop
      TRANSFORM.Chemistry.Thermochimica.Functions.SetElementMass(elements[i],mass[i]);
    end for;
    TRANSFORM.Chemistry.Thermochimica.Functions.SetReinitRequested(reinit);
    TRANSFORM.Chemistry.Thermochimica.Functions.Thermochimica();
    TRANSFORM.Chemistry.Thermochimica.Functions.SaveReinitData();
  //    TRANSFORM.Chemistry.Thermochimica.Functions.PrintResults();
  end RunThermochimica;

  function Thermochimica
  external "FORTRAN 77" thermochimica() annotation(Library={"thermochimica","gfortran"});
  end Thermochimica;

  function ResetThermoAll
  external "FORTRAN 77" resetthermoall() annotation(Library={"thermochimica","gfortran"});
  end ResetThermoAll;

  function SetStandardUnits
    external "FORTRAN 77" setmodelicaunits() annotation(Library={"thermochimica","gfortran"});
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
    TRANSFORM.Chemistry.Thermochimica.Functions.RunThermochimica(
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
    input String filename;
    input Real temp;
    input Real press;
    input Real[:] mass;
    input Integer[:] elements;
    input Integer[:] species;
    input String[:] phaseNames;
    input Boolean init;
    output Real[size(species,1)+size(phaseNames,1)] moleFraction;
  protected
    Integer ierr;
  algorithm
    if init then
      TRANSFORM.Chemistry.Thermochimica.Functions.InitThermochimica(filename);
    end if;
    TRANSFORM.Chemistry.Thermochimica.Functions.RunThermochimica(
      temp,
      press,
      mass,
      elements,1);
  //  TRANSFORM.Chemistry.Thermochimica.Functions.PrintResults();
    for i in 1:size(species,1) loop
      moleFraction[i] := TRANSFORM.Chemistry.Thermochimica.Functions.GetMoleFraction(species[i]);
    end for;
    for i in 1:size(phaseNames,1) loop
      (moleFraction[size(species,1)+i],ierr) :=TRANSFORM.Chemistry.Thermochimica.Functions.GetMolesPhase(phaseNames[i]);
    end for;
  end RunAndGetMoleFraction;

  function PrintResults
  external "FORTRAN 77" printresultstofile() annotation(Library={"thermochimica","gfortran"});
  end PrintResults;

  function SetPrintResultsMode
  input Integer iMode;
  external "FORTRAN 77" setprintresultsmode(iMode) annotation(Library={"thermochimica","gfortran"});
  end SetPrintResultsMode;

  function CheckInfoC
    output Integer ierr;
  external "C" checkinfothermo_(ierr) annotation(Library={"thermoc"});
  end CheckInfoC;

  function SetReinitRequested
  input Integer iMode;
  external "FORTRAN 77" setreinitrequested(iMode) annotation(Library={"thermochimica","gfortran"});
  end SetReinitRequested;

  function LoadReinitData
  external "FORTRAN 77" loadreinitdata() annotation(Library={"thermochimica","gfortran"});
  end LoadReinitData;

  function SaveReinitData
  external "FORTRAN 77" savereinitdata() annotation(Library={"thermochimica","gfortran"});
  end SaveReinitData;

  function ResetThermo
  external "FORTRAN 77" resetthermo() annotation(Library={"thermochimica","gfortran"});
  end ResetThermo;

  function InitThermochimica
    input String filename;
  algorithm
    TRANSFORM.Chemistry.Thermochimica.Functions.ResetThermoAll();
     TRANSFORM.Chemistry.Thermochimica.Functions.SetThermoFilename(filename);
     TRANSFORM.Chemistry.Thermochimica.Functions.ParseDataFile();
  end InitThermochimica;

  function GetMolesPhase
    input String phaseName;
    output Real molesPhase;
    output Integer ierr;
  external "C" GetSolnPhaseMol(phaseName,molesPhase,ierr) annotation(Library={"thermoc"});
  end GetMolesPhase;

  function RunAndGetMolesPhase
    import runThermochimica;
    input String filename;
    input Real temp;
    input Real press;
    input Real[:] mass;
    input Integer[:] elements;
    input Boolean init;
    input String phaseName;
    output Real molesGas;
  protected
    Integer ierr;
  algorithm
    if init then
      TRANSFORM.Chemistry.Thermochimica.Functions.InitThermochimica(filename);
    end if;
    TRANSFORM.Chemistry.Thermochimica.Functions.RunThermochimica(
      temp,
      press,
      mass,
      elements,1);
    (molesGas,ierr) :=TRANSFORM.Chemistry.Thermochimica.Functions.GetMolesPhase(phaseName);
  end RunAndGetMolesPhase;

  function SetThermoFilename
    input String filename;
  external "C" SetThermoFilename(filename) annotation(Library={"thermoc"});
  end SetThermoFilename;

  function ParseDataFile
  external "FORTRAN 77" ssparsecsdatafile() annotation(Library={"thermochimica","gfortran"});
  end ParseDataFile;

  function RunAndGetMolesFluid
    import runThermochimica;
    input String filename;
    input Real temp;
    input Real press;
    input Real[:] mass;
    input Integer[:] elements;
    input String[:] elementNames;
    input String[:] phaseNames;
    input Boolean init;
    output Real[size(elements,1)+size(phaseNames,1)] moles;
  protected
    Integer ierr;
    Real moleGas;
    Real moleLiq;
  algorithm
    if init then
      TRANSFORM.Chemistry.Thermochimica.Functions.InitThermochimica(filename);
    end if;
    TRANSFORM.Chemistry.Thermochimica.Functions.RunThermochimica(
      temp,
      press,
      mass,
      elements,1);
  //  TRANSFORM.Chemistry.Thermochimica.Functions.PrintResults();
    for i in 1:size(elementNames,1) loop
      (moleGas,ierr) := TRANSFORM.Chemistry.Thermochimica.Functions.GetElementMolesInPhase(elementNames[i],"gas_ideal");
      (moleLiq,ierr) := TRANSFORM.Chemistry.Thermochimica.Functions.GetElementMolesInPhase(elementNames[i],"LIQUsoln");
      moles[i] := moleGas + moleLiq;
    end for;
    for i in 1:size(phaseNames,1) loop
      (moles[size(elementNames,1)+i],ierr) :=TRANSFORM.Chemistry.Thermochimica.Functions.GetMolesPhase(phaseNames[i]);
    end for;
  end RunAndGetMolesFluid;

  function GetElementMolesInPhase
    input String elementName;
    input String phaseName;
    output Real molesElement;
    output Integer ierr;
  external "C" GetElementMolesInPhase(elementName, phaseName, molesElement, ierr) annotation(Library={"thermoc"});
  end GetElementMolesInPhase;
end Functions;
