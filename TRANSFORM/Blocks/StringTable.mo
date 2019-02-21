within TRANSFORM.Blocks;
block StringTable "Generate a String table"
  extends Modelica.Blocks.Icons.Block;
  parameter String table[:, :]=fill(
        "",
        0,
        2) "Table matrix for String parameters";
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={               Text(
            extent={{-20,53},{19,38}},
            lineColor={0,0,0},
          textString="y[2]"),                Text(
            extent={{-70,53},{-31,38}},
            lineColor={0,0,0},
          textString="y[1]"),
        Line(points={{-75,60},{-75,-60},{-25,-60},{-25,60},{-75,60}}, color={0,0,
              0}),
        Line(points={{-25,30},{-75,30}}, color={0,0,0}),
        Line(points={{-75,0},{-25,0}}, color={0,0,0}),
        Line(points={{-75,-30},{-25,-30}}, color={0,0,0}),
        Line(points={{-25,60},{-25,-60},{25,-60},{25,60},{-25,60}}, color={0,0,0}),
        Line(points={{25,30},{-25,30}}, color={0,0,0}),
        Line(points={{-25,0},{25,0}}, color={0,0,0}),
        Line(points={{-25,-30},{25,-30}}, color={0,0,0}),
                                             Text(
            extent={{30,53},{69,38}},
            lineColor={0,0,0},
          textString="...y[n]"),
        Line(points={{25,60},{25,-60},{75,-60},{75,60},{25,60}}, color={0,0,0}),
        Line(points={{75,30},{25,30}}, color={0,0,0}),
        Line(points={{25,0},{75,0}}, color={0,0,0}),
        Line(points={{25,-30},{75,-30}}, color={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html>
<p>This block generates a graphical interface for the generation of a string table data that can then be referenced by components.</p>
<p>The number of tables and rows are specified by clicking on the edit icon next to the variable table.</p>
<p>Example: </p>
<p>Rows = 4 and Columns = 2</p>
<p><span style=\"font-family: Courier New;\">   table = [&quot;a&quot;, &quot;apple&quot;;</span></p>
<p><span style=\"font-family: Courier New;\">            &quot;b&quot;, &quot;boy&quot;;</span></p>
<p><span style=\"font-family: Courier New;\">            &quot;c&quot;, &quot;cat&quot;;</span></p>
<p><span style=\"font-family: Courier New;\">            &quot;d&quot;, &quot;dog&quot;];</span></p>
</html>"));
end StringTable;
