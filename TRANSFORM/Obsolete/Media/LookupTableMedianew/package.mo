within TRANSFORM.Obsolete.Media;
package LookupTableMedianew
  extends TRANSFORM.Icons.VariantsPackage;
  annotation (obsolete="Obsolete package - to be removed in the next minor release",
    Documentation(info="<html>
<p>Obsolete. This was an attempt at fluid media built from property tables (generated with CoolProp); it worked on its own but not in real system models. It needs two compiled libraries that TRANSFORM ships for Linux only (<code>libnoname</code> and the GNU Scientific Library). It is kept so that models written for earlier versions keep working, and will be removed, with those libraries, in the next minor release.</p>
</html>"));
end LookupTableMedianew;
