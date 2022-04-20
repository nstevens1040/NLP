NLTK Environment Setup Procedure
================================

*(The most up-to-date guide lives here &rarr; [https://nlp.nanick.org](https://nlp.nanick.org/))*  
  
### System Requirements
While testing the steps detailed below I found that the [Stanford POS tagger](https://nlp.stanford.edu/software/tagger.shtml) will throw **java.lang.OutOfMemoryError** if the system that it is running on has less than 6GB RAM.  

This guide covers the following steps to set up your NLTK environment in Microsoft Windows

- [NLTK Environment Setup Procedure](#nltk-environment-setup-procedure)
    - [Python 3.8.3 32-bit installation](#python-383-32-bit-installation)
    - [Chocolatey Package Manager installation](#chocolatey-package-manager-installation)
    - [Java Platform SE Binary 64-bit installation](#java-platform-se-binary-64-bit-installation)
    - [Git for Windows 64-bit installation](#git-for-windows-64-bit-installation)
    - [Python Virtual Environment Setup](#python-virtual-environment-setup)
    - [The NLTK\_DATA Environment Variable](#the-nltk_data-environment-variable)
    - [Installing Dependencies, NLTK, and NLTK data](#installing-dependencies-nltk-and-nltk-data)

### Python 3.8.3 32-bit installation[](#python-383-32-bit-installation)

1.  First, download the [Python 3.8.3 32-bit installer.](https://www.python.org/ftp/python/3.8.3/python-3.8.3.exe)
2.  Launch the installer file. It should be named **python-3.8.3.exe**
3.  Once launched, you will see the dialog depicted below.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/python-3.8.3_step_1_.png)  
    Make sure that the checkbox next to **Add Python 3.8 to PATH** is toggled on.  
    Then click **Customize installation.**
    
4.  Next you'll see the **Optional features** dialog depicted below.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/python-3.8.3_step_2.png)  
    Ensure that checkboxes next to
    
    *   ➔ Documentation
    *   ➔ pip
    *   ➔ td/tk and IDLE
    *   ➔ Python test suite
    *   ➔ py launcher
    *   ➔ for all users (requires elevation)
    
    are toggled on. Then click **Next.**
    
5.  Next you'll see the **Advanced options** dialog.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/python-3.8.3_step_3.png)  
    Ensure that checkboxes next to
    
    *   ➔ Install for all users
    *   ➔ Associate files with Python (requires the py launcher)
    *   ➔ Create shortcuts for installed applications
    *   ➔ Add Python to environment variables
    *   ➔ Precompile standard library
    *   ➔ Download debugging symbols
    *   ➔ Download debug binaries (requires VS 2015 or later)
    
    are toggled on.  
      
    Then, make sure that the folder path in the **Customize install location** is  
    `C:\Program Files (x86)\Python38-32`  
    Then click **Install.**
    
6.  Once the installer completes, you will see the dialog depicted below.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/python-3.8.3_step_4.png)  
    Before you close the installer, click on **Disable path length limit.**  
    That part of the dialog will vanish.  
      
    Click **Close.**  
      
    At this point, you have completed the installation of Python 3.8.3 (32-bit).  
    

### Chocolatey Package Manager installation[](#installing-chocolatey-package-manager)

If you're familiar with Linux or Ubuntu, then you've likely used package managers such as **apt,** **yum,** **pacman,** or **rpm.** If you're usually a macOS user, then you may be familiar with **homebrew.**

**[Chocolatey](https://chocolatey.org/)** is a package manager built for Windows. Installing Chocolatey is not required to use NLTK, but I'm including it because this guide would be much longer if I didn't.

1.  Strike WinKey , and type **powershell.**  
      
    **Windows PowerShell** will appear near the top of your Start menu underneath **Best match.**  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/pwsh_sm.png)  
    Right click **Windows PowerShell** and select **Run As Administrator.**
2.  Per [Chocolatey's installation documentation page](https://chocolatey.org/install#individual-method), the method described below is the standard procedure that they offer as a means to installing their software.  
      
    Copy the script below, paste it into PowerShell, and strike **Enter** to install Chocolatey.  
    ```ps1
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));
    ```  

3.  Once you have started the script you will see a fair amount of output messages in your PowerShell console. With the exception of telling you when the installation has completed, these output messages can be safely ignored. Installing Chocolatey will require no further interaction.

This is what the Chocolatey installation looks like  
![](https://raw.githubusercontent.com/nstevens1040/images/main/render1649080447876.gif)  
### Java Platform SE Binary 64-bit installation[](#java-platform-se-803217-64-bit-installation)

1.  Strike WinKey , and type **powershell.**  
      
    **Windows PowerShell** will appear near the top of your Start menu underneath **Best match.**  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/pwsh_sm.png)  
    Right click **Windows PowerShell** and select **Run As Administrator.**
2.  Use **Chocolatey** to install Java by running the command below.  
    ```ps1
    choco install jre8 -y
    ```
4.  The installation script will send output to your PowerShell console. With the exception of telling you when the installation has completed, these output messages can be safely ignored. Installing Java will require no further interaction.

This is what the Java installation looks like  
![](https://raw.githubusercontent.com/nstevens1040/images/main/render1649985907833.gif)  
### Git for Windows 64-bit installation[](#git-for-windows-64-bit-installation)

1.  Strike WinKey , and type **powershell.**  
      
    **Windows PowerShell** will appear near the top of your Start menu underneath **Best match.**  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/pwsh_sm.png)  
    Right click **Windows PowerShell** and select **Run As Administrator.**
2.  Use **Chocolatey** to install Git by running the command below.  
    ```ps1
    choco install git -y
    ```
5.  The installation script will send output to your PowerShell console. With the exception of telling you when the installation has completed, these output messages can be safely ignored. Installing Git will require no further interaction.

This is what the Git installation looks like  
![](https://raw.githubusercontent.com/nstevens1040/images/main/render1649983145626.gif)  
### Python Virtual Environment Setup[](#python-virtual-environment-setup)

Now that you have Python installed, you may now prepare the virtual environment that all of your work for this project will reside in.

The virtual environment is a way to create an isolated python environment so that you can operate independently of your system-wide instance of Python.

While **virtualenv** is not absolutely critical to use the nltk libraries, it is recommended as a best practice pre-requisite on nltk.org's [Installing NLTK](https://www.nltk.org/install.html) page.

Further reading on virtualenv

*   [virtualenv.pypa.io](https://virtualenv.pypa.io/en/latest/)
*   [docs.python-guide.org](https://docs.python-guide.org/dev/virtualenvs/#lower-level-virtualenv)

1.  Strike WinKey , and type **powershell.**  
      
    **Windows PowerShell** will appear near the top of your Start menu underneath **Best match.**  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/pwsh_sm.png)  
    Right click **Windows PowerShell** and select **Run As Administrator.**
2.  Choose an empty folder or create a new one. The folder I chose was `C:\.TEMP\NLP`.  
      
    To create my new folder, I used  
    ```ps1
    mkdir C:\.TEMP\NLP
    ```  
3.  Change directories to your folder of choice. In my case, I used
    ```ps1
    cd C:\.TEMP\NLP
    ```
4.  Before you install **virtualenv**, make sure you upgrade **pip** first  
    ```ps1
    python -m pip install --upgrade pip
    ```
5.  Install virtualenv
    ```ps1
    pip install virtualenv
    ```
6.  Once installed, configure your virtual environment
    ```ps1
    virtualenv.exe venv
    ```
    This will create a subfolder called **venv** and it's where your virtual Python environment will live.
7.  Enter your virtual environment
    ```ps1
    .\venv\Scripts\activate.ps1
    ```
    `PS C:\>` will now be prepended with **(venv)** so that it looks like `(venv) PS C:\>`.  
    You are now operating within your Python virtual environment.

To illustrate the steps described above.  
![](https://raw.githubusercontent.com/nstevens1040/images/main/render1649086376362.gif)  
### The NLTK\_DATA Environment Variable[](#nltk_data-environment-variable)

1.  Strike WinKey , and type **powershell.**  
      
    **Windows PowerShell** will appear near the top of your Start menu.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/searchhost_ZKa2TFqIl7.png)  
    Strike **Enter.**
2.  In PowerShell, change directories to the folder you chose during [this](#firstfolder) step. In my case
    ```ps1
    cd C:\.TEMP\NLP
    ```
3.  Create a subfolder called **NLTK\_DATA.**
    ```ps1
    mkdir NLTK_DATA
    ```
    This is the folder that you will set your NLTK\_DATA environment variable to.
4.  Strike WinKey and type **sysdm.cpl.** You will see sysdm.cpl appear underneath **Best match** in your Start menu.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/searchhost_se1RbhRaUB.png)  
    Strike **Enter.** This will launch the **System Properties** dialog.
5.  In the System Properties dialog, click on the **Advanced** tab.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/systempropertiescomputername_Qrl6DU7vPg.png)
    
6. Then click on the **Environment Variables** button at the bottom. This will launch the Environment Variables dialog.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/systempropertiescomputername_2EIXPHAYF7.png)
    
7. In the Environment Variables dialog, click the **New** button near the top of the dialog. This will launch the **New User Variable** dialog.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/systempropertiescomputername_31ZAKpu9B1.png)
    
8. In the New User Variable dialog, fill out the form by entering **NLTK\_DATA** into the **Variable name** field and the full path to the folder you just created into the **Variable value** field.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/systempropertiescomputername_uWfAj5mHUg.png)  
    Then click **OK.** You'll be returned to the Environment Variables dialog.
    
9. Now click the **New** button near the bottom of the dialog. This will launch the **New System Variable** dialog.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/systempropertiescomputername_uvSZPwKQzp.png)
    
10. In the New System Variable dialog, fill out the form by entering **NLTK\_DATA** into the **Variable name** field and the full path to the folder you just created into the **Variable value** field.  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/systempropertiescomputername_dzhMsQzjgS.png)  
    Then click **OK.** You'll be returned to the Environment Variables dialog.
    Click **OK** to close the Environment Variables dialog.    
    Click **OK** to close the System Properties dialog.
    

You are now finished setting your NLTK\_DATA environment variable.

### Installing Dependencies, NLTK, and NLTK data[](#installing-dependencies-nltk-and-nltk-data)

Now that you have your Python virtual environment ready and you've set the NLTK\_DATA environment variable, you may now enter your virtual environment and install the packages that NLTK relies on, install NLTK itself, and then download NLTK data.

1.  Strike WinKey , and type **powershell.**  
      
    **Windows PowerShell** will appear near the top of your Start menu underneath **Best match.**  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/pwsh_sm.png)  
    Right click **Windows PowerShell** and select **Run As Administrator.**
2.  In PowerShell, change directories to the folder you chose during [this](#firstfolder) step. In my case
    ```ps1
    cd C:\.TEMP\NLP
    ```
4.  Enter your virtual environment by running
    ```ps1
    .\venv\Scripts\activate.ps1
    ```
    `PS C:\>` should now be prepended with **(venv)** so that it looks like `(venv) PS C:\>`.
6.  Once you've entered your virtual environment, install **[scipy](https://scipy.org/)**
    ```ps1
    pip install scipy
    ```
8.  Once scipy is installed, then install **[nltk](https://nltk.org)**
    ```ps1
    pip install nltk
    ```
10. Once nltk is installed, then you may now download nltk data by running the following command.
    ```ps1
    python -m nltk.downloader all
    ```
    To illustrate  
      
    _(The example below only installs popular nltk data. Downloading all of the data takes much longer and produces much more output.)_  
    ![](https://raw.githubusercontent.com/nstevens1040/images/main/render1649083450538.gif)  

![](https://beserver.nanick.org/pixel.gif)  
  
## //To do:  
   - Install **[Chocolatey](https://chocolatey.org/)**
   - Install **[Git](https://git-scm.com/)**
   - Install **[Java](https://www.oracle.com/java/)**
   - Implement **[Stanford CoreNLP POS Tagger](https://downloads.cs.stanford.edu/nlp/software/stanford-tagger-4.2.0.zip)** with NLTK (*specifically the english-bidirectional-distsim tagger*)
   - Demonstrate the use of **preprocess_transcript.py** (*in this repo*) to tokenize, lemmatize, and POS tag transcript data
   - For latent sematic analysis: pip install **[gensim](https://pypi.org/project/gensim/)**
   - Download **[TASA](https://drive.google.com/u/0/uc?id=1PjSy9qyy7Sh3T9higCPqtgnG0_ffiuBC&export=download)** corpus
   - Use Python to convert TASA corpus from an **R data file** to a **csv file**
   - Load CSV TASA corpus via **[gensim.corpora.csvcorpus.CsvCorpus(fname, labels)](https://radimrehurek.com/gensim/corpora/csvcorpus.html#gensim.corpora.csvcorpus.CsvCorpus)**
   - Convert a series of lemmatized words into a series of semantic vectors via LSA
 
 

