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
		# your code
		pass

def map_(x_in, range_in, range_out):
	x_out = (x_in-range_in[0])/(range_in[1]-range_in[0])
	x_out = range_out[0]+ x_out * (range_out[1]-range_out[0])
	return min(max(x_out, range_out[0]), range_out[1]) 

def gingerbread(comp):
	def next_gingerbread(comp):
		# your code
		pass

	if comp.id ==ID_START: # start
		# your code
		
		comp.pars["range_y"]=[-3, 8]
		comp.pars["y"]=0.1
		comp.pars["x"]=-0.1
		i=map_(comp.pars["y"], 
		               comp.pars["range_y"], 
		               [0, len(comp.pars["notes"])])
		comp.midinote=comp.pars["notes"][int(i)]
		
		comp.dur = comp.pars["durs"][0]
		
		comp.id=0
	elif comp.id==0:
		comp.amp=1
		# your code
		
def gingerbread_randomness(comp):
	# your code
	pass
	

