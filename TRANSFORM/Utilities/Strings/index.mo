within TRANSFORM.Utilities.Strings;
function index

    input String key;
    input String[:] keys;

    output Integer i;
algorithm
    i := Modelica.Math.BooleanVectors.firstTrueIndex({k == key for k in keys});
end index;
