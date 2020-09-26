# %%
import os
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import lfilter
# %%
alpha= 1-np.exp(-1/3)
# %%
sr=1000 #samplerate

t=np.arange(-5,5, 1/sr)
x=np.zeros(t.shape)
x[:np.argmin(np.abs(t))]=1
#x = np.cos(2*np.pi *0.1*t)+np.random.randn(*t.shape)*0.1


plt.figure()

plt.plot(t, x, label="x(n)", lw=8)
for i, tau in enumerate([0.1, 0.5, 1,2,3]):
    alpha=1-np.exp(-1/(tau*sr))
    y_=lfilter([alpha], [1,-(1-alpha)], x)
    plt.plot(t, y_, label="y(n) with $\\tau_s \simeq$ {tau} s".format(tau=tau), lw=i+2, alpha=0.8)

plt.grid()
plt.xlabel("Time [s]")
plt.legend()
plt.show()



# %%
