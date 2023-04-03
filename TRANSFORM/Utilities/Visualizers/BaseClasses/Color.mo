within TRANSFORM.Utilities.Visualizers.BaseClasses;
type Color = Integer[3] (min=0, max=255) "RGB representation of color"
  annotation (preferedView="text", choices(
    choice={255,0,0} "{255,0,0 }    \"red\"",
    choice={255,255,0} "{255,255,0}   \"yellow\"",
    choice={0,255,0} "{0,255,0}     \"green\"",
    choice={0,255,255} "{0,255,255}   \"cyan\"",
    choice={0,0,255} "{0,0,255}     \"blue\"",
    choice={255,0,255} "{255,0,255}   \"magenta\"",
    choice={0,0,0} "{0,0,0}       \"black\"",
    choice={95,95,95} "{95,95,95} \"dark grey\"",
    choice={175,175,175} "{175,175,175} \"grey\"",
    choice={255,255,255} "{255,255,255} \"white\""));
