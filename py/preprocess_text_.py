from CONTRACTIONS_CLASS import contraction
import re
import nltk
def cls():
    import os
    os.system('cls')

def export_tuple_csv(list_tuples,csv_filepath):
    import csv
    with open(csv_filepath, 'w') as fs:
        writer = csv.writer(fs,lineterminator='\n')
        for tup in list_tuples:
            WROTE=writer.writerow(tup)

cls()
if not os.path.isdir("../OUTPUT/"):
    os.mkdir("../OUTPUT/")
# STORE REGEX PATTERNS AND READ TXT FILE
NEWLREG=r"[\r|\n|\r\n]+"
PUNCREG=r"[A-Za-z0-9\s]+"
TWOSPAC=r"  "
# SAMPLE DATA TAKEN FROM https://www.rev.com/transcript-editor/shared/2aaBT20ycRq4t7oNpRPrALF7cEwwiCjj9R9g9sfc6kZ5NNB9n-f6Y2Z4Gyck8fW2JXqE3WJAU1PtJ0Q2rTDCc6PdYN0?loadFrom=PastedDeeplink&ts=1.61
START="../data/Matthew McConaughey University of Houston Speech.txt"
with open(START) as fs:
    START_TXT = fs.read()

# BEGIN: FIRST, PUNCTUATION (E.G., COMMAS, PERIODS) WAS DISCARDED
EXPAND = contraction.expand_contractions(START_TXT)
NOCRLF = re.sub(NEWLREG, ' ',EXPAND)
NOPUNC = "".join(re.findall(PUNCREG,NOCRLF))
while re.search(TWOSPAC,NOPUNC) is not None:
    NOPUNC=re.sub(TWOSPAC," ",NOPUNC)

CLEANED=NOPUNC.lower()
# END: FIRST, PUNCTUATION (E.G., COMMAS, PERIODS) WAS DISCARDED

# BEGIN: save your work
# cleaned transcript (contractions expanded, crlf removed, punctuation removed, double spaces removed, all lowercase) saved to MM_NOCRLF_NOPUNCT_NOCONTRACT_PY.txt
OUTF="../OUTPUT/MM_NOCRLF_NOPUNCT_NOCONTRACT_PY.txt"
with open(OUTF,'w') as fs:
    INTOUT = fs.write(CLEANED)
# END: save your work

# BEGIN: WORDS WERE TOKENIZED (IDENTIFIED AS PARTS OF SPEECH)
TOKENIZED=nltk.word_tokenize(CLEANED)
POS_TAGGED=nltk.pos_tag(TOKENIZED)
# END: WORDS WERE TOKENIZED (IDENTIFIED AS PARTS OF SPEECH)

# BEGIN: save your work
# Data in POS_TAGGED is saved to POS_TAGGED_LOWER.csv
# column 1 is the original word
# column 2 is the original word's 'part-of-speech' tag
export_tuple_csv(POS_TAGGED,"../OUTPUT/POS_TAGGED_LOWER.csv")
# END: save your work

# BEGIN: WORDS WERE THEN CONVERTED TO THE ROOTS FROM WHICH THEY ARE INFLECTED, OR LEMMATIZED, USING THE NLTK WORDNET LEMMATIZER.
# WITH_LEMMA 'list' of 'tuples' is a table with three columns:
# column 1 is the original word
# column 2 is the original word's 'part-of-speech' tag
# column 3 is the result of 'lemmatizing' the original word (often times resulting in the same exact word)
from nltk.stem import WordNetLemmatizer
LEM = WordNetLemmatizer()
WITH_LEMMA=[]
for tup in POS_TAGGED:
    OG_WORD=tup[0]
    POS_TAG=tup[1]
    LEM_WORD=LEM.lemmatize(OG_WORD)
    TRI=(OG_WORD,POS_TAG,LEM_WORD)
    WITH_LEMMA.append(TRI)
# END: WORDS WERE THEN CONVERTED TO THE ROOTS FROM WHICH THEY ARE INFLECTED, OR LEMMATIZED, USING THE NLTK WORDNET LEMMATIZER.

# BEGIN: save your work
# DATA in WITH_LEMMA is saved to LEMMA_POS_TAGGED_LOWER.csv
export_tuple_csv(WITH_LEMMA,"../OUTPUT/LEMMA_POS_TAGGED_LOWER.csv")
# END: save your work

