# -*- coding: utf-8 -*-
"""
Created on Tue Apr 03 11:06:37 2018

@author: vmg
"""

import sdf
import numpy as np

# Groeneveld, D.C., Leung, L.K.H., Vasic’, A.Z., Guo, Y.J., Cheng, S.C.,
# "A look-up table for fully developed film-boiling heat transfer".
# Nuclear Engineering and Design. 225, 83–97 (2003). doi:10.1016/S0029-5493(03)00149-3

# This file requires the file 2001LUTFBdata.txt

# Pressure range [MPa] from LUT, convert to [Pa]
P = np.array((0.1,0.2,0.5,1,2,5,7,9,10,11,13,17,20))*1e6

# Mass Flux range [kg/m^2-s] from LUT
G = np.array((0.,50.,100.,200.,500.,1000.,1500.,2000.,3000.,4000.,5000.,6000.,7000.))

# Quality range [-] from LUT 
x = np.array((-0.2,-0.1,-0.05,0,0.05,0.1,0.2,0.4,0.6,0.8,1,1.2,1.4,1.6,1.8,2))

# deltaT = Twall - Tsat [K] from LUT
dT = np.array((50.,100.,200.,300.,400.,500.,600.,750.,900.,1050.,1200.))

# Film boiling heat transfer coefficient [W/m^2] from LUT
alpha_raw=np.loadtxt('../Data/2001LUTFBdata.txt')

# Convert the imported array into a (MxNxQxR) where:
#   M is number of mass flux divisions
#   N is number of quality divisions
#   Q is number of pressure divisions
#   R is number of deltaT divisions
lenG = len(G)
lenx = len(x)
lendT = len(dT)
lenP = len(P)
alpha = np.zeros((lenx,lendT,lenG,lenP))

for i in xrange(lenx):
    for j in xrange(lendT):
        for k in xrange(lenG):
            for r in xrange(lenP):
                alpha[i,j,k,r] = alpha_raw[i + k*lenx + r*lenG*lenx,j]    
            
# Create the datasets:
ds_x = sdf.Dataset('x', data=x, unit='1', is_scale=True, display_name='Quality')
ds_dT = sdf.Dataset('dT', data=dT, unit='K', is_scale=True, display_name='deltaT')
ds_G = sdf.Dataset('G', data=G, unit='kg/(m2.s)', is_scale=True, display_name='Mass Flux')
ds_P = sdf.Dataset('P', data=P, unit='Pa', is_scale=True, display_name='Pressure')
ds_alpha = sdf.Dataset('alpha', data=alpha, unit='W/(m2.K)', scales=[ds_x,ds_dT,ds_G,ds_P])

# Create the root group and write the file:
g = sdf.Group('/', comment='2001 FBCoef LUT', datasets=[ds_x,ds_dT,ds_G,ds_P,ds_alpha])
sdf.save('../Data/2001LUTFB.sdf', g)

sdf.save('../Data/2006LUT.sdf', g)