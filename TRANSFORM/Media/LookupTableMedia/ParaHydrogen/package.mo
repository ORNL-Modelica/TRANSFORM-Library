within TRANSFORM.Media.LookupTableMedia;
package ParaHydrogen "ParaHydrogen | Single Phase | Lookup Tables"
  extends TRANSFORM.Media.LookupTableMedia.BaseClasses.LookupTableMedium(
    mediumName="ParaHydrogen");

    redeclare function extends getCriticalPressure
    algorithm
      criticalPressure :=1285800;
    end getCriticalPressure;
 // constant R[nS] fluidConstants "Constant data for the fluid";
end ParaHydrogen;
