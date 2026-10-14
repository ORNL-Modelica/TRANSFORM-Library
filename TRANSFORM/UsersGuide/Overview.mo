within TRANSFORM.UsersGuide;
model Overview "Overview of the TRANSFORM Library"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>TRANSFORM provides components and examples for transient thermal-hydraulic and multiphysics modeling. Begin with an example near the component you want to use, then inspect its replaceable medium, geometry, and closure models.</p>
<h4>Finding models</h4>
<ul>
<li><code>Fluid</code>: fluid volumes, pipes, boundary conditions, fittings, and supporting correlations.</li>
<li><code>HeatAndMassTransfer</code> and <code>HeatExchangers</code>: thermal and mass-transfer components, discretized models, and heat exchangers.</li>
<li><code>Media</code>: material and fluid property packages, including models with optional external dependencies.</li>
<li><code>Blocks</code>, <code>Controls</code>, <code>Electrical</code>, <code>Mechanics</code>, and <code>Nuclear</code>: supporting domains and applications.</li>
<li><code>Examples</code>: system examples. Many component packages also have their own <code>Examples</code> subpackage.</li>
</ul>
<p>The <code>UsersGuide.Connectors</code> page explains flow, stream, and non-flow connector variables and the library's icon cues. <code>UsersGuide.DiscretizedModels</code> describes indexing and geometry conventions. <code>UsersGuide.UnitTesting</code> points to the separate regression-test repository.</p>
<h4>Modeling conventions</h4>
<p>For two-port components, <code>port_a</code> and <code>port_b</code> identify the two connection sides. Their names alone do not guarantee flow direction. Consult each connector and component for the sign convention and state equations. GUI groups labeled <code>Inputs</code> collect quantities that may be time varying; groups labeled <code>Parameters</code> contain model settings unless a replaceable model introduces its own settings.</p>
<p>Examples and packages can have different optional library, native-code, and compiler requirements. The repository README identifies known dependency families and links to the current testing workflow. Check the selected model and its medium before assuming that it will run in a given tool.</p>
</html>"));
end Overview;
