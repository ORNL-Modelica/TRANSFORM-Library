within TRANSFORM.Math.Interpolation;
package MSL
  function readTableData "Read table data from ASCII text or MATLAB MAT-file"
    extends Modelica.Icons.Function;
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID;
    input Boolean forceRead = false
      "= true: Force reading of table data; = false: Only read, if not yet read.";
    input Boolean verboseRead
      "= true: Print info message; = false: No info message";
    output Real readSuccess "Table read success";
    external"C" readSuccess = ModelicaStandardTables_CombiTable2D_read(tableID, forceRead, verboseRead)
      annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
    annotation(__ModelicaAssociation_Impure=true);
  end readTableData;

  function getTableValue "Interpolate 2-dim. table defined by matrix"
    extends Modelica.Icons.Function;
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID;
    input Real u1;
    input Real u2;
    input Real tableAvailable
      "Dummy input to ensure correct sorting of function calls";
    output Real y;
    external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)
      annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
    annotation (derivative(noDerivative=tableAvailable) = getDerTableValue);
  end getTableValue;

  function getDerTableValue
    "Derivative of interpolated 2-dim. table defined by matrix"
    extends Modelica.Icons.Function;
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID;
    input Real u1;
    input Real u2;
    input Real tableAvailable
      "Dummy input to ensure correct sorting of function calls";
    input Real der_u1;
    input Real der_u2;
    output Real der_y;
    external"C" der_y = ModelicaStandardTables_CombiTable2D_getDerValue(tableID, u1, u2, der_u1, der_u2)
      annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end getDerTableValue;
end MSL;
