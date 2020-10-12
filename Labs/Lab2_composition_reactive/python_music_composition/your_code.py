import random

from constants import ID_START



def simple_next(comp):
	if comp.id ==ID_START: # start
		comp.midinote=60
		comp.dur =1
		comp.BPM = 120
		comp.amp = 1
		comp.id=0
	elif comp.id==0:
		comp.midinote=comp.midinote+1
		if comp.midinote==84:
			comp.id=1
	elif comp.id==1:
		comp.midinote -=1
		if comp.midinote==60:
			comp.id = 0
	
def map_(x_in, range_in, range_out):
	x_out = (x_in-range_in[0])/(range_in[1]-range_in[0])
	x_out = range_out[0]+ x_out * (range_out[1]-range_out[0])
	return min(max(x_out, range_out[0]), range_out[1]) 

def gingerbread(comp):
	def next_gingerbread(comp):
		old_x=comp.pars["x"]
		comp.pars["x"]=1-comp.pars["y"]+abs(comp.pars["x"])
		comp.pars["y"]=old_x
	if comp.id ==ID_START: # start
		notes=[60, 62, 64, 67, 69, ]
		comp.pars["notes"] = []
		comp.pars["durs"] = [1, .5, .25, .25]

		for octave in range(-2,3):
			for note in notes:
				comp.pars["notes"].append(octave*12+note)
		comp.pars["range_y"]=[-3, 8]
		comp.pars["y"]=0.1
		comp.pars["x"]=-0.1
		i=map_(comp.pars["y"], 
		               comp.pars["range_y"], 
		               [0, len(comp.pars["notes"])])
		comp.midinote=comp.pars["notes"][int(i)]
		
		comp.dur = comp.pars["durs"][0]
		comp.pars["count"]=1
		comp.BPM = 120
		comp.amp = 1
		comp.id=0
	elif comp.id==0:
		next_gingerbread(comp)
		i=map_(comp.pars["y"], 
		               comp.pars["range_y"], 
		               [0, len(comp.pars["notes"])])
		comp.midinote=comp.pars["notes"][int(i)]
		comp.pars["count"]=comp.pars["count"]%len(comp.pars["durs"])
		comp.dur = comp.pars["durs"][comp.pars["count"]]
		comp.pars["count"]+=1
	
def gingerbread_randomness(comp):
	def next_gingerbread(comp):
		old_x=comp.pars["x"]
		comp.pars["x"]=1-comp.pars["y"]+abs(comp.pars["x"])
		comp.pars["y"]=old_x
	if comp.id ==ID_START: # start
		notes=[60, 62, 64, 67, 69, ]
		comp.pars["notes"] = []
		comp.pars["durs"] = [1, .5, .25, .25]

		for octave in range(-2,3):
			for note in notes:
				comp.pars["notes"].append(octave*12+note)
		comp.pars["range_y"]=[-3, 8]
		comp.pars["y"]=0.1
		comp.pars["x"]=-0.1
		i=map_(comp.pars["y"], 
		               comp.pars["range_y"], 
		               [0, len(comp.pars["notes"])])
		comp.midinote=comp.pars["notes"][int(i)]
		
		comp.dur = comp.pars["durs"][0]
		comp.pars["count"]=1
		comp.pars["offset"]=0
		comp.BPM = 120
		comp.amp = 1
		comp.id=0
	elif comp.id==0:
		next_gingerbread(comp)
		i=map_(comp.pars["y"], 
		               comp.pars["range_y"], 
		               [0, len(comp.pars["notes"])])
		if random.random()<0.1: #5% probability
			comp.pars["offset"]=random.random()*len(comp.pars["notes"])
						

		i=(i+comp.pars["offset"])%len(comp.pars["notes"])
		comp.midinote=comp.pars["notes"][int(i)]
		comp.pars["count"]=comp.pars["count"]%len(comp.pars["durs"])
		comp.dur = comp.pars["durs"][comp.pars["count"]]
		comp.pars["count"]+=1



