within TRANSFORM.Media.Interfaces;
package Common "Package with common definitions"
  extends Modelica.Icons.Package;

  type InputChoice = enumeration(
    dT   "(d,T) as inputs",
    hs   "(h,s) as inputs",
    ph   "(p,h) as inputs",
    ps   "(p,s) as inputs",
    pT   "(p,T) as inputs");

  type InputChoiceMixture = enumeration(
    dTX   "(d,T,X) as inputs",
    hsX   "(h,s,X) as inputs",
    phX   "(p,h,X) as inputs",
    psX   "(p,s,X) as inputs",
    pTX   "(p,T,X) as inputs");

  type InputChoiceIncompressible = enumeration(
    ph   "(p,h) as inputs",
    pT   "(p,T) as inputs",
    phX   "(p,h,X) as inputs",
    pTX   "(p,T,X) as inputs");

  function XtoName "A function to convert concentration to substance name"
    extends Modelica.Icons.Function;
    input String substanceName = "";
    input Real[:] composition = {0.0};
    input String delimiter = "|";
    input Boolean debug = false;
    output String result;
protected
    Integer nextIndex;
    Integer inLength;
    String name;
    String rest;
  algorithm
    if noEvent(size(composition,1) <= 0) then
      assert(not debug, "You are passing an empty composition vector, returning name only: "+substanceName, level = AssertionLevel.warning);
      result :=substanceName;
    else
      assert(noEvent(size(composition,1)==1), "Your mixture has more than two components, ignoring all but the first element.", level = AssertionLevel.warning);
      inLength  := Modelica.Utilities.Strings.length(substanceName);
      nextIndex := Modelica.Utilities.Strings.find(substanceName, delimiter);
      if noEvent(nextIndex<2) then
        // Assuming there are no special options
        name   := substanceName;
        rest   := "";
      else
        name   := Modelica.Utilities.Strings.substring(substanceName, 1, nextIndex-1);
        rest   := Modelica.Utilities.Strings.substring(substanceName, nextIndex, inLength);
      end if;
      if noEvent(noEvent(composition[1]<=0) or noEvent(composition[1]>=1)) then
        result := substanceName;
      else
        result := name + "-" + String(composition[1]) + rest;
      end if;
    end if;
    if noEvent(debug) then
      Modelica.Utilities.Streams.print(result+" --- "+substanceName);
    end if;
  end XtoName;

  function CheckCoolPropOptions
    "A function to extract and check the options passed to CoolProp"
    extends Modelica.Icons.Function;
    input String substance = "";
    input Boolean debug = false;
    output String result;

protected
    Integer nextIndex;
    Integer intVal;
    Integer length;
    String name;
    String rest;
    // used to process the option
    String option;
    String value;
    // gather all valid options
    String options;
    // accept these inputs and set the default parameters
    String[:] allowedOptions = {
      "calc_transport",
      "enable_TTSE",
      "enable_BICUBIC",
      "enable_EXTTP",
      "twophase_derivsmoothing_xend",
      "rho_smoothing_xend",
      "debug",
      "hmin",
      "hmax",
      "pmin",
      "pmax"};
    String[:] defaultOptions = {
      "1",
      "0",
      "0",
      "1",
      "0.0",
      "0.0",
      "0",
      "0",
      "0",
      "0",
      "0"};
    // predefined delimiters
    String delimiter1 = "|";
    String delimiter2 = "=";

  algorithm
    if noEvent(debug) then
      Modelica.Utilities.Streams.print("input  = " + substance);
    end if;

    name := substance;

    for i in 1:size(allowedOptions,1) loop
      nextIndex := Modelica.Utilities.Strings.find(name, allowedOptions[i]);     // 0 if not found
      if nextIndex==0 then // not found
        name := name+delimiter1+allowedOptions[i]+delimiter2+defaultOptions[i];
      end if;
    end for;

    nextIndex := Modelica.Utilities.Strings.find(name, delimiter1);     // 0 if not found
    if nextIndex > 0 then
      // separate fluid name and options
      length  := Modelica.Utilities.Strings.length(name);
      rest    := Modelica.Utilities.Strings.substring(name, nextIndex+1, length);
      name    := Modelica.Utilities.Strings.substring(name, 1, nextIndex-1);
      options := "";

      while (nextIndex > 0) loop
        nextIndex := Modelica.Utilities.Strings.find(rest, delimiter1);     // 0 if not found
        if nextIndex > 0 then
          option  := Modelica.Utilities.Strings.substring(rest, 1, nextIndex-1);
          length  := Modelica.Utilities.Strings.length(rest);
          rest    := Modelica.Utilities.Strings.substring(rest, nextIndex+1, length);
        else
          option  := rest;
        end if;
        // now option contains enable_TTSE=1 or enable_TTSE
        intVal    := Modelica.Utilities.Strings.find(option, delimiter2);     // 0 if not found
        if intVal > 0 then // found "="
          length  := Modelica.Utilities.Strings.length(option);
          value   := Modelica.Utilities.Strings.substring(option, intVal+1, length);
          option  := Modelica.Utilities.Strings.substring(option, 1, intVal-1);
        else  // enable option by default
          value   := "1";
        end if;
        // now option contains only enable_TTSE
        intVal :=1;
        for i in 1:size(allowedOptions,1) loop
          if Modelica.Utilities.Strings.compare(option,allowedOptions[i])==Modelica.Utilities.Types.Compare.Equal then
            intVal := intVal - 1;
          end if;
        end for;
        if intVal <> 0 then
          assert(false, "Your option (" + option + ") is unknown.");
        else
          options := options+delimiter1+option+delimiter2+value;
        end if;
      end while;
    else
      // Assuming there are no special options
      name   := substance;
      options:= "";
    end if;

    result := name+options;
    if noEvent(debug) then
      Modelica.Utilities.Streams.print("output = " + result);
    end if;
  end CheckCoolPropOptions;
end Common;
