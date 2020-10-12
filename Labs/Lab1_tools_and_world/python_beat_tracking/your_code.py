import numpy as np
from librosa.beat import beat_track

def compute_beats(y, sr):
    return beat_track(y, sr=sr)

def first_beat(y, sample_beats):
    size4= sample_beats.size-(sample_beats.size%4) # closest multiple of 4
    beats4 = np.reshape(sample_beats[:size4],(-1,4))
    energy4 = np.mean(np.power(y[beats4],2), axis=0)
    return np.argmax(energy4)

def add_claps(y, sample_beats, i_b, clap, i_c, N_c):
    y_out=y.copy()
    # your code here     
    beats_c=sample_beats[i_b+1::2]
    y_out=y.copy()
    for b_tilde in beats_c:
        y_out[b_tilde-i_c:b_tilde-i_c+N_c] += clap
    # normalization
    y_out /= np.max(np.abs(y_out))

    return y_out

