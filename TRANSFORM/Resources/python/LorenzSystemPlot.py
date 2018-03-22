# -*- coding: utf-8 -*-
"""
Created on Thu Jul 27 10:55:11 2017

@author: vmg
"""

import outputFiles as ofi
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

load_mat = '..\LorenzSystem_Test.mat'
saveFigure = False
# Data File Creation
r = ofi.Reader(load_mat, 'dymola')

# Data file data (i.e., time dependent data)
(time, xs) = r.values('lorenzSystem.x')
ys = r.values('lorenzSystem.y')[1]
zs = r.values('lorenzSystem.z')[1]

fig = plt.figure()
ax = fig.gca(projection='3d')

ax.plot(xs, ys, zs, lw=0.5)
ax.set_xlabel("X Axis")
ax.set_ylabel("Y Axis")
ax.set_zlabel("Z Axis")
ax.set_title("Lorenz System")

plt.show()

if saveFigure:
	fig.savefig('LorenzSystemFig.png',dpi=400)