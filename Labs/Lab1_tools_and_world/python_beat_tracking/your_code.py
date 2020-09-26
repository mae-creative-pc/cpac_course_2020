import numpy as np
def compute_beats(y, sr):
    return None 

def first_beat(y, sample_beats):
    energy4=[4,3,2,1]
    # your code here
    return np.argmax(energy4)

def add_claps(y, sample_beats, i_b, clap, i_c, N_c):
    y_out=y.copy()
    # your code here     
    
    # normalization
    y_out /= np.max(np.abs(y_out))

    return y_out

