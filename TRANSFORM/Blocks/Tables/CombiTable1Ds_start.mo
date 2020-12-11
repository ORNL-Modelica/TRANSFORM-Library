within TRANSFORM.Blocks.Tables;
block CombiTable1Ds_start
  "Start value only: Table look-up in one dimension (matrix/file) with one input and n outputs"
  extends Modelica.Blocks.Icons.Block;
  final parameter Integer nout=size(columns, 1) "Number of outputs";
  parameter Real u_start "Connector of Real input signal";
  final parameter Real y_start[nout]={if smoothness == Modelica.Blocks.Types.Smoothness.ConstantSegments
       then Modelica.Blocks.Tables.Internal.getTable1DValueNoDer(
      tableID,
      i,
      u_start) else Modelica.Blocks.Tables.Internal.getTable1DValue(
      tableID,
      i,
      u_start) for i in 1:nout} "Connector of Real output signals";

  parameter Boolean tableOnFile=false
    "= true, if table is defined on file or in function usertab"
    annotation (Dialog(group="Table data definition"));
  parameter Real table[:, :] = fill(0.0, 0, 2)
    "Table matrix (grid = first column; e.g., table=[0, 0; 1, 1; 2, 4])"
    annotation (Dialog(group="Table data definition",enable=not tableOnFile));
  parameter String tableName="NoName"
    "Table name on file or in function usertab (see docu)"
    annotation (Dialog(group="Table data definition",enable=tableOnFile));
  parameter String fileName="NoName" "File where matrix is stored"
    annotation (Dialog(
      group="Table data definition",
      enable=tableOnFile,
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Boolean verboseRead=true
    "= true, if info message that file is loading is to be printed"
    annotation (Dialog(group="Table data definition",enable=tableOnFile));
  parameter Integer columns[:]=2:size(table, 2)
    "Columns of table to be interpolated"
    annotation (Dialog(group="Table data interpretation"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
    annotation (Dialog(group="Table data interpretation"));
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range"
    annotation (Dialog(group="Table data interpretation"));
  parameter Boolean verboseExtrapolation=false
    "= true, if warning messages are to be printed if table input is outside the definition range"
    annotation (Dialog(group="Table data interpretation", enable=extrapolation == Modelica.Blocks.Types.Extrapolation.LastTwoPoints or extrapolation == Modelica.Blocks.Types.Extrapolation.HoldLastPoint));
  final parameter Real u_min=Modelica.Blocks.Tables.Internal.getTable1DAbscissaUmin(
                                                             tableID)
    "Minimum abscissa value defined in table";
  final parameter Real u_max=Modelica.Blocks.Tables.Internal.getTable1DAbscissaUmax(
                                                             tableID)
    "Maximum abscissa value defined in table";
protected
  parameter Modelica.Blocks.Types.ExternalCombiTable1D tableID=
      Modelica.Blocks.Types.ExternalCombiTable1D(
        if tableOnFile then tableName else "NoName",
        if tableOnFile and fileName <> "NoName" and not Modelica.Utilities.Strings.isEmpty(fileName) then fileName else "NoName",
        table,
        columns,
        smoothness,
        extrapolation,
        if tableOnFile then verboseRead else false) "External table object";
//   function readTableData =
//     ObsoleteModelica4.Blocks.Tables.Internal.readTable1DData
//                                                     "Read table data from text or MATLAB MAT-file";
//                            // No longer used, but kept for backward compatibility
initial equation
  if tableOnFile then
    assert(tableName <> "NoName",
      "tableOnFile = true and no table name given");
  else
    assert(size(table, 1) > 0 and size(table, 2) > 0,
      "tableOnFile = false and parameter table is an empty matrix");
  end if;

  if verboseExtrapolation and (
    extrapolation == Modelica.Blocks.Types.Extrapolation.LastTwoPoints or
    extrapolation == Modelica.Blocks.Types.Extrapolation.HoldLastPoint) then
    assert(
      noEvent(u_start >= u_min),
      "
Extrapolation warning: The value u (=" + String(u_start) + ") must be greater or equal
than the minimum abscissa value u_min (=" + String(u_min) + ") defined in the table.
",    level=AssertionLevel.warning);
    assert(
      noEvent(u_start <= u_max),
      "
Extrapolation warning: The value u (=" + String(u_start) + ") must be less or equal
than the maximum abscissa value u_max (=" + String(u_max) + ") defined in the table.
",    level=AssertionLevel.warning);
  end if;

  annotation (
    Documentation(info="<html>
<p>
<strong>Univariate constant</strong>, <strong>linear</strong> or <strong>cubic Hermite
spline interpolation</strong> in <strong>one</strong> dimension of a
<strong>table</strong>.
Via parameter <strong>columns</strong> it can be defined how many columns of the
table are interpolated. If, e.g., columns={2,4}, it is assumed that
2 output signals are present and that the first output interpolates
via column 2 and the second output interpolates via column 4 of the
table matrix.
</p>
<p>
The grid points and function values are stored in a matrix \"table[i,j]\",
where the first column \"table[:,1]\" contains the grid points and the
other columns contain the data to be interpolated. Example:
</p>
<pre>
   table = [0,  0;
            1,  1;
            2,  4;
            4, 16]
   If, e.g., the input u = 1.0, the output y =  1.0,
       e.g., the input u = 1.5, the output y =  2.5,
       e.g., the input u = 2.0, the output y =  4.0,
       e.g., the input u =-1.0, the output y = -1.0 (i.e., extrapolation).
</pre>
<ul>
<li>The interpolation interval is found by a binary search where the interval used in the
    last call is used as start interval.</li>
<li>Via parameter <strong>smoothness</strong> it is defined how the data is interpolated:
<pre>
  smoothness = 1: Linear interpolation
             = 2: Akima interpolation: Smooth interpolation by cubic Hermite
                  splines such that der(y) is continuous, also if extrapolated.
             = 3: Constant segments
             = 4: Fritsch-Butland interpolation: Smooth interpolation by cubic
                  Hermite splines such that y preserves the monotonicity and
                  der(y) is continuous, also if extrapolated.
             = 5: Steffen interpolation: Smooth interpolation by cubic Hermite
                  splines such that y preserves the monotonicity and der(y)
                  is continuous, also if extrapolated.
</pre></li>
<li>Values <strong>outside</strong> of the table range, are computed by
    extrapolation according to the setting of parameter <strong>extrapolation</strong>:
<pre>
  extrapolation = 1: Hold the first or last value of the table,
                     if outside of the table scope.
                = 2: Extrapolate by using the derivative at the first/last table
                     points if outside of the table scope.
                     (If smoothness is LinearSegments or ConstantSegments
                     this means to extrapolate linearly through the first/last
                     two table points.).
                = 3: Periodically repeat the table data (periodical function).
                = 4: No extrapolation, i.e. extrapolation triggers an error
</pre></li>
<li>If the table has only <strong>one row</strong>, the table value is returned,
    independent of the value of the input signal.</li>
<li>The grid values (first column) have to be strictly increasing.</li>
</ul>
<p>
The table matrix can be defined in the following ways:
</p>
<ol>
<li>Explicitly supplied as <strong>parameter matrix</strong> \"table\",
    and the other parameters have the following values:
<pre>
   tableName is \"NoName\" or has only blanks,
   fileName  is \"NoName\" or has only blanks.
</pre></li>
<li><strong>Read</strong> from a <strong>file</strong> \"fileName\" where the matrix is stored as
    \"tableName\". Both text and MATLAB MAT-file format is possible.
    (The text format is described below).
    The MAT-file format comes in four different versions: v4, v6, v7 and v7.3.
    The library supports at least v4, v6 and v7 whereas v7.3 is optional.
    It is most convenient to generate the MAT-file from FreeMat or MATLAB&reg;
    by command
<pre>
   save tables.mat tab1 tab2 tab3
</pre>
    or Scilab by command
<pre>
   savematfile tables.mat tab1 tab2 tab3
</pre>
    when the three tables tab1, tab2, tab3 should be used from the model.<br>
    Note, a fileName can be defined as URI by using the helper function
    <a href=\"modelica://Modelica.Utilities.Files.loadResource\">loadResource</a>.</li>
<li>Statically stored in function \"usertab\" in file \"usertab.c\".
    The matrix is identified by \"tableName\". Parameter
    fileName = \"NoName\" or has only blanks. Row-wise storage is always to be
    preferred as otherwise the table is reallocated and transposed.
    See the <a href=\"modelica://Modelica.Blocks.Tables\">Tables</a> package
    documentation for more details.</li>
</ol>
<p>
When the constant \"NO_FILE_SYSTEM\" is defined, all file I/O related parts of the
source code are removed by the C-preprocessor, such that no access to files takes place.
</p>
<p>
If tables are read from a text file, the file needs to have the
following structure (\"-----\" is not part of the file content):
</p>
<pre>
-----------------------------------------------------
#1
double tab1(5,2)   # comment line
  0   0
  1   1
  2   4
  3   9
  4  16
double tab2(5,2)   # another comment line
  0   0
  2   2
  4   8
  6  18
  8  32
-----------------------------------------------------
</pre>
<p>
Note, that the first two characters in the file need to be
\"#1\" (a line comment defining the version number of the file format).
Afterwards, the corresponding matrix has to be declared
with type (= \"double\" or \"float\"), name and actual dimensions.
Finally, in successive rows of the file, the elements of the matrix
have to be given. The elements have to be provided as a sequence of
numbers in row-wise order (therefore a matrix row can span several
lines in the file and need not start at the beginning of a line).
Numbers have to be given according to C syntax (such as 2.3, -2, +2.e4).
Number separators are spaces, tab (\\t), comma (,), or semicolon (;).
Several matrices may be defined one after another. Line comments start
with the hash symbol (#) and can appear everywhere.
Text files should either be ASCII or UTF-8 encoded, where UTF-8 encoded strings are only allowed in line comments and an optional UTF-8 BOM at the start of the text file is ignored.
Other characters, like trailing non comments, are not allowed in the file.
</p>
<p>
MATLAB is a registered trademark of The MathWorks, Inc.
</p>
</html>"),
    Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Line(points={{-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},{30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},{-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},{60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},{60.0,-40.0}}),
    Line(points={{0.0,40.0},{0.0,-40.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,20.0},{-30.0,40.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,0.0},{-30.0,20.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-20.0},{-30.0,0.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-40.0},{-30.0,-20.0}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Line(points={{-100,0},{-58,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-100,100},{100,64}},
          textString="Univariate constant, linear or cubic Hermite spline table interpolation",
          lineColor={0,0,255}),
        Line(points={{-54,40},{-54,-40},{54,-40},{54,40},{28,40},{28,-40},{-28,
              -40},{-28,40},{-54,40},{-54,20},{54,20},{54,0},{-54,0},{-54,-20},
              {54,-20},{54,-40},{-54,-40},{-54,40},{54,40},{54,-40}}, color={
              0,0,0}),
        Line(points={{0,40},{0,-40}}),
        Rectangle(
          extent={{-54,40},{-28,20}},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,20},{-28,0}},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,0},{-28,-20}},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,-20},{-28,-40}},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-52,56},{-34,44}},
          textString="u",
          lineColor={0,0,255}),
        Text(
          extent={{-22,54},{2,42}},
          textString="y[1]",
          lineColor={0,0,255}),
        Text(
          extent={{4,54},{28,42}},
          textString="y[2]",
          lineColor={0,0,255}),
        Text(
          extent={{0,-40},{32,-54}},
          textString="columns",
          lineColor={0,0,255})}));
end CombiTable1Ds_start;
