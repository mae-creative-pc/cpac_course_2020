	
import time
import numpy as np
from pythonosc import udp_client
from threading import Thread, Event
import platform
import sys
import ctypes, sys


from your_code import simple_next, gingerbread_randomness, gingerbread
from constants import ID_START

def note_sleep(BPM, beats):
	time.sleep(beats*60./BPM)
def beats_to_seconds(BPM, beats):
	return beats*60./BPM

class InstrOSC():
	def __init__(self,ip="127.0.0.1",  port=57121, name="/note"):
		self.name=name
		self.client = udp_client.SimpleUDPClient(ip, port)

	def send(self, *data):		
		print("sending %s"%str(data))
		self.client.send_message(self.name, data)
    
class Composition:
	def __init__(self):
		self.id=ID_START
		self.midinote=ID_START
		self.dur=0
		self.amp=0
		self.BPM=120.
		self.pars={}
	def __str__(self):
		return "\n\t".join(["Id: %d"%self.id, 
								"midinote: %d"%self.midinote, 
								"duration: %s beats"%str(self.dur),
								"amplitude: %.1f"%self.amp,
								"BPM: %d"%self.BPM,
								"pars: %s"%str(self.pars)])
class Agent(Thread):
	def __init__(self, port, name, BPM, func, ):
		self.comp=Composition()
		super().__init__(daemon=True, target=self.action)
		self.instr=InstrOSC(port=port, name=name)				
		self.comp.BPM=BPM
		self.func=func
		self.stop=Event()
		self.stop.clear()
		#self.planning()
	
	def planning(self):
		self.func(self.comp)
	def kill(self):
		# before killing it, I set the amplitude to 0
			
		self.stop.set()

	def action(self):
		while not self.stop.is_set():
			self.planning()
			print(str(self.comp))			
			self.instr.send("note", self.comp.midinote,							
							self.comp.amp)
			note_sleep(self.comp.BPM, self.comp.dur)
		self.instr.send("note", self.comp.midinote,							
							0)



def is_admin():
	try:
		return ctypes.windll.shell32.IsUserAnAdmin()
	except:
		return False
if __name__=="__main__":
	if not is_admin() and "windows" in platform.platform().lower():	    
		# Re-run the program with admin rights
		ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)

	n_agents=1
	agents=[_ for _ in range(n_agents)]
	#agents[0] = Agent(57120, "/note", 60, simple_next)
	agents[0] = Agent(57120, "/note_effect", 60, gingerbread_randomness)
	#agents[0] = Agent(57120, "/note", 60, gingerbread)

	input("Press any key to start \n")
	for agent in agents:
		agent.start()
	# USE CTRL+C to exit 
	try:
		while True:
			time.sleep(10)
	except: 
		
		for agent in agents:
			  
			agent.kill()
			agent.join()
		sys.exit()

# %%