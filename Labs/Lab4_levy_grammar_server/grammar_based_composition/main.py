# %% Import libraries
import numpy as np
import random
import os
import re
import librosa
import soundfile as sf
os.chdir(os.path.dirname(os.path.abspath(__file__)))
def random_elem_in_list(list_of_elems):
    return list_of_elems[random.randint(0,len(list_of_elems)-1)]
# %% YOUR CODE HERE

# ==== GRAMMARS
basic_grammar={
    "S":["M", "SM"],
    "M": ["HH"],    
    "H": ["h", "qq"],
}
# === Words to duration ===
word_dur={"h":0.5, # half-measure
           "q":0.25, # quarter-measure
}

# write_mix
def write_mix(Cs, gains=None, fn_out="out.wav"):
    # your code                            
    track=0.707*track/np.max(np.abs(track))
    sf.write(fn_out, track, Cs[0].sr)

# %% Grammar Sequence
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
# %% Composer
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
        sym_seq=[]
        dur_seq=[]
        while k<len(sequence):
            if sequence[k] in "$t":
                #your code
                pass
            else:
                sym=sequence[k]
                k+=1
            sym_seq.append(sym)
            
            dur_seq.append(word_dur[sym])
        return dur_seq, sym_seq
    def compute_duration(self, dur_seq):
        duration_in_notes=0
        for dur in dur_seq:
            duration_in_notes+=dur
        return duration_in_notes        
    def create_sequence(self, sequence):
        dur_seq, sym_seq=self.split_sequence(sequence)
        duration_in_notes=self.compute_duration(dur_seq)
        
        duration_in_seconds=duration_in_notes*self.m_bpm
        self.sequence=np.zeros((int(duration_in_seconds*self.sr),))
        idx=0
        for note, symbol in zip(dur_seq, sym_seq):
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

# %% main script
if __name__=="__main__":
    EX=1
    C=None
    NUM_M=8
    START_SEQUENCE="M"*NUM_M
    MONO_COMPOSITION=EX<7
    if EX==1:
        G=Grammar_Sequence(basic_grammar)        
        fn_out="basic_composition.wav"
    elif EX==2:
        G=Grammar_Sequence(octave_grammar)
        fn_out="octave_composition.wav"
    elif EX==3:
        G=Grammar_Sequence(triplet_grammar)
        fn_out="triplet_composition.wav"
    elif EX==4:
        G=Grammar_Sequence(slow_grammar)
        fn_out="slow_composition.wav"
    elif EX==5:        
        G=Grammar_Sequence(upbeat_grammar)        
        fn_out="upbeat_composition.wav"
    elif EX==6:
        G=Grammar_Sequence(clave_grammar)
        fn_out="clave_composition.wav"
    elif EX==7:
        samples=[]
        grammars=[]# your grammars
        gains = [] #your gains
	    fn_out="multitrack.wav"
        Gs=[]  #list of Grammar_Sequence
        Cs=[]  #list of Composer
        SR=16000 # use a common sr
        # your code...

    if MONO_COMPOSITION:
        seqs=G.create_sequence(START_SEQUENCE)
        print("\n".join(seqs), "\nFinal sequence: ", G.sequence)    
        C= Composer("sounds/D4cymb19.wav")
        C.create_sequence(G.sequence)
        C.write("out/"+fn_out)
    else:
        write_mix(Cs, "out/multitrack.wav", gains=gains)