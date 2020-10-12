# %% Import what we need

import os
import json
import time
import requests
import numpy as np
os.chdir(os.path.abspath(os.path.dirname(__file__)))
import your_code
CREATE_SPOTIFY_PLAYLIST = True 
# Set it to False and I will create a long file instead

# %% Get the token
# 1) go to https://developer.spotify.com/console/post-playlists/
# 2) press "try it"
# 3) remember to include playlist-modify-private 
# 4) login
# 5) agree 
# 6) execute this cell and give the script the token (see above)
if "token" not in locals(): # if you have not inserted the token 
    token=input("Give me the token\n")
header={"Authorization": "Bearer %s"%token}


# %% Search the songs

assert os.path.exists("list_of_songs.json"), "Please put here a list of songs"
with open("list_of_songs.json",'r') as fp:
    songs=json.load(fp)["songs"]

# %% Get the audio features
search_url="https://api.spotify.com/v1/search"
audio_feature_url="https://api.spotify.com/v1/audio-features"
audio_features=[]

for song in songs:
    params={"q": song["artist"]+" "+song["title"], "type": "track"}
    req=requests.get(url=search_url, params=params,headers=header)
    assert req.status_code==200, req.content
    answer=req.json()    
    results=answer["tracks"]["items"]
    if len(results)==0:
        print("I couldn't find %s"%params["q"])
        continue    
    params={"ids":results[0]["id"]}
    req=requests.get(url=audio_feature_url, params=params, headers=header)
    assert req.status_code==200, req.content
    audio_features_song=req.json()["audio_features"][0]
    audio_features_song["title"]=results[0]["name"]
    audio_features_song["artist"]=results[0]["artists"][0]["name"]
    audio_features_song["preview_url"]=results[0]["preview_url"]
    audio_features.append(audio_features_song)
    time.sleep(1) # wait 1 second between the questions
# %% Now let's create some way to organize them!

#shuffled_songs=your_code.sort_songs(audio_features)
danceability=[]
for song in audio_features:
    danceability.append(song["danceability"])
danceability=np.array(danceability)
dance_idxs = np.argsort(danceability)
ramp_up=dance_idxs[1::2]
ramp_down=dance_idxs[0::2][::-1]

shuffled_songs=[]
for idx in ramp_up:
    shuffled_songs.append(audio_features[idx])
for idx in ramp_down:
    shuffled_songs.append(audio_features[idx])
# %% Create the playlist
# Go to https://open.spotify.com/ , top right corner, press "Account"
# look at your username or user_id
name_playlist=input("What's the name of the playlist you want to create?\n")
if CREATE_SPOTIFY_PLAYLIST:
    user_id=input("What's your username?\n")

    params={"name":name_playlist, "description": "made during cpac!"}


# %% Actually create the playlist
if CREATE_SPOTIFY_PLAYLIST:
    create_playlist_url="https://api.spotify.com/v1/users/{user_id}/playlists".format(user_id=user_id)
    req=requests.post(url=create_playlist_url, json=params, headers=header)
    assert req.status_code==201, req.content
    playlist_info=req.json()
    print("Playlist created with url %s"%playlist_info["external_urls"]["spotify"])
# %% Populating the playlist
# Doc at https://developer.spotify.com/documentation/web-api/reference/playlists/add-tracks-to-playlist/
if CREATE_SPOTIFY_PLAYLIST:
    add_item_playlist_url="https://api.spotify.com/v1/playlists/{playlist_id}/tracks".format(playlist_id=playlist_info["id"])
    uris=[]
    for song in shuffled_songs:
        uris.append(song["uri"])
    params={"uris":uris, }
    req=requests.post(url=add_item_playlist_url, json=params, headers=header)
    assert req.status_code==201, req.content
    playlist_info_songs=req.json()

# %% Create a fake playlist as a long long file
if not CREATE_SPOTIFY_PLAYLIST:
    from librosa import load
    import urllib.request
    import numpy as np
    import soundfile as sf
    import subprocess

    SR=16000
    if not os.path.exists("tmpdir"):
        os.makedirs("tmpdir")
    songs_data=[] # Here I will place the data of the loaded songs
    for s, song in enumerate(shuffled_songs):
        if song["preview_url"] is None: 
            print("Sorry, I cannot download %s"%(song["title"]))
            continue
        if not os.path.exists("tmpdir/%d.mp3"%s): # I download it only if not present
            urllib.request.urlretrieve(song["preview_url"], "tmpdir/%d.mp3"%s)
        x, sr=load("tmpdir/%d.mp3"%s, sr=SR) 
        songs_data.append(x)
    
    fade_dur=int(SR/2) # half-second cross fade

    # I will put all the songs in this final array whose length is
    # 30 seconds (each preview) * samplerate * how many songs + 2 fade duration just in case
    y=np.zeros((int(len(songs_data)*(30*SR)+2*fade_dur),)) 

    k=fade_dur # I leave one fade duration of beginning
    for x in songs_data:
        x[:fade_dur]*=np.linspace(0,1,fade_dur) # this is the fade in
        x[-fade_dur:]*=np.linspace(1,0,fade_dur) # this is the fade out
        y[k:k+x.size]+=x # by summing I make the cross-fade
        k=k+x.size-fade_dur 
        # note I move the cursor by the duration of each song 
        # MINUS the fade duration, so I will achieve the cross fade
    
    # saving the file
    sf.write("%s.wav"%name_playlist, y, SR, format="wav")
    
    # converting it to mp3
    subprocess.call("ffmpeg -i %s.wav %s.mp3"%(name_playlist,name_playlist))
    
    # if the convertion was successful, I can remove the wavfile
    if os.path.exists("%s.mp3"%name_playlist):
        os.remove("%s.wav"%name_playlist)

