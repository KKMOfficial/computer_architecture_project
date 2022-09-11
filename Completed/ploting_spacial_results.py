from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt

x_file = input("enter x axis file name : ")
y_file = input("enter y axis file name : ")
z_file = input("enter z axis file name : ")
x_list = open(x_file, 'r').read().replace('\t','').replace(' ','').split(',')
y_list = open(y_file, 'r').read().replace('\t','').replace(' ','').split(',')
z_list = open(z_file, 'r').read().replace('\t','').replace(' ','').split(',')

del x_list[-1]
del y_list[-1]
del z_list[-1]

x_list_f = [int(i) for i in x_list]
y_list_f = [int(i) for i in y_list]
z_list_f = [float(i) for i in z_list]
# ax.plot_surface(x_list, y_list, z_list, rstride=1, cstride=1,cmap='viridis', edgecolor='none')

fig = plt.figure()
ax = plt.axes(projection='3d')
ax.contour3D(x_list_f, y_list_f, z_list_f, 50, cmap='binary')
ax.view_init(60, 35)
