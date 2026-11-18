within TRANSFORM.Obsolete.Math.GNU_ScientificLibrary;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

annotation (DocumentationClass=true, Documentation(info="<html>
<p>Obsolete. This package once called the GNU Scientific Library (GSL). Its functions now call TRANSFORM's own Modelica functions (<code>TRANSFORM.Math.besselI</code>, <code>besselK</code>, <code>besselY</code>, <code>besselJ</code>), so it needs no compiled library. It is kept so that models written for earlier versions keep working; use those functions in new models.</p>
<p>The Models package wraps the functions as blocks, and the Examples package shows them in use.</p>
</html>"));
end UsersGuide;
