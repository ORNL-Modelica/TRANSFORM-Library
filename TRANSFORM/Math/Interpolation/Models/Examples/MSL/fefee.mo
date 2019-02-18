within TRANSFORM.Math.Interpolation.Models.Examples.MSL;
function fefee
  output Real y;
protected
constant String tablePath="modelica://TRANSFORM/Resources/data/lookupTables/"
       + "ParaHydrogen" + "/pT/";

  constant Real table[:, :] = fill(0.0, 0, 2);
  constant String tableName="table2D_1"
    "Table name on file or in function usertab (see docu)";
  constant String fileName=Modelica.Utilities.Files.loadResource(tablePath + "test2.txt")
    "File where matrix is stored";
  constant Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  constant Boolean verboseRead=true
    "= true, if info message that file is loading is to be printed";
  constant Real tableOnFileRead = TRANSFORM.Math.Interpolation.MSL.readTableData(tableID, false, verboseRead);
    constant Modelica.Blocks.Types.ExternalCombiTable2D tableID=
      Modelica.Blocks.Types.ExternalCombiTable2D(
        tableName,
        fileName,
        table,
        smoothness) "External table object";

algorithm
    y :=TRANSFORM.Math.Interpolation.MSL.getTableValue(
    tableID,
    1000,
    1e5,
    tableOnFileRead);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end fefee;
