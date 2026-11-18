within TRANSFORM.Obsolete.Math;
package GNU_ScientificLibrary "GNU Scientific Library (GSL)"
  extends TRANSFORM.Icons.GSLPackage;
  annotation (obsolete="Obsolete package - use TRANSFORM.Math.besselI, besselK, besselY and besselJ instead",
    Documentation(info="<html>
<p>Obsolete. These classes no longer call the GNU Scientific Library: each function calls the Modelica function that replaces it (<code>TRANSFORM.Math.besselI</code>, <code>besselK</code>, <code>besselY</code>, <code>besselJ</code>), so models that use them keep working on every platform. Use those functions directly in new models.</p>
</html>"));

end GNU_ScientificLibrary;
