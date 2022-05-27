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

def WriteOutput(message,title,file,oldfile : str = ""):
    import os
    import re
    import math
    import colorama
    from colorama import Fore,Back,Style,init
    init()
    print(Style.BRIGHT)
    minlength = 0
    lines = []
    lines.append(message)
    lines.append(file)
    if oldfile != "":
        lines.append("Output file: ")
        lines.append("already exists. Moving existing file to: ")
        lines.append(oldfile)
    
    sorted_lines=sorted(lines,key=len)
    minlength = blen=len(sorted_lines[-1]) + 8
    window_width = os.get_terminal_size().columns - 1
    if window_width < minlength:
        tb_border_left = []
        for i in list(range(1, math.floor((window_width / 2) - (len(title) / 2)))):
            tb_border_left.append("#")
        
        left = "".join(tb_border_left)
        tb_border_right = []
        for i in list(range(1, math.ceil((window_width / 2) - (len(title) / 2)))):
            tb_border_right.append("#")
        
        right = "".join(tb_border_right)
        top_bottom = left + title + right
        print(Fore.WHITE,top_bottom)
        maxstr = len(top_bottom) - 9
        regpattern = "([A-Za-z0-9,.!: ]{1," + str(maxstr) + "}\s)"
        filepattern = "([A-Za-z0-9./_ ]{1," + str(maxstr) + "})"
        fr = []
        for i in list(range(0,(len(top_bottom) - 4))):
            fr.append("#")
        
        frame = "# " + "".join(fr) + " #"
        print(Fore.WHITE,frame)
        if oldfile != "":
            print(Fore.WHITE,"# # ",end="")
            print(Fore.GREEN,"Output file:",end="")
            if (maxstr - 12) > 0:
                spra = []
                for s in list(range(1,(maxstr - 12))):
                    spra.append(" ")

                spaces = "".join(spra)
                print(Fore.GREEN,spaces,end="")
            
            print(Fore.WHITE,"# #")
            if len(file) > maxstr:
                for i in re.findall(filepattern,file):
                    print(Fore.WHITE,"# # ",end="")
                    if (maxstr - len(i)) > 0:
                        spra = []
                        for s in list(range(0,(maxstr - len(i)))):
                            spra.append(" ")
                        
                        spaces = "".join(spra)
                        print(Fore.YELLOW,(i + spaces),end="")
                    else:
                        print(Fore.YELLOW,i.strip(),end="")
                    
                    print(Fore.WHITE,"# #")
                
            else:
                print(Fore.WHITE,"# # ",end="")
                if (maxstr - len(file)) > 0:
                    spra = []
                    for s in list(range(0,(maxstr - len(file)))):
                        spra.append(" ")
                        
                    spaces = "".join(spra)
                    print(Fore.YELLOW,file + spaces,end="")
                else:
                    print(Fore.YELLOW,file.strip(),end="")
                
                print(Fore.WHITE,"# #")
            
            
            print(Fore.WHITE,"# # ",end="")
            print(Fore.GREEN,"already exists. Moving existing file to:",end="")
            if (maxstr - 40) > 0:
                spra = []
                for s in list(range(1,(maxstr - 40))):
                    spra.append(" ")

                spaces = "".join(spra)
                print(Fore.GREEN,spaces,end="")
            
            print(Fore.WHITE,"# #")
            if len(oldfile) > maxstr:
                for i in re.findall(filepattern,oldfile):
                    print(Fore.WHITE,"# # ",end="")
                    if (maxstr - len(i)) > 0:
                        spra = []
                        for s in list(range(1,(maxstr - len(i)))):
                            spra.append(" ")
                        
                        spaces = "".join(spra)
                        print(Fore.YELLOW,(i + spaces),end="")
                    else:
                        print(Fore.YELLOW,i.strip(),end="")
                    
                    print(Fore.WHITE," # #")
                
            else:
                print(Fore.WHITE,"# # ",end="")
                if (maxstr - len(oldfile)) > 0:
                    spra = []
                    for s in list(range(0,(maxstr - len(oldfile)))):
                        spra.append(" ")
                        
                    spaces = "".join(spra)
                    print(Fore.YELLOW,oldfile + spaces,end="")
                else:
                    print(Fore.YELLOW,oldfile.strip(),end="")
                
                print(Fore.WHITE,"# #")
            
            print(Fore.WHITE,frame)
            print(Fore.WHITE,frame)
        if len(message) > maxstr:
            for i in re.findall(regpattern,message):
                print(Fore.WHITE,"# # ",end="")
                if (maxstr - len(i)) > 0:
                    spra = []
                    for s in list(range(0,(maxstr - len(i)))):
                        spra.append(" ")
                    
                    spaces = "".join(spra)
                    print(Fore.GREEN,(i + spaces),end="")
                else:
                    print(Fore.GREEN,i,end="")
                
                print(Fore.WHITE,"# #")
            
        else:
            print(Fore.WHITE,"# # ",end="")
            if (maxstr - len(message)) > 0:
                spra = []
                for s in list(range(0,(maxstr - len(message)))):
                    spra.append(" ")
                    
                spaces = "".join(spra)
                print(Fore.GREEN,message + spaces,end="")
            else:
                print(Fore.GREEN,message,end="")
            
            print(Fore.WHITE,"# #")
        
        if len(file) > maxstr:
            for i in re.findall(filepattern,file):
                print(Fore.WHITE,"# # ",end="")
                if (maxstr - len(i)) > 0:
                    spra = []
                    for s in list(range(0,(maxstr - len(i)))):
                        spra.append(" ")
                    
                    spaces = "".join(spra)
                    print(Fore.YELLOW,(i + spaces),end="")
                else:
                    print(Fore.YELLOW,i.strip(),end="")
                
                print(Fore.WHITE,"# #")
            
        else:
            print(Fore.WHITE,"# # ",end="")
            if (maxstr - len(file)) > 0:
                spra = []
                for s in list(range(0,(maxstr - len(file)))):
                    spra.append(" ")
                    
                spaces = "".join(spra)
                print(Fore.YELLOW,file + spaces,end="")
            else:
                print(Fore.YELLOW,file.strip(),end="")
            
            print(Fore.WHITE,"# #")
        
        print(Fore.WHITE,frame)
        print(Fore.WHITE,top_bottom)
    else:
        tb_border_left = []
        for i in list(range(0, math.floor((minlength / 2) - (len(title) / 2)))):
            tb_border_left.append("#")
        
        left = "".join(tb_border_left)
        tb_border_right = []
        for i in list(range(0, math.ceil((minlength / 2) - (len(title) / 2)))):
            tb_border_right.append("#")
        
        right = "".join(tb_border_right)
        top_bottom = left + title + right
        print(Fore.WHITE,top_bottom)
        maxstr = len(top_bottom) - 6
        regpattern = "([A-Za-z0-9,.!: ]{1," + str(maxstr) + "}\s)"
        filepattern = "([A-Za-z0-9./_ ]{1," + str(maxstr) + "})"
        fr = []
        for i in list(range(0,(len(top_bottom) - 4))):
            fr.append("#")
        
        frame = "# " + "".join(fr) + " #"
        print(Fore.WHITE,frame)
        if oldfile != "":
            print(Fore.WHITE,"# # ",end="")
            print(Fore.GREEN,"Output file:",end="")
            if (maxstr - 15) > 0:
                spra = []
                for s in list(range(1,(maxstr - 15))):
                    spra.append(" ")

                spaces = "".join(spra)
                print(Fore.GREEN,spaces,end="")
            
            print(Fore.WHITE,"# #")
            if len(file) > maxstr:
                for i in re.findall(filepattern,file):
                    print(Fore.WHITE,"# # ",end="")
                    if (maxstr - len(i)) > 0:
                        spra = []
                        for s in list(range(1,(maxstr - len(i)))):
                            spra.append(" ")
                        
                        spaces = "".join(spra)
                        print(Fore.YELLOW,(i + spaces),end="")
                    else:
                        print(Fore.YELLOW,i.strip(),end="")
                    
                    print(Fore.WHITE,"# #")
                
            else:
                print(Fore.WHITE,"# # ",end="")
                if (maxstr - len(file)) > 0:
                    spra = []
                    for s in list(range(3,(maxstr - len(file)))):
                        spra.append(" ")
                        
                    spaces = "".join(spra)
                    print(Fore.YELLOW,file + spaces,end="")
                else:
                    print(Fore.YELLOW,file.strip(),end="")
                
                print(Fore.WHITE,"# #")
            
            
            print(Fore.WHITE,"# # ",end="")
            print(Fore.GREEN,"already exists. Moving existing file to:",end="")
            if (maxstr - 43) > 0:
                spra = []
                for s in list(range(1,(maxstr - 43))):
                    spra.append(" ")

                spaces = "".join(spra)
                print(Fore.GREEN,spaces,end="")
            
            print(Fore.WHITE,"# #")
            if len(oldfile) > maxstr:
                for i in re.findall(filepattern,oldfile):
                    print(Fore.WHITE,"# # ",end="")
                    if (maxstr - len(i)) > 0:
                        spra = []
                        for s in list(range(1,(maxstr - len(i)))):
                            spra.append(" ")
                        
                        spaces = "".join(spra)
                        print(Fore.YELLOW,(i + spaces),end="")
                    else:
                        print(Fore.YELLOW,i.strip(),end="")
                    
                    print(Fore.WHITE," # #")
                
            else:
                print(Fore.WHITE,"# # ",end="")
                if (maxstr - len(oldfile)) > 0:
                    spra = []
                    for s in list(range(3,(maxstr - len(oldfile)))):
                        spra.append(" ")
                        
                    spaces = "".join(spra)
                    print(Fore.YELLOW,oldfile + spaces,end="")
                else:
                    print(Fore.YELLOW,oldfile.strip(),end="")
                
                print(Fore.WHITE,"# #")
            
            print(Fore.WHITE,frame)
            print(Fore.WHITE,frame)
        
        if len(message) > maxstr:
            for i in re.findall(regpattern,message):
                print(Fore.WHITE,"# # ",end="")
                if (maxstr - len(i)) > 0:
                    spra = []
                    for s in list(range(1,(maxstr - len(i)))):
                        spra.append(" ")
                    
                    spaces = "".join(spra)
                    print(Fore.GREEN,(i + spaces),end="")
                else:
                    print(Fore.GREEN,i,end="")
                
                print(Fore.WHITE,"# #")
            
        else:
            print(Fore.WHITE,"# # ",end="")
            if (maxstr - len(message)) > 0:
                spra = []
                for s in list(range(2,(maxstr - len(message)))):
                    spra.append(" ")
                    
                spaces = "".join(spra)
                print(Fore.GREEN,message.strip() + spaces,end="")
            else:
                print(Fore.GREEN,message.strip(),end="")
            
            print(Fore.WHITE,"# #")
        
        if len(file) > maxstr:
            for i in re.findall(filepattern,file):
                print(Fore.WHITE,"# # ",end="")
                if (maxstr - len(i)) > 0:
                    spra = []
                    for s in list(range(1,(maxstr - len(i)))):
                        spra.append(" ")
                    
                    spaces = "".join(spra)
                    print(Fore.YELLOW,(i + spaces),end="")
                else:
                    print(Fore.YELLOW,i,end="")
                
                print(Fore.WHITE,"# #")
            
        else:
            print(Fore.WHITE,"# # ",end="")
            if (maxstr - len(file)) > 0:
                spra = []
                for s in list(range(3,(maxstr - len(file.strip())))):
                    spra.append(" ")
                    
                spaces = "".join(spra)
                print(Fore.YELLOW,file.strip() + spaces,end="")
            else:
                print(Fore.YELLOW,file.strip(),end="")
            
            print(Fore.WHITE,"# #")
    
        print(Fore.WHITE,frame)
        print(Fore.WHITE,top_bottom)


def find_files(filename, search_path):
    import os
    result = []
    for root, dir, files in os.walk(search_path):
        if filename in files:
            result.append(os.path.join(root, filename))
    return result

jar = os.environ["CLASSPATH"] + "\\stanford-postagger-4.2.0.jar"
model = os.environ["CLASSPATH"] + "\\models\\english-bidirectional-distsim.tagger"

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

def handle_existing_file(FILE):
    FOLDER=os.path.dirname(FILE)
    FILENAME=os.path.basename(FILE)
    OLDFILE=FOLDER + "/OLD/" + FILENAME
    if not os.path.isdir(FOLDER + "/OLD"):
        os.mkdir(FOLDER + "/OLD")
    FILEITER=0
    while os.path.isfile(OLDFILE):
        OLDFILE=FOLDER + "/OLD/" + str(FILEITER) + FILENAME
        FILEITER+=1
    shutil.move(FILE, OLDFILE)
    return OLDFILE

def clean_transcript_from_file(save_file: bool = False, lemmatize: bool = False):
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
            if os.path.isfile(NEWFILE):
                OLDFILE = handle_existing_file(NEWFILE)
                with open(NEWFILE,'w') as OUTTXT:
                    OUTTXT.write(CLEANED)
                WriteOutput("All lowercase transcript, clean from CRLFs and punctuation, was lemmatized and saved to: "," CLEANING TRANSCRIPT ",NEWFILE,OLDFILE)
            else:
                with open(NEWFILE,'w') as OUTTXT:
                    OUTTXT.write(CLEANED)
                WriteOutput("All lowercase transcript, clean from CRLFs and punctuation, was lemmatized and saved to: "," CLEANING TRANSCRIPT ",NEWFILE)
        else:
            NEWFILE=FOLDER + "/cleaned_" + FILENAME
            if os.path.isfile(NEWFILE):
                OLDFILE = handle_existing_file(NEWFILE)
                with open(NEWFILE,'w') as OUTTXT:
                    OUTTXT.write(CLEANED)
                WriteOutput("All lowercase transcript, clean from CRLFs and punctuation, was saved to: "," CLEANING TRANSCRIPT ",NEWFILE,OLDFILE)
            else:
                with open(NEWFILE,'w') as OUTTXT:
                    OUTTXT.write(CLEANED)
                WriteOutput("All lowercase transcript, clean from CRLFs and punctuation, was saved to: "," CLEANING TRANSCRIPT ",NEWFILE)
    print("")
    print(Fore.GREEN,"Transcript cleaning complete!")
    print(Fore.YELLOW,"Tagging and tokenizing ...")
    print(Fore.WHITE,"")
    return nltk.word_tokenize(CLEANED)

def tag_and_tokenize(save_csv: bool = False,lemmatize: bool = False):
    TOKENIZED=clean_transcript_from_file(True,lemmatize)
    POS_TAGGED=st.tag(TOKENIZED)
    if save_csv:
        FOLDER=os.path.dirname(transcript_file)
        FILENAME=Path(transcript_file).stem
        if lemmatize:
            CSVFILE=FOLDER + "/tagged_tokenized_and_lemmatized_" + FILENAME + ".csv"
            if os.path.isfile(CSVFILE):
                OLDCSV = handle_existing_file(CSVFILE)
                export_tuple_csv(POS_TAGGED,CSVFILE)
                WriteOutput("Lemmatized transcript tokens and corresponding POS tags were saved to: "," TAG AND TOKENIZE ",CSVFILE,OLDCSV)
            else:
                export_tuple_csv(POS_TAGGED,CSVFILE)
                WriteOutput("Lemmatized transcript tokens and corresponding POS tags were saved to: "," TAG AND TOKENIZE ",CSVFILE)
        else:
            CSVFILE=FOLDER + "/tagged_and_tokenized_" + FILENAME + ".csv"
            if os.path.isfile(CSVFILE):
                OLDCSV=handle_existing_file(CSVFILE)
                export_tuple_csv(POS_TAGGED,CSVFILE)
                WriteOutput("Transcript tokens and corresponding POS tags were saved to: "," TAG AND TOKENIZE ",CSVFILE,OLDCSV)
            else:
                export_tuple_csv(POS_TAGGED,CSVFILE)
                WriteOutput("Transcript tokens and corresponding POS tags were saved to: "," TAG AND TOKENIZE ",CSVFILE)
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
    WriteOutput("Opening transcript file: "," TRANSCRIPT ",transcript_file)
    # FIRST ITERATION: NO LEMMATIZING
    POS_TAGGED_WORDS=tag_and_tokenize(True)
    # SECOND ITERATION: WITH LEMMATIZING
    POS_TAGGED_LEMMATIZED=tag_and_tokenize(True,True)
else:
    print(Fore.RED,transcript_file + " does not exist!")

