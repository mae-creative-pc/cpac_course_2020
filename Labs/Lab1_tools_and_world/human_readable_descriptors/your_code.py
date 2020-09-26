import numpy as np

def sort_songs(audio_features):
    """"Receive audio features and sort them according to your criterion"

    Args:
        audio_features (list of dict): List of songs with audio features

    Returns:
        list of dict: the sorted list
    """
    sorted_songs=[]

    # Random shuffle: replace it!
    
    random_idxs=np.random.permutation(len(audio_features))
    for idx in random_idxs:
        sorted_songs.append(audio_features[idx])
    # your code here
    
    return sorted_songs