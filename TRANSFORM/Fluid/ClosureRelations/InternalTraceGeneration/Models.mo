within TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration;
package Models
  extends Icons.ModelPackage;
  package DistributedVolume_Trace_1D
    extends Icons.VariantsPackage;

    partial model PartialInternalTraceGeneration

      replaceable package Medium = Modelica.Media.Water.StandardWater
        constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
        annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));

      parameter Integer nV(min=1) = 1 "Number of discrete volumes"
        annotation (Dialog(tab="Internal Interface"));

      input Medium.ThermodynamicState[nV] states "Volume thermodynamic state"
        annotation (Dialog(tab="Internal Interface", group="Input Variables"));
      input SIadd.ExtraProperty Cs[nV,Medium.nC] "Trace mass-specific value  in volumes"
        annotation (Dialog(group="Input Variables", tab="Internal Interface"));
      input SI.Volume Vs[nV]
        "Volumes"
        annotation (Dialog(tab="Internal Interface", group="Input Variables"));
      input SI.Diameter dimensions[nV]
        "Characteristic dimension (e.g. hydraulic diameter)"
        annotation (Dialog(tab="Internal Interface", group="Input Variables"));
      input SI.Area crossAreas[nV] "Volumes cross sectional area"
        annotation (Dialog(tab="Internal Interface", group="Input Variables"));
      input SI.Length dlengths[nV]
        "Volumes length"
        annotation (Dialog(tab="Internal Interface", group="Input Variables"));

      // Variables defined by model
      output SIadd.ExtraPropertyFlowRate mC_flows[nV,Medium.nC] "Internal mass generation"
        annotation (Dialog(
          group="Output Variables",
          tab="Internal Interface",
          enable=false));

      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Bitmap(extent={{-120,-100},{120,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/ClosureModel_Ngen.jpg")}),
          Diagram(coordinateSystem(preserveAspectRatio=false)));
    end PartialInternalTraceGeneration;

    model GenericTraceGeneration

      import TRANSFORM.Math.fillArray_1D;

      extends PartialInternalTraceGeneration;

      input SIadd.ExtraPropertyFlowRate mC_gen[Medium.nC]=zeros(Medium.nC) "Mass generation"  annotation(Dialog(group=
              "Input Variables"));
      input SIadd.ExtraPropertyFlowRate mC_gens[nV,Medium.nC]=fillArray_1D(mC_gen, nV)
        "if non-uniform then set mC_gens"
        annotation (Dialog(group="Input Variables"));

    equation

      for ic in 1:Medium.nC loop
        for i in 1:nV loop
          mC_flows[i, ic] =mC_gens[i, ic];
      end for;
      end for;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end GenericTraceGeneration;

    model VolumetricTraceGeneration

      import TRANSFORM.Math.fillArray_1D;

      extends PartialInternalTraceGeneration;

      input SIadd.ExtraPropertyConcentration mC_ppp[Medium.nC]=zeros(Medium.nC) "Mass concentration generation"  annotation(Dialog(group=
              "Input Variables"));
      input SIadd.ExtraPropertyConcentration mC_ppps[nV,Medium.nC]=fillArray_1D(mC_ppp, nV)
        "if non-uniform then set mC_ppps"
        annotation (Dialog(group="Input Variables"));

    equation

      for ic in 1:Medium.nC loop
        for i in 1:nV loop
          mC_flows[i, ic] = mC_ppps[i, ic]*Vs[i];
      end for;
      end for;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end VolumetricTraceGeneration;
  end DistributedVolume_Trace_1D;
end Models;
