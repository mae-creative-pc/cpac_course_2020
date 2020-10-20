import numpy as np
import random
import os
import re
import librosa
import soundfile as sf
os.chdir(os.path.dirname(os.path.abspath(__file__)))
from your_code import *

note_durs={"h":0.5, # half-measure
           "q":0.25, # quarter-measure
           "o":0.125, # octave-measure
           "w": 1, # whole measure
           "tq": 0.5/3, # triplet of quarter
           "th": 1/3, # triplet of half-notes
           "to": 0.25/3 # triplets of octaves
}
for n in list(note_durs.keys()):# so its computed just once
    note_durs["$"+n]=note_durs[n] # $ + smth = pause

def random_elem_in_list(list_of_elems):
    return list_of_elems[random.randint(0,len(list_of_elems)-1)]

class Grammar_Sequence:
    def __init__(self, grammar):
        self.grammar=grammar
        self.grammar_keys=list(grammar.keys())
        self.N=len(self.grammar_keys)
        self.sequence=""
       
    def find_symbol(self, symbol):
        return [m.start() for m in re.finditer(symbol, self.sequence)]
    def replace(self, index, symbol, convert_to):
        len_symbol=len(symbol)
        self.sequence=self.sequence[:index]+convert_to+self.sequence[index+len_symbol:]
    def convert_sequence(self):        
        symbol=random_elem_in_list(self.grammar_keys)
        while symbol not in self.sequence:
            symbol=random_elem_in_list(self.grammar_keys)
            
        index=random_elem_in_list(self.find_symbol(symbol))
        convert_to= random_elem_in_list(self.grammar[symbol])
        self.replace(index, symbol, convert_to)
        
    def create_sequence(self, start_sequence):
        self.sequence=start_sequence
        sequence_transformation=[start_sequence]
        while (self.sequence!=self.sequence.lower()):
            self.convert_sequence()
            sequence_transformation.append(self.sequence)
        return sequence_transformation

class Composer():
    def __init__(self, fn, sr=-1, BPM=120):
        if sr==-1:
            self.sample, self.sr =  librosa.load(fn)     
        else:
            self.sample, self.sr =  librosa.load(fn,sr=sr)         
        self.sampleN=self.sample.size
        self.BPM=BPM
        self.q_bpm=60/self.BPM
        self.m_bpm=4*self.q_bpm
        self.sequence=[]
    def split_sequence(self, sequence):
        k=0
        symbol_sequence=[]
        note_sequence=[]
        while k<len(sequence):
            if sequence[k] in "$t":
                symbol=sequence[k:k+2]
                k+=2
            else:
                symbol=sequence[k]
                k+=1
            symbol_sequence.append(symbol)
            
            note_sequence.append(note_durs[symbol])
        return note_sequence, symbol_sequence
    def compute_duration(self, notes_sequence):
        duration_in_notes=0
        for note in notes_sequence:
            duration_in_notes+=note
        return duration_in_notes        
    def create_sequence(self, sequence):
        notes_sequence, symbol_sequence=self.split_sequence(sequence)
        duration_in_notes=self.compute_duration(notes_sequence)
        
        duration_in_seconds=duration_in_notes*self.m_bpm
        self.sequence=np.zeros((int(duration_in_seconds*self.sr),))
        idx=0
        for note, symbol in zip(notes_sequence, symbol_sequence):
            if not symbol.startswith("$"):
                if self.sequence.size > idx+self.sampleN: 
                    self.sequence[idx:idx+self.sampleN]+=self.sample
                else:
                    K=self.sequence.size-idx
                    self.sequence[idx:]+=self.sample[:K]
                    self.sequence[:self.sampleN-K]+=self.sample[K:]
            idx+=int(note*self.sr*self.m_bpm)
    def write(self, fn_out="out.wav", repeat=1, write=True):
        sequence_to_write=np.repeat(self.sequence, (repeat,))
        if write:
            sf.write(fn_out, sequence_to_write, self.sr)
        else:
            return sequence_to_write
def write_mix(compositions, fn_out, repeat=1, gains=None):
    if gains is None:
        gains=[1/len(compositions) for _ in compositions]
    sequence_to_write=gains[0]*compositions[0].write(repeat=repeat, write=False)
    for i in range(1, len(compositions)):
        sequence_to_add=gains[i]*compositions[i].write(repeat=repeat, write=False)
        N_max=max(sequence_to_write.size, sequence_to_add.size)
        sequence_to_write=np.concatenate([sequence_to_write, 
                                          np.zeros((N_max-sequence_to_write.size))])+\
                          np.concatenate([sequence_to_add, 
                                          np.zeros((N_max-sequence_to_add.size))])
                            
    if np.max(np.abs(sequence_to_write))>1:
        sequence_to_write=0.707*sequence_to_write/np.max(np.abs(sequence_to_write))
    sf.write(fn_out, sequence_to_write, compositions[0].sr)

if __name__=="__main__":
    EX=6
    Cs=[]
    C=None
    NUM_MEASURES=8
    START_SEQUENCE="M"*NUM_BEATS# 16 beats
    MONO_COMPOSITION=EX<7
    if EX==1:
        G=Grammar_Sequence(basic_grammar)        
        fn_out="basic_composition.wav"
    elif EX==2:
        G=Grammar_Sequence(octave_grammar)
        fn_out="octave_composition.wav"
    elif EX==3:
        G=Grammar_Sequence(triplet_grammar)
        fn_out="triplets_composition.wav"
    elif EX==4:
        G=Grammar_Sequence(syncopated_grammar)
        fn_out="syncop_composition.wav"
    elif EX==5:
        G=Grammar_Sequence(slow_grammar)
        fn_out="slow_composition.wav"
    elif EX==6:
        START_SEQUENCE="q$oo$qq$qqq$q"*4
        G=Grammar_Sequence(octave_grammar)
        fn_out="clave_composition.wav"
    elif EX==7:
        Gs=[]
        SR=16000
        samples={
            "D4cymb19.wav": {"grammar": [triplet_grammar], "gain": 1},
            "Rimsd1.wav": {"grammar": [octave_grammar], "gain": 1},
            "fkick_02a.wav": {"grammar": [basic_grammar], "gain": 1},
            "snar_07a.wav": {"grammar": [triplet_grammar], "gain": 1},
            "tr_hrk_bd_02_a.wav": {"grammar": [slow_grammar], "gain": 1},
            "tr_hrk_scratch_02_a.wav": {"grammar": [slow_grammar], "gain": 1}
        }
        N_TRACKS=len(samples)
        gains:[]
        for s in samples:            
            print("Generating sequence for %s"%s)
            G=Grammar_Sequence(random_elem_in_list(samples[s]["grammar"]))
            gains.append(samples[s]["gain"])
            C=Composer("sounds/"+s, sr=SR)
            G.create_sequence(START_SEQUENCE)
            C.create_sequence(G.sequence)        
            Gs.append(G)
            Cs.append(C)
            
    if MONO_COMPOSITION:
        seqs=G.create_sequence(START_SEQUENCE)
        print("\n".join(seqs), "\nFinal sequence: ", G.sequence)    
        C= Composer("sounds/D4cymb19.wav")
        C.create_sequence(G.sequence)
        C.write("out/"+fn_out)
    else:
        write_mix(Cs, "out/multitrack.wav", gains=gains)