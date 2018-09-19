within TRANSFORM.Units.Conversions.Functions;
package PrefixMultipliers "Conversions for prefix multipliers. SI unit is [1]"

  function to_yocto "yocto: [1] -> [1e-24] | - -> y"
    extends BaseClasses.to;

  algorithm
    y := u/1e-24;
  end to_yocto;

  function from_yocto "yocto: [1e-24] -> [1] | y -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-24;
  end from_yocto;

  function to_zepto "zepto: [1] -> [1e-21] | - -> z"
    extends BaseClasses.to;

  algorithm
    y := u/1e-21;
  end to_zepto;

  function from_zepto "zepto: [1e-21] -> [1] | z -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-21;
  end from_zepto;

  function to_atto "atto: [1] -> [1e-18] | - -> a"
    extends BaseClasses.to;

  algorithm
    y := u/1e-18;
  end to_atto;

  function from_atto "atto: [1e-18] -> [1] | a -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-18;
  end from_atto;

  function to_femto "femto: [1] -> [1e-15] | - -> f"
    extends BaseClasses.to;

  algorithm
    y := u/1e-15;
  end to_femto;

  function from_femto "femto: [1e-15] -> [1] | f -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-15;
  end from_femto;

  function to_pico "pico: [1] -> [1e-12] | - -> p"
    extends BaseClasses.to;

  algorithm
    y := u/1e-12;
  end to_pico;

  function from_pico "pico: [1e-12] -> [1] | p -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-12;
  end from_pico;

  function to_nano "nano: [1] -> [1e-9] | - -> n"
    extends BaseClasses.to;

  algorithm
    y := u/1e-9;
  end to_nano;

  function from_nano "nano: [1e-9] -> [1] | n -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-9;
  end from_nano;

  function to_micro "micro: [1] -> [1e-6] | - -> mu"
    extends BaseClasses.to;

  algorithm
    y := u/1e-6;
  end to_micro;

  function from_micro "micro: [1e-6] -> [1] | mu -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-6;
  end from_micro;

  function to_milli "milli: [1] -> [1e-3] | - -> m"
    extends BaseClasses.to;

  algorithm
    y := u/1e-3;
  end to_milli;

  function from_milli "milli: [1e-3] -> [1] | m -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-3;
  end from_milli;

  function to_centi "centi: [1] -> [1e-2] | - -> c"
    extends BaseClasses.to;

  algorithm
    y := u/1e-2;
  end to_centi;

  function from_centi "centi: [1e-2] -> [1] | c -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-2;
  end from_centi;

  function to_deci "deci: [1] -> [1e-1] | - -> d"
    extends BaseClasses.to;

  algorithm
    y := u/1e-1;
  end to_deci;

  function from_deci "deci: [1e-1] -> [1] | d -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e-1;
  end from_deci;

  function to_hecto "hecto: [1] -> [1e2] | - -> h"
    extends BaseClasses.to;

  algorithm
    y := u/1e2;
  end to_hecto;

  function from_hecto "hecto: [1e2] -> [1] | h -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e2;
  end from_hecto;

    function to_kilo "kilo: [1] -> [1e3] | - -> k"
    extends BaseClasses.to;

    algorithm
    y := u/1e3;
    end to_kilo;

  function from_kilo "kilo: [1e3] -> [1] | k -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e3;
  end from_kilo;

    function to_mega "mega: [1] -> [1e6] | - -> M"
    extends BaseClasses.to;

    algorithm
    y := u/1e6;
    end to_mega;

  function from_mega "mega: [1e6] -> [1] | M -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e6;
  end from_mega;

    function to_giga "giga: [1] -> [1e9] | - -> G"
    extends BaseClasses.to;

    algorithm
    y := u/1e9;
    end to_giga;

  function from_giga "giga: [1e9] -> [1] | G -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e9;
  end from_giga;

    function to_tera "tera: [1] -> [1e12] | - -> T"
    extends BaseClasses.to;

    algorithm
    y := u/1e12;
    end to_tera;

  function from_tera "tera: [1e12] -> [1] | T -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e12;
  end from_tera;

    function to_peta "peta: [1] -> [1e15] | - -> P"
    extends BaseClasses.to;

    algorithm
    y := u/1e15;
    end to_peta;

  function from_peta "peta: [1e15] -> [1] | P -> -"
    extends BaseClasses.to;

  algorithm
    y := u*1e15;
  end from_peta;
end PrefixMultipliers;
