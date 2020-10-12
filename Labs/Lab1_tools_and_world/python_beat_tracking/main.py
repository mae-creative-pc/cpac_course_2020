# %% Import libraries

import numpy as np
import os
import librosa
from librosa import load, frames_to_samples
import soundfile as sf
import matplotlib.pyplot as plt
from librosa.onset import onset_strength


os.chdir(os.path.abspath(os.path.dirname(__file__)))
# This is useful to change the current directory to the one where there is the file
import your_code
import utils

DATA_DIR="../../../data"
assert os.path.exists(DATA_DIR), "wrong data dir"
# %% Define filenames
filename_in=os.path.join(DATA_DIR, "wdym.mp3") # put whatever you like
filename_clap=os.path.join(DATA_DIR, "clap.mp3") # put whatever you like
filename_out=os.path.join(DATA_DIR, "wdym_claps.wav") # 

# %% Load input file

SR=16000
y, sr= load(filename_in, sr=SR)
t=np.arange(y.size)/SR
# %% 1) Compute beats
bpm, beats=your_code.compute_beats(y, sr=SR)
y_beats,sample_beats=utils.beats_to_sample(beats, y, sr=SR)

# %% See if beats are correct
plt.figure()
plt.plot(t, y, label="y")
plt.scatter(t[sample_beats], y[sample_beats], label="beats", color="red")
plt.xlim([0, 5])
plt.xlabel("Time [s]")
plt.legend()
plt.show()
# %% 2) find the first beat for each bar, assuming we have a 4/4
i_b=your_code.first_beat(y, sample_beats)


# %% put a clap
clap, sr_clap=load(filename_clap, sr=SR)
i_c = np.argmax(np.abs(clap)) # the actual onset
N_c = clap.size

y_out = your_code.add_claps(y, sample_beats, i_b, clap, i_c, N_c)
# %% show the difference
plt.figure()
plt.subplot(2,1,1)
plt.plot(t, y)
plt.xlim([0, 5])
plt.xlabel("Time [s]")
plt.title("$y(n)$")
plt.subplot(2,1,2)
plt.plot(t, y_out)
plt.title("$\\tilde{y}(n)$")
plt.xlim([0, 5])
plt.xlabel("Time [s]")

plt.show()

# %% 4 Write the file
sf.write(filename_out, y_out, SR)

