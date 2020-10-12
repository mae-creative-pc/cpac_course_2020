# %%
import os
import numpy as np
import matplotlib.pyplot as plt
import soundfile as sf
freqs_base = 2*np.array([130.81, 146.83,164.81, 196.00, 220.00])
# C3, D3, E3, G3, A3

sr=16000 # samplerate

attack_time=0.01
decay_time=0.02
sustain_time=0.
release_time=0.02

open_close_time=0.1

DUR = 0.2 # seconds

def create_env_adsr():
    dur=max(DUR, 1.01*(attack_time+decay_time+sustain_time+release_time))
    env=np.zeros((int(dur*sr),)) #envelope
    attack=np.linspace(0,1,int(attack_time*sr))
    attack=np.exp(attack)
    attack-=np.min(attack)
    attack/=np.max(attack)
    
    decay=np.linspace(1,0,int(decay_time*sr))
    decay=np.exp(decay)
    decay-=np.min(decay)
    decay/=2*np.max(decay)
    decay+=0.5

    sustain=0.5*np.ones(int(sustain_time*sr))
    
    release=np.linspace(1,0,int(release_time*sr))
    release=np.exp(release)
    release-=np.min(release)
    release/=2*np.max(release)
    
    adsr=np.concatenate([attack, decay, sustain, release])
    adsr+=np.random.randn(adsr.size)*0.001
    env[:adsr.size]=np.clip(adsr,0,1)
    return env

def create_env_cos():
    
    dur=max(DUR,1.01*open_close_time)
    env=np.zeros((int(dur*sr),)) #envelope
    N=int(sr*open_close_time)
    print(N)
    env[:N]=np.sin(np.linspace(0, np.pi, N))
    return env

if __name__=="__main__":
    freqs=[]
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    if not (os.path.exists("sounds")):
        os.makedirs("sounds")
    for octave in range(1,4):
        freqs.extend((freqs_base*octave).tolist())
    
    env= create_env_adsr()
    t= np.arange(0, env.size)/sr    
    
    plt.plot(t, env)
    np.random.shuffle(freqs)
    num_harmonics=1+int(np.floor(sr/2 / max(freqs)))
    print(num_harmonics)
    #harmonics=[0.5, 0.25, 0.125, 0.06, 0.03, 0.015]
    for f, freq in enumerate(freqs):
        fn_out="sounds/%.2fHz.wav"%(freq)        
        sample=np.cos(2*np.pi*t*freq)
        #for h, harm in enumerate(harmonics):            
        for h in range(2,num_harmonics):
            amp=1/(2**(2*(h-1)))
            rand_phase=2*np.pi*np.random.randint(10000)/10000.
            sample+=amp*np.cos(2*np.pi*t*h*freq+rand_phase)
        sample*=env

        sf.write(fn_out, 0.707*sample/np.max(np.abs(sample)), sr)

# %%
