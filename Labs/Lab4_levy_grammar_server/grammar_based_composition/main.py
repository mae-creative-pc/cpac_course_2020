import numpy as np
import random
import os
import re
import librosa
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
for n in note_durs.keys():# so its computed just once
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
    def __init__(self, fn, BPM=120):
        self.sample, self.sr =  librosa.load(fn)     
        #self.peak_sample=np.argmax(np.abs(self.sample))   
        self.sampleN=self.sample.size
        self.BPM=BPM
        self.t_bpm=4*60/self.BPM
        self.sequence=[]
    def split_sequence(self, sequence):
        k=0
        duration_in_notes=0
        notes_sequences=[]
        while k<len(sequence):
            if k == "$":

                duration_in_notes+=note_durs[sequence[k:k+2]]
                notes_sequences.append(note_durs[sequence[k:k+2]])
                k+=2
            else:
                duration_in_notes+=note_durs[sequence[k]]
                notes_sequences.append(note_durs[sequence[k]])
                k+=1
    def convert_sequence(self, sequence):
        notes_sequences, symbol_sequence=self.split_sequence()
        duration_in_notesself.sum(sequence)
        duration_in_seconds=duration_in_notes*self.t_bpm
        self.sequence=np.zeros((int(duration_in_seconds*self.sr),))
        for note in notes_sequences:
            note_i=note*self.t_bpm*self.sr
            self.sequence[note_i:]

if __name__=="__main__":
    G=Grammar_Sequence(basic_grammar)
    print(G.grammar)
    seqs=G.create_sequence("S")
    print(seqs)
    print(G.sequence)