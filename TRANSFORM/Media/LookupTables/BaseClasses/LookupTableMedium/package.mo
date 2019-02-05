within TRANSFORM.Media.LookupTables.BaseClasses;
package LookupTableMedium "Medium package accessing the lookup table solver"

  extends TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium(final
      libraryName="LookupTables", final substanceName=
        TRANSFORM.Media.LookupTables.BaseClasses.Common.CheckLookupTableOptions(substanceNames[1], debug=false));

  redeclare replaceable function isentropicEnthalpy
    input AbsolutePressure p_downstream "downstream pressure";
    input ThermodynamicState refState "reference state for entropy";
    output SpecificEnthalpy h_is "Isentropic enthalpy";
protected
    SpecificEntropy s_ideal;
    ThermodynamicState state_ideal;
  algorithm
    s_ideal := specificEntropy(refState);
    state_ideal := setState_psX(p_downstream, s_ideal);
    h_is := specificEnthalpy(state_ideal);
  end isentropicEnthalpy;
end LookupTableMedium;
