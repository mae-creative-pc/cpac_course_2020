# %%
import numpy as np
import matplotlib.pyplot as plt
plt.style.use("seaborn-poster")
#%%
N_STEPS=10000
x=np.zeros((N_STEPS))
y=np.zeros((N_STEPS))
x[0]=-0.1
y[0]=0.1
for n in range(N_STEPS-1):
    x[n+1]= 1-y[n]+abs(x[n])
    y[n+1] = x[n]
# %%
if N_STEPS>10000:
    print(x.min(), x.max(), y.min(), y.max())
else:
    plt.figure()
    plt.scatter(x, y, s=3)
    plt.title("Gingerbread function with x[0]={x0} and y[0]={y0}".format(x0=x[0], y0=y[0]))

# %%
