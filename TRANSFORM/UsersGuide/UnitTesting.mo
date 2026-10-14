within TRANSFORM.UsersGuide;
model UnitTesting "Unit Testing Guide"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>TRANSFORM regression results and test configuration live in the separate <a href=\"https://github.com/ORNL-Modelica/TRANSFORM-UnitTests\">TRANSFORM-UnitTests repository</a>. That repository uses the <a href=\"https://github.com/ORNL-Modelica/DynamicSystemsTestingFramework\">Dynamic Systems Testing Framework (DSTF)</a> to discover defined tests, run selected simulator backends, and compare results with stored references.</p>
<p>Read the UnitTests README and <code>ReferenceResults/testing.json</code> before running the suite. The configuration identifies the TRANSFORM source path, simulators, and reference-result location; <code>ReferenceResults/test_spec.json</code> contains explicit test definitions. Reference results are partitioned by backend and operating system. A missing reference is a coverage gap until a run establishes its result.</p>
<p>Tests embedded in examples commonly use <code>TRANSFORM.Utilities.ErrorAnalysis.UnitTests</code> to identify signals for comparison. A passing regression comparison checks specified outputs against a reference; separate acceptance checks are needed for conservation, physical validity, and numerical robustness.</p>
<h4>Historical illustrations</h4>
<p>The images below describe an earlier workflow and may not match the current DSTF command line. Use the linked repository README for current commands.</p>
<p><img src=\"modelica://TRANSFORM/Resources/Images/NonPowerPoint/unitTestingInfo_1.PNG\" alt=\"Historical unit testing workflow, part one\"/></p>
<p><img src=\"modelica://TRANSFORM/Resources/Images/NonPowerPoint/unitTestingInfo_2.PNG\" alt=\"Historical unit testing workflow, part two\"/></p>
</html>"));
end UnitTesting;
