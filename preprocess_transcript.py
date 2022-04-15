import math
import argparse
import io
import tkinter as tk
from tkinter import filedialog as fd
import sys
import colorama
from colorama import Fore,Back,Style,init
import shutil
import re
import nltk
import os
from nltk.stem import WordNetLemmatizer
from nltk.tag import StanfordPOSTagger
from pathlib import Path
import platform
#import requests
import zipfile
import urllib

windows = False
if platform.system() == 'Windows':
    windows = True
#    os.system("powershell -noprofile -c \"if([console]::WindowWidth -le 200){ [console]::BufferWidth = 200 }\"")
#else:
#    os.system("stty cols 200")

ZIP = os.path.realpath(os.curdir) + "\\stanford-tagger-4.2.0.zip"
FOLDER = os.path.realpath(os.curdir) + "\\stanford-tagger-4.2.0\\"
if not os.path.isdir(FOLDER):
    os.mkdir(FOLDER)
    if not os.path.isfile(ZIP):
        urllib.request.urlretrieve('https://downloads.cs.stanford.edu/nlp/software/stanford-tagger-4.2.0.zip',ZIP)
    
    with zipfile.ZipFile(ZIP,'r') as z:
        z.extractall(FOLDER)

#CORENLPZIP="https://downloads.cs.stanford.edu/nlp/software/stanford-corenlp-latest.zip"
# download https://downloads.cs.stanford.edu/nlp/software/stanford-tagger-4.2.0.zip
FOLDER = FOLDER + "\\stanford-postagger-full-2020-11-17\\"
java_path = "C:\\Program Files\\Java\\jre1.8.0_321\\bin\\java.exe"
# java_path = "java.exe"
# os.environ["JAVAHOME"] = "java.exe"
os.environ["JAVAHOME"] = "C:\\Program Files\\Java\\jre1.8.0_321\\bin\\java.exe"
os.environ["CLASSPATH"] = FOLDER
os.environ["STANFORD_MODELS"] = FOLDER + "\\models\\english-bidirectional-distsim.tagger"
jar=FOLDER + "\\stanford-postagger-4.2.0.jar"
model=FOLDER + "\\models\\english-bidirectional-distsim.tagger"

st = StanfordPOSTagger("english-bidirectional-distsim.tagger")
st.java_options = ""
LEM = WordNetLemmatizer()
init()
parser = argparse.ArgumentParser(description='Specify your transcript filepath along with any optional arguments.')
parser.add_argument(
    '--transcript_file',
    action='store',
    dest='transcript_file',
    type=str,
    help='--transcript_file <str>(file path to your transcript file)',
    default=None,
    required=False
)
results = parser.parse_args()
print(Style.BRIGHT)
def cls():
    import os
    os.system('cls')

def print_tokens_and_tags(TAGGED_LIST):
    for i in TAGGED_LIST:
        print(i[0],end='')
        for a in range(0,20 - len(i[0])):
            print(' ',end='')
        print(i[1])

def export_tuple_csv(list_tuples,csv_filepath):
    import csv
    with open(csv_filepath, 'w') as fs:
        writer = csv.writer(fs,lineterminator='\n')
        for tup in list_tuples:
            WROTE=writer.writerow(tup)

def openafile():
    master = tk.Tk()
    master.title("Open your transcript file")
    def callback():
        global TIOW
        TIOW=fd.askopenfile()
        master.destroy()
    tk.Label(master,text="Click 'Next' and then select your transcript file.").grid(row=0)
    tk.Button(master,text='Next',command=callback).grid(row=1)
    master.attributes("-topmost", True)
    tk.mainloop()

def get_savefile_messagelength(MESSAGE,FILE):
    lines = []
    lines.append(MESSAGE)
    lines.append(FILE)
    sorted_lines=sorted(lines,key=len)
    blen=len(sorted_lines[-1]) + 9
    return blen

def get_fileexists_messagelength(FILE):
    FOLDER=os.path.dirname(FILE)
    FILENAME=os.path.basename(FILE)
    OLDFILE=FOLDER + "/OLD/" + FILENAME
    FILEITER=0
    while os.path.isfile(OLDFILE):
        OLDFILE=FOLDER + "/OLD/" + str(FILEITER) + FILENAME
        FILEITER+=1
    lines = []
    lines.append("Output file:")
    lines.append("    " + FILE)
    lines.append("already exists. Moving existing file to:")
    lines.append("    " + OLDFILE)
    sorted_lines=sorted(lines,key=len)
    blen=len(sorted_lines[-1]) + 9
    return blen

def handle_existing_file(FILE,LENGTH):
    PRINTRA = []
    FOLDER=os.path.dirname(FILE)
    FILENAME=os.path.basename(FILE)
    OLDFILE=FOLDER + "/OLD/" + FILENAME
    if not os.path.isdir(FOLDER + "/OLD"):
        os.mkdir(FOLDER + "/OLD")
    FILEITER=0
    while os.path.isfile(OLDFILE):
        OLDFILE=FOLDER + "/OLD/" + str(FILEITER) + FILENAME
        FILEITER+=1
    lines = []
    lines.append("Output file:")
    lines.append("    " + FILE)
    lines.append("already exists. Moving existing file to:")
    lines.append("    " + OLDFILE)
    blen=LENGTH
    border = ""
    for i in range(0,(blen + 2)):
        border=border + "#"
    PRINTRA.append((Fore.WHITE,"# " + border + " #"))
    for i in lines:
        SPACECOUNT=blen - len("# # " + i + " # #") + 4
        SPACES = ""
        for a in range(1,SPACECOUNT):
            SPACES=SPACES + " "
        PRINTRA.append((Fore.WHITE,"# # ",""))
        if i.startswith(" "):
            PRINTRA.append((Fore.GREEN,i,""))
        else:
            PRINTRA.append((Fore.YELLOW,i,""))
        PRINTRA.append((Fore.WHITE,SPACES,""))
        PRINTRA.append((Fore.WHITE," # #"))
    PRINTRA.append((Fore.WHITE,"# " + border + " #"))
    shutil.move(FILE, OLDFILE)
    return PRINTRA

def save_file_message(MESSAGE,FILE,LENGTH):
    PRINTRA = []
    lines = []
    lines.append(MESSAGE)
    lines.append(FILE)
    blen = LENGTH
    border = ""
    for i in range(0,(blen + 2)):
        border=border + "#"    
    PRINTRA.append((Fore.WHITE,"# " + border + " #"))
    for i in lines:
        SPACECOUNT=blen - len("# " + i + " #")
        SPACES = ""
        for a in range(1,SPACECOUNT):
            SPACES=SPACES + " "
        PRINTRA.append((Fore.WHITE,"# # ",""))
        if i.startswith(" "):
            PRINTRA.append((Fore.GREEN,i,""))
        else:
            PRINTRA.append((Fore.YELLOW,i,""))
        PRINTRA.append((Fore.WHITE,SPACES,""))
        PRINTRA.append((Fore.WHITE," # #"))
    PRINTRA.append((Fore.WHITE,"# " + border + " #"))
    return PRINTRA

def clean_transcript_from_file(save_file: bool = False, lemmatize: bool = False):
    PRINTRA=[]
    MSGLEN = []
    LEMSTR="All lowercase transcript, clean from CRLFs and punctuation, was lemmatized and saved to:"
    NLEMSTR="All lowercase transcript, clean from CRLFs and punctuation, was saved to:"
    import os
    START_TXT = open(transcript_file).read()
    NOCRLF = re.sub(r"[\r|\n|\r\n]+", ' ',START_TXT)
    NOPUNC = "".join(re.findall(r"[A-Za-z0-9\s]+",NOCRLF))
    while re.search(r"  ",NOPUNC) is not None:
        NOPUNC=re.sub(r"  "," ",NOPUNC)
    CLEANED=NOPUNC.lower()
    if lemmatize:
        LEMRA = []
        for i in nltk.word_tokenize(CLEANED):
            LEMRA.append(LEM.lemmatize(i))
        CLEANED=" ".join(LEMRA)
    if save_file:
        FOLDER=os.path.dirname(transcript_file)
        FILENAME=os.path.basename(transcript_file)
        if lemmatize:
            NEWFILE=FOLDER + "/cleaned_and_lemmatized_" + FILENAME
            MSGLEN.append(get_savefile_messagelength(LEMSTR,"    " + NEWFILE))
            if os.path.isfile(NEWFILE):
                MSGLEN.append(get_fileexists_messagelength(NEWFILE))
            if len(MSGLEN) < 2:
                THISLEN = MSGLEN[0]
                MSG=save_file_message(LEMSTR,"    " + NEWFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
            else:
                MSGLEN.sort()
                THISLEN = MSGLEN[-1]
                MSG=handle_existing_file(NEWFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
                MSG = save_file_message(LEMSTR,"    " + NEWFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
        else:
            NEWFILE=FOLDER + "/cleaned_" + FILENAME
            MSGLEN.append(get_savefile_messagelength(NLEMSTR,"    " + NEWFILE))
            if os.path.isfile(NEWFILE):
                MSGLEN.append(get_fileexists_messagelength(NEWFILE))
            if len(MSGLEN) < 2:
                THISLEN = MSGLEN[0]
                MSG=save_file_message(NLEMSTR,"    " + NEWFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
            else:
                MSGLEN.sort()
                THISLEN = MSGLEN[-1]
                MSG=handle_existing_file(NEWFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
                MSG = save_file_message(NLEMSTR,"    " + NEWFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
    LENGTHS=[]
    for i in PRINTRA:
        LENGTHS.append(len(i[1]))
    LENGTHS.sort()
    blen = LENGTHS[-1]
    border = ""
    hb=math.floor((blen - 22) / 2)
    for i in range(0,hb):
        border=border + "#"
    NEWRA=[]
    if float(LENGTHS[-1]) % float(2.0) > 0:
        NEWRA.append((Fore.WHITE,border + "# CLEANING TRANSCRIPT #" + border))
    else:
        NEWRA.append((Fore.WHITE,border + " CLEANING TRANSCRIPT #" + border))
    for i in PRINTRA:
        NEWRA.append(i)
    if float(LENGTHS[-1]) % float(2.0) > 0:
        NEWRA.append((Fore.WHITE,border + "# CLEANING TRANSCRIPT #" + border))
    else:
        NEWRA.append((Fore.WHITE,border + " CLEANING TRANSCRIPT #" + border))
    for i in NEWRA:
        COLOR=i[0]
        TEXT=i[1]
        if len(i) > 2:
            print(COLOR,TEXT,end="")
        else:
            print(COLOR,TEXT)
    print("")
    print(Fore.GREEN,"Transcript cleaning complete!")
    print(Fore.YELLOW,"Tagging and tokenizing ...")
    print(Fore.WHITE,"")
    with open(NEWFILE,'w') as OUTTXT:
        OUTTXT.write(CLEANED)
    return nltk.word_tokenize(CLEANED)

def tag_and_tokenize(save_csv: bool = False,lemmatize: bool = False):
    MSGLEN = []
    PRINTRA = []
    LEMSTR="Lemmatized transcript tokens and corresponding POS tags were saved to:"
    NLEMSTR="Transcript tokens and corresponding POS tags were saved to:"
    TOKENIZED=clean_transcript_from_file(True,lemmatize)
    POS_TAGGED=st.tag(TOKENIZED)
    if save_csv:
        FOLDER=os.path.dirname(transcript_file)
        FILENAME=Path(transcript_file).stem
        if lemmatize:
            CSVFILE=FOLDER + "/tagged_tokenized_and_lemmatized_" + FILENAME + ".csv"
            MSGLEN.append(get_savefile_messagelength(LEMSTR,"    " + CSVFILE))
            if os.path.isfile(CSVFILE):
                MSGLEN.append(get_fileexists_messagelength(CSVFILE))
            if len(MSGLEN) < 2:
                THISLEN = MSGLEN[0]
                MSG=save_file_message(LEMSTR,"    " + CSVFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
            else:
                MSGLEN.sort()
                THISLEN = MSGLEN[-1]
                MSG=handle_existing_file(CSVFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
                MSG = save_file_message(LEMSTR,"    " + CSVFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
        else:
            CSVFILE=FOLDER + "/tagged_and_tokenized_" + FILENAME + ".csv"
            MSGLEN.append(get_savefile_messagelength(NLEMSTR,"    " + CSVFILE))
            if os.path.isfile(CSVFILE):
                MSGLEN.append(get_fileexists_messagelength(CSVFILE))
            if len(MSGLEN) < 2:
                THISLEN = MSGLEN[0]
                MSG=save_file_message(NLEMSTR,"    " + CSVFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
            else:
                MSGLEN.sort()
                THISLEN = MSGLEN[-1]
                MSG=handle_existing_file(CSVFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
                MSG = save_file_message(NLEMSTR,"    " + CSVFILE,THISLEN)
                for i in MSG:
                    PRINTRA.append(i)
    LENGTHS=[]
    for i in PRINTRA:
        LENGTHS.append(len(i[1]))
    LENGTHS.sort()
    blen = LENGTHS[-1]
    border = ""
    hb=math.floor((blen - 18) / 2)
    for i in range(0,hb):
        border=border + "#"
    NEWRA=[]
    if float(LENGTHS[-1]) % float(2.0) > 0:
        NEWRA.append((Fore.WHITE,border + " TAG AND TOKENIZE #" + border))
    else:
        NEWRA.append((Fore.WHITE,border + " TAG AND TOKENIZE " + border))
    for i in PRINTRA:
        NEWRA.append(i)
    if float(LENGTHS[-1]) % float(2.0) > 0:
        NEWRA.append((Fore.WHITE,border + " TAG AND TOKENIZE #" + border))
    else:
        NEWRA.append((Fore.WHITE,border + " TAG AND TOKENIZE " + border))    
    for i in NEWRA:
        COLOR=i[0]
        TEXT=i[1]
        if len(i) > 2:
            print(COLOR,TEXT,end="")
        else:
            print(COLOR,TEXT)
    export_tuple_csv(POS_TAGGED,CSVFILE)
    print("")
    print(Fore.GREEN,"Tagging and tokenizing complete!")
    print(Fore.WHITE,"")
    return POS_TAGGED

cls()
if results.transcript_file == None:
    openafile()
    transcript_file = TIOW.name
else:
    transcript_file = results.transcript_file.replace("\\","/")
if os.path.isfile(transcript_file):
    SFML=get_savefile_messagelength("Opening transcript file:","    " + transcript_file)
    save_file_message("Opening transcript file:","    " + transcript_file,SFML)
    # FIRST ITERATION: NO LEMMATIZING
    POS_TAGGED_WORDS=tag_and_tokenize(True)
    # SECOND ITERATION: WITH LEMMATIZING
    POS_TAGGED_LEMMATIZED=tag_and_tokenize(True,True)
else:
    print(Fore.RED,transcript_file + " does not exist!")

