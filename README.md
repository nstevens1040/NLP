# NLTK Environment Setup Procedure  
This guide covers the following steps to set up your NLTK environment in Microsoft Windows
   1. [Installing Python](https://github.com/nstevens1040/NLP#python-383-32-bit-installation)
   2. [Configuring a Virtual Environment](https://github.com/nstevens1040/NLP#python-virtual-environment-setup)
   3. [Setting your NLTK_DATA Environment Variable](https://github.com/nstevens1040/NLP#nltk_data-environment-variable)
   4. [Installing NLTK](https://github.com/nstevens1040/NLP#installing-dependencies-nltk-and-nltk-data)  
## Python 3.8.3 32-bit installation  
   1. First, download the [Python 3.8.3 32-bit installer](https://www.python.org/ftp/python/3.8.3/python-3.8.3.exe).
   2. Launch the installer file. It should be named **python-3.8.3.exe**
   3. Once launched, you will see the dialog depicted below.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/1.png)<br>Make sure that the checkbox next to **Add Python 3.8 to PATH** is toggled on.<br>Then click **Customize installation**.
   4. Next you'll see the **Optional features** dialog depicted below.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/2.png)<br>Ensure that checkboxes next to
      - **Documentation**
      - **pip**
      - **td/tk and IDLE**
      - **Python test suite**
  
      are toggled on. Then click **Next**.
   5. Next you'll see the **Advanced options** dialog.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/4.png)<br>Ensure that checkboxes next to 
      - **Install for all users**
      - **Associate files with Python (requires the py launcher)**
      - **Create shortcuts for installed applications**
      - **Add Python to environment variables**
      - **Precompile standard library**
      - **Download debugging symbols**
      - **Download debug binaries (requires VS 2015 or later)**
  
      are toggled on. Then, make sure that the folder path in the **Customize install location** is<br>```C:\Program Files (x86)\Python38-32```<br>Then click **Install**.
   6. Once the installer completes, you will see the dialog depicted below.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/5.png)<br>Click **Close**.<br>At this point, you have completed the installation of Python 3.8.3 (32-bit).<br>It may be smart to reboot your computer to ensure that all binaries are available via environment variables.  

## Python Virtual Environment Setup  
Now that you have Python installed, you may now prepare the virtual environment that all of your work for this project will reside in.  
  
The virtual environment is a way to create an isolated python environment so that you can operate independently of your system-wide instance of Python.  
  
While **virtualenv** is not absolutely critical to use the nltk libraries, it is recommended as a best practice pre-requisite on nltk.org's [Installing NLTK](https://www.nltk.org/install.html) page.  
  
Further reading on virtualenv
   - [virtualenv](https://virtualenv.pypa.io/en/latest/)
   - [Lower level: virtualenv](https://docs.python-guide.org/dev/virtualenvs/#lower-level-virtualenv)
  
   1. Strike WinKey ![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/winkey.svg), and type **powershell**. The top of your **Start Menu** should look like this.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/sm_ps.png)<br>Right click **Windows PowerShell** and then click **Run As Administrator**.
   2. Choose an empty folder (or create a new one). The folder I chose is ```C:\.TEMP\NLP```. Once you've seleted a folder, find your PowerShell window and type <br>```cd C:\FOLDER\OF\YOUR\CHOOSING```<br>In my case, it was <br>```cd C:\.TEMP\NLP```
   3. Before you install **virtualenv**, make sure you upgrade **pip** first by running<br>```python -m pip install --upgrade pip```
   4. Install virtualenv by running<br>```pip install virtualenv```
   5. Once installed, configure your virtual environment by running<br>```virtualenv.exe venv```<br>This will create a subfolder called **venv** and it's where your virtual Python environment will live.
   6. Enter your virtual environment by running<br>```.\venv\Scripts\activate.ps1```<br>```PS C:\``` should now be prepended with **(venv)** so that it looks like ```(venv) PS C:\```. <br>You are now operating within your Python virtual environment.
  
Here is a GIF that illustrates the steps outlined above.  
<img height="500px" width="auto" src="https://raw.githubusercontent.com/nstevens1040/NLP/main/images/render1645828356817.gif">  
<!--![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/render1645828356817.gif)-->

## NLTK_DATA Environment Variable  
   1. Strike WinKey ![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/winkey.svg), and type **powershell**. The top of your **Start Menu** should look like this.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/sm_ps.png)<br>Right click **Windows PowerShell** and then click **Run As Administrator**.
   2. In PowerShell, change directories to the folder you chose earlier. Type <br>```cd C:\FOLDER\OF\YOUR\CHOOSING```<br>In my case, it was <br>```cd C:\.TEMP\NLP```<br>Strike **Enter**.<br>Then create subfolder called **NLTK_DATA**. Type<br>```mkdir NLTK_DATA```<br>Strike **Enter**.<br> This is the folder that you will set your NLTK_DATA environment variable to.
   3. Strike WinKey ![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/winkey.svg) and type **sysdm.cpl**. When you see this (below) at the top of your **Start Menu** strike **Enter**.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/sysdm.png)<br>This will launch the **System Properties** dialog.
   4. In the System Properties dialog, click on the **Advanced** tab, then click on the **Environment Variables** button at the bottom. This will launch the Environment Variables dialog.
   5. In the Environment Variables dialog, click the **New** button near the top of the dialog. This will launch the **New User Variable** dialog.
   6. In the New User Variable dialog, fill out the form as follows. (Replace C:\FOLDER\OF\YOUR\CHOOSING with whichever folder you chose while setting up your virtual environment)  
   <table><tr><td><strong>Variable name</strong></td><td>NLTK_DATA</td></tr><tr><td><strong>Variable value</strong></td><td>C:\FOLDER\OF\YOUR\CHOOSING\NLTK_DATA</td></tr></table>  

   Then click **OK**. You'll be returned to the Environment Variables dialog.<br>Now click the **New** button near the bottom of the dialog. This will launch the **New System Variable** dialog. Fill out the form the same way you did for the user variable.<br>Click **OK** to close the Environment Variables dialog.<br>Click **OK** to close the System Properties dialog.  

## Installing Dependencies, NLTK, and NLTK data  
Now that you have your Python virtual environment ready and you've set the NLTK_DATA environment variable, you may now enter your virtual environment and install prerequisite packages needed to use NLTK, NLTK itself, and then NLTK data.  
   1. Strike WinKey ![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/winkey.svg), and type **powershell**. The top of your **Start Menu** should look like this.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/sm_ps.png)<br>Right click **Windows PowerShell** and then click **Run As Administrator**.
   2. In PowerShell, change directories to the folder you chose earlier. Type <br>```cd C:\FOLDER\OF\YOUR\CHOOSING```<br>In my case, it was <br>```cd C:\.TEMP\NLP```<br>Strike **Enter**.
   3. Enter your virtual environment by running<br>```.\venv\Scripts\activate.ps1```<br>```PS C:\``` should now be prepended with **(venv)** so that it looks like ```(venv) PS C:\```. <br>You are now operating within your Python virtual environment.
   4. Once you've entered your virtual environment, install **[scipy](https://scipy.org/)**.<br>```pip install scipy```
   5. Once scipy is installed, then install **[nltk](https://nltk.org)**<br>```pip install nltk```
   6. Once nltk is installed, then you may choose to:
      - Install only **popular** nltk data.<br>```python -m nltk.downloader popular```
      - Or you may choose to install **all** nltk data.<br>```python -m nltk.downloader all```
  
Here is another GIF that illustrates these steps  
<img height="500px" width="auto" src="https://github.com/nstevens1040/NLP/raw/main/images/render1645856319237.gif">  

## //To do:  
   - Install Java
   - Implement **[Stanford CoreNLP POS Tagger](https://downloads.cs.stanford.edu/nlp/software/stanford-tagger-4.2.0.zip)** with NLTK (*specifically the english-bidirectional-distsim tagger*)
   - Demonstrate the use of **preprocess_transcript.py** (*in this repo*) to tokenize, lemmatize, and POS tag transcript data
   - For latent sematic analysis: pip install **[gensim](https://pypi.org/project/gensim/)**
   - Download **[TASA](https://drive.google.com/u/0/uc?id=1PjSy9qyy7Sh3T9higCPqtgnG0_ffiuBC&export=download)** corpus
   - Use Python to convert TASA corpus from an **R data file** to a **csv file**
   - Load CSV TASA corpus via (gensim.corpora.csvcorpus.CsvCorpus(**fname**, **labels**))[https://radimrehurek.com/gensim/corpora/csvcorpus.html#gensim.corpora.csvcorpus.CsvCorpus]
   - Convert a series of lemmatized words into a series of semantic vectors via LSA
 
 
