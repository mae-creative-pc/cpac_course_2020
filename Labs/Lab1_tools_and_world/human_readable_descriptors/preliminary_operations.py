# %% Import libraries
import numpy as np
import json
import requests
import os
import urllib.request
os.chdir(os.path.abspath(os.path.dirname(__file__)))

# %% Let's start with the token
# 1) go to https://developer.spotify.com/console/get-audio-analysis-track/?id=06AKEBrKUckW0KREUWRnvT
# 2) press "try it"
# 3) login
# 4) agree 
# 5) execute this cell and give the script the token (see above)
if "token" not in locals(): # if you have not inserted the token 
    token=input("Give me the token")

header={"Authorization": "Bearer %s"%token}
# %% Search api: first info

params={"q": "Staying alive bee gees", "type": "track"}
search_url="https://api.spotify.com/v1/search"
req=requests.get(url=search_url, params=params,headers=header)
assert req.status_code==200, req.content
answer=req.json()
items=answer["tracks"]["items"]
first_result=items[0]
print("First result")
print("Author: %s"%first_result["artists"][0]["name"])
print("Name: %s"%first_result["name"])
print("Preview url: %s"%first_result["preview_url"])
print("Id on spotify: %s"%first_result["id"])

# %% Download a 30-second preview!
urllib.request.urlretrieve(first_result["preview_url"], 'first_result.mp3')

# %% Audio feature APIs

modes=["minor", "major"]
key_tonal=["C","C#", "D","D#","E","F","F#","G","G#","A","A#","B"]

audio_feature_url="https://api.spotify.com/v1/audio-features"
params={"ids":first_result["id"]}
req=requests.get(url=audio_feature_url, params=params, headers=header)
audio_features=req.json()["audio_features"][0]
#print(audio_features)
print("Duration: %.3f seconds"%(audio_features["duration_ms"]/1000))
print("BPM: %d"%audio_features["tempo"])
print("Key: %s-%s"%(key_tonal[audio_features["key"]], 
                   modes[audio_features["mode"]]))

for feature in ["danceability", "energy", "speechiness", "acousticness","liveness","instrumentalness","valence"]:
    print("The %s of the song is %1.f %%"%(feature, 100*audio_features[feature]))

# %%
