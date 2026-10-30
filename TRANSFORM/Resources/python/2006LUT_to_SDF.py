# -*- coding: utf-8 -*-
"""
Created on Tue Apr 03 11:06:37 2018

@author: vmg
"""

import sdf
import numpy as np

# Load 2006 LUT for interpolation
# 2006 Groeneveld Look-Up Table as presented in 
# "2006 CHF Look-Up Table", Nuclear Engineering and Design 237, pp. 190-1922.

# This file requires the file 2006LUTdata.txt

# Pressure range [MPa] from 2006 LUT, convert to [Pa]
P = np.array((0.10,0.30,0.50,1.0,2.0,3.0,5.0,7.0,10.0,12.0,14.0,16.0,18.0,20.0,21.0))*1e6

# Mass Flux range [kg/m^2-s] from 2006 .LUT.
G = np.array((0.,50.,100.,300.,500.,750.,1000.,1500.,2000.,2500.,3000.,3500.,4000.,4500.,5000.,5500.,6000.,6500.,7000.,7500.,8000.))

# Quality range from 2006 LUT
x = np.array((-0.50,-0.40,-0.30,-0.20,-0.15,-0.10,-0.05,0.00,0.05,0.10,0.15,0.20,0.25,0.30,0.35,0.40,0.45,0.50,0.60,0.70,0.80,0.90,1.00))

# Critical heat flux [kW/m^2] from 2006 LUT, convert to [W/m^2]
q_raw=np.loadtxt('../Data/2006LUTdata.txt')*1e3

# Convert the imported array into a (MxNxQ) where:
#   M is number of mass flux divisions
#   N is number of quality divisions
#   Q is number of pressure divisions
lenG = len(G)
lenx = len(x)
lenP = len(P)
q = np.zeros((lenG,lenx,lenP))
for i in xrange(lenG):
    for j in xrange(lenx):
        for k in xrange(lenP):
            q[i,j,k] = q_raw[i + k*lenG,j]    
            
# Create the datasets:
ds_G = sdf.Dataset('G', data=G, unit='kg/(m2.s)', is_scale=True, display_name='Mass Flux')
ds_x = sdf.Dataset('x', data=x, unit='1', is_scale=True, display_name='Quality')
ds_P = sdf.Dataset('P', data=P, unit='Pa', is_scale=True, display_name='Pressure')
ds_q = sdf.Dataset('q', data=q, unit='W/m2', scales=[ds_G,ds_x,ds_P])

# Create the root group and write the file:
g = sdf.Group('/', comment='2006 CHF LUT', datasets=[ds_G,ds_x,ds_P,ds_q])
sdf.save('../Data/2006LUT.sdf', g)