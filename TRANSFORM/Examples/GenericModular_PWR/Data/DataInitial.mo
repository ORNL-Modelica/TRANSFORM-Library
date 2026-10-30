within TRANSFORM.Examples.GenericModular_PWR.Data;
record DataInitial
  extends TRANSFORM.Icons.Record;
//core.coolantSubchannel
parameter SI.Density d_start_core_coolantSubchannel[:] = {729.99456787,707.68652344,683.89465332,658.36236572};
parameter SI.Pressure p_start_core_coolantSubchannel[:] = {12911367.,12907437.,12903607.,12899882.};
parameter SI.Temperature T_start_core_coolantSubchannel[:] = {569.07678223,579.30987549,588.94995117,597.87921143};
parameter SI.SpecificEnthalpy h_start_core_coolantSubchannel[:] = {1317572.25,1374710.125,1431848.125,1488985.875};
//hotLeg
parameter SI.Density d_start_hotLeg[:] = {658.2980957,658.20166016};
parameter SI.Pressure p_start_hotLeg[:] = {12861758.,12810911.};
parameter SI.Temperature T_start_hotLeg[:] = {597.85516357,597.82647705};
parameter SI.SpecificEnthalpy h_start_hotLeg[:] = {1488930.125,1488878.625};
//coldLeg
parameter SI.Density d_start_coldLeg[:] = {751.05932617};
parameter SI.Pressure p_start_coldLeg[:] = {12936737.};
parameter SI.Temperature T_start_coldLeg[:] = {558.34472656};
parameter SI.SpecificEnthalpy h_start_coldLeg[:] = {1260434.125};
//STHX.tube
parameter SI.Density d_start_STHX_tube[:] = {801.91125488,117.77983093,67.53452301,46.95209503,35.55274582,28.22073174,23.06417084,19.21644974,16.3672657,14.60087109};
parameter SI.Pressure p_start_STHX_tube[:] = {3928153.5,3925242.75,3913008.75,3891694.,3861035.5,3820542.75,3769524.25,3707093.75,3632158.5,3500001.};
parameter SI.Temperature T_start_STHX_tube[:] = {521.17053223,522.37127686,522.19030762,521.87188721,521.41033936,520.79528809,520.01159668,519.03967285,547.73358154,573.36859131};
parameter SI.SpecificEnthalpy h_start_STHX_tube[:] = {1076191.5,1333470.,1550688.375,1770644.875,1997392.25,2233793.25,2481958.25,2743505.5,2901873.5,2978967.5};
//STHX.shell
parameter SI.Density d_start_STHX_shell[:] = {662.02679443,669.76708984,682.17218018,693.54766846,704.05200195,713.84399414,723.09503174,732.00646973,742.28991699,750.97668457};
parameter SI.Pressure p_start_STHX_shell[:] = {12810909.,12816239.,12819835.,12823497.,12827221.,12831002.,12834836.,12838720.,12842652.,12848634.};
parameter SI.Temperature T_start_STHX_shell[:] = {596.58215332,593.97235107,589.5078125,585.11022949,580.78710938,576.52716064,572.29638672,568.02947998,562.8692627,558.31341553};
parameter SI.SpecificEnthalpy h_start_STHX_shell[:] = {1480592.25,1463564.625,1435439.875,1408754.25,1383334.,1358952.,1335300.375,1311943.25,1284277.5,1260316.375};
//inletPlenum
parameter SI.Density d_start_inletPlenum = 751.037;
parameter SI.Pressure p_start_inletPlenum = 1.29207e+07;
parameter SI.Temperature T_start_inletPlenum = 558.343;
parameter SI.SpecificEnthalpy h_start_inletPlenum = 1.26043e+06;
//outletPlenum
parameter SI.Density d_start_outletPlenum = 658.335;
parameter SI.Pressure p_start_outletPlenum = 1.28884e+07;
parameter SI.Temperature T_start_outletPlenum = 597.874;
parameter SI.SpecificEnthalpy h_start_outletPlenum = 1.48899e+06;
//core.fuelModel.region_1
parameter Real Ts_start_core_fuelModel_region_1[:,:] = {{833.46563721,844.07550049,853.94927979,862.88238525},{794.86474609,805.08477783,814.59460449,823.19750977},{687.40283203,696.56268311,705.08319092,712.78900146}};
//core.fuelModel.region_2
parameter Real Ts_start_core_fuelModel_region_2[:,:] = {{687.40283203,696.56268311,705.08319092,712.78900146},{647.13977051,656.53381348,665.26824951,673.16430664},{606.20654297,615.85943604,624.82983398,632.93554688}};
//core.fuelModel.region_3
parameter Real Ts_start_core_fuelModel_region_3[:,:] = {{606.20654297,615.85943604,624.82983398,632.93554688},{602.0279541,611.70294189,620.69366455,628.81744385},{598.11029053,607.80609131,616.81585693,624.95678711}};
//STHX.tubeWall
parameter SI.Temperature T_start_STHX_tubeWall[:,:] = {{526.4765625,526.28808594,537.38659668,541.44897461,544.92095947,548.05151367,550.99615479,553.85308838,572.65716553,586.29663086},{536.44354248,537.79101562,547.02868652,551.18432617,554.93139648,558.46380615,561.90209961,565.32196045,579.52258301,589.61157227}};
//pressurizer
parameter SI.Pressure p_start_pressurizer = 1.28109e+07;
parameter SI.Length level_start_pressurizer = 1.18567;
parameter SI.SpecificEnthalpy h_start_pressurizer = 1.47822e+06;
//pressurizer_tee
parameter SI.Density d_start_pressurizer_tee = 658.202;
parameter SI.Pressure p_start_pressurizer_tee = 1.28109e+07;
parameter SI.Temperature T_start_pressurizer_tee = 597.826;
parameter SI.SpecificEnthalpy h_start_pressurizer_tee = 1.48888e+06;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                Text(
          lineColor={0,0,0},
          extent={{-100,-90},{100,-70}},
          textString="GenericModule")}),                         Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DataInitial;
