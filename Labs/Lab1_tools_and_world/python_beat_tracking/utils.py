import numpy as np
from librosa import frames_to_samples



def beats_to_sample(beats, y, sr):
    """
    Aligning supposed beats to the peak of energy in the y signal

    beats:  np.ndarray
        frames index where beats are supposed to be
    y: np.ndarray
        input signal
    sr: int
        samplerate

    Returns
    y_beat: np.ndarray
        array with 1 when there is a beat
    beats_indices: np.ndarray
        array with indices of the beats
    """
    
    y_beat = np.zeros(y.shape)
    margin=int(0.1 * sr) 
    for beat in frames_to_samples(beats):
        bs_index = beat-margin +np.argmax(np.abs(y[beat-margin:beat+margin]))
        y_beat[bs_index]=1
    return y_beat, np.where(y_beat==1)[0]
    