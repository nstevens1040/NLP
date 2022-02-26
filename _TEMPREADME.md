## NLTK Environment Setup Procedure  
### Python 3.8.3 32-bit installation  
   1. First, download the [Python 3.8.3 32-bit installer](https://www.python.org/ftp/python/3.8.3/python-3.8.3.exe).
   2. Launch the installer file. It should be named **python-3.8.3.exe**
   3. Once launched, you will see the dialog depicted below.<br>![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/1.png)<br>Make sure that the checkbox next to **Add Python 3.8 to PATH** is toggled on <br>Then click **Customize installation**.
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

### Python Virtual Environment Setup  
Now that you have Python installed, you may now prepare the virtual environment that all of your work for this project will reside in.  
  
The virtual environment is a way to create an isolated python environment so that you can operate independently of your system-wide instance of Python.  
  
While **virtualenv** isn't absolutely critical to use the nltk libraries, it is recommended as a best practice pre-requisite on nltk.org's [Installing NLTK](https://www.nltk.org/install.html) page.  
  
Further reading on virtualenv
   - [virtualenv](https://virtualenv.pypa.io/en/latest/)
   - [Lower level: virtualenv](https://docs.python-guide.org/dev/virtualenvs/#lower-level-virtualenv)

   1. Strike WinKey ![](https://github.com/nstevens1040/NLP/blob/main/images/winkey.svg), Right click **Windows PowerShell**, and then click **Run As Administrator**.
   2. Choose an empty folder (or create a new one). The folder I chose is ```C:\.TEMP\NLP```. Once you've seleted a folder, find your PowerShell window and type <br>```cd C:\FOLDER\OF\YOUR\CHOOSING```<br>In my case, it was <br>```cd C:\.TEMP\NLP```
   3. Before you install **virtualenv**, make sure you upgrade **pip** first by running<br>```python -m pip install --upgrade pip```
   4. Install virtualenv by running<br>```pip install virtualenv```
   5. Once installed, configure your virtual environment by running<br>```virtualenv.exe venv```<br>This will create a subfolder called **venv** and it's where your virtual Python environment will live.
   6. Enter your virtual environment by running<br>```.\venv\Scripts\activate.ps1```<br>```PS C:\``` should now be prepended with **(venv)** so that it looks like ``(venv) PS C:\``. <br>You are now operating within your Python virtual environment.
  
Here is a GIF that illustrates the steps outlined above.  
![](https://raw.githubusercontent.com/nstevens1040/NLP/main/images/render1645828356817.gif)  
