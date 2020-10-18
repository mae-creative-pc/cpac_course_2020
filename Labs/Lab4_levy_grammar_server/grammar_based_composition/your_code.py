basic_grammar={
    "S":["M", "SM"],
    "M": ["HH"],    
    "H": ["h", "qq"],
}
octave_grammar={
    "S":["M", "SM"],
    "M": ["HH"],    
    "H": ["h", "QQ"],
    "Q":["q", "oo"],
}
triplet_grammar={
    "S":["M", "SM"],
    "M": ["HH", "ththth"],    
    "H": ["h", "QQ", "tqtqtq"],
    "Q":["q", "oo","tototo"],
}
syncopated_grammar={
    "S":["M", "SM"],
    "M": ["HH", "ththth", "QHQ",],    
    "H": ["h", "QQ", "tqtqtq", "oqo"],
    "Q":["q", "oo","tototo"],
}
slow_grammar={
    "S":["M", "SM"],
    "M": ["HH", "w"],
    "H":["h", "$h"]
}
clap_grammar={
    "S":["M", "SH"],
    "M":["HH", "$w"],
    "H":["$qq","$h"],
}
