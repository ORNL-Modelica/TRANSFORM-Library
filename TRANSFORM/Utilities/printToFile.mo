within TRANSFORM.Utilities;
model printToFile
  input Real x "Variable to be printed" annotation(Dialog(group="Inputs"));
  parameter Real dtime "Time interval for printing. Note: Choose proper simulation and output intervals";
  parameter String fileName = "" "file name (e.g. ''myfile.txt'')";
equation
 if rem(time,dtime) == 0 then
    Modelica.Utilities.Streams.print(String(time) + "," + String(x), fileName);
 end if;
  annotation (defaultComponentName="print",
  Documentation(info="<html>
<p>Prints input variable &QUOT;x&QUOT; to a comma delimited file (time,x).</p>
<p><br>Note, ensure the Simulation setup simulation time and output interval match the specified &QUOT;dtime&QUOT;.</p>
<p><br>Example: Will Work</p>
<p>The following simulation setup will work because the output calculations are returned every second, and hence the dtime second interval values are accessible.</p>
<p>dtime = 60</p>
<p>Start time = 0</p>
<p>Stop time = 500 s</p>
<p>Number of intervals = 500</p>
<p><br>Example 2: Won&apos;t Work</p>
<p>The following simulation setup will NOT work because the output calculations are no returned at intervals of dtime (i.e., 60 seconds)e.</p>
<p>dtime = 60</p>
<p>Start time = 0</p>
<p>Stop time = 500 s</p>
<p>Number of intervals = 490</p>
</html>"), Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-56,24},{52,-16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end printToFile;
