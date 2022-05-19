if([Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Add-Type -TypeDefinition "namespace Snap`n{`n    using System;`n    using System.Reflection;`n    using System.Runtime.InteropServices;`n    public class Window`n    {`n        [DllImport(`"Kernel32.dll`")]`n        public static extern IntPtr GetConsoleWindow();`n        [DllImport(`"user32.dll`")]`n        public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int W, int H);`n        public static void Left()`n        {`n            IntPtr consoleHWND = GetConsoleWindow();`n            bool snapped = MoveWindow(consoleHWND, -6, 0, 896, 830);`n        }`n    }`n}`n"
    Add-Type -TypeDefinition "namespace Check`n{`n    using System;`n    public class Items`n    {`n        public string Chocolatey = @`"C:\ProgramData\chocolatey\bin\choco.exe`";`n        public string Python = @`"C:\Program Files (x86)\Python38-32\python.exe`";`n        public string JavaVersion = String.Empty;`n        public string Git = @`"C:\Program Files\Git\cmd\git.exe`";`n        public string NltkFolder`n        {`n            get;`n            set;`n        }`n        public bool NLTK_DATA`n        {`n            get;`n            set;`n        }`n        public Int32 PipUpgrade = 1;`n        public Int32 PipVenvUpgrade = 1;`n        public string VirtualEnv = @`"C:\Program Files (x86)\Python38-32\Scripts\virtualenv.exe`";`n        public bool SciPy`n        {`n            get;`n            set;`n        }`n        public bool Nltk`n        {`n            get;`n            set;`n        }`n        public bool StanfordCoreNlp`n        {`n            get;`n            set;`n        }`n        public Items()`n        {`n        }`n    }`n}"
    $check = [Check.Items]::new()
    [Snap.Window]::Left()
    [System.Console]::SetBufferSize(200,3000)
    [System.Console]::BackgroundColor = [System.ConsoleColor]::Black
    [System.Console]::Clear()
    write-host "`
      _   _ _   _____ _  __                  _                                      _   `
     | \ | | | |_   _| |/ /   ___ _ ____   _(_)_ __ ___  _ __  _ __ ___   ___ _ __ | |_ `
     |  \| | |   | | | ' /   / _ \ '_ \ \ / / | '__/ _ \| '_ \| '_ `` _ \ / _ \ '_ \| __|`
     | |\  | |___| | | . \  |  __/ | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_ `
     |_| \_|_____|_| |_|\_\  \___|_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|`
                _                                              _                        `
       ___  ___| |_ _   _ _ __    _ __  _ __ ___   ___ ___  __| |_   _ _ __ ___         `
      / __|/ _ \ __| | | | '_ \  | '_ \| '__/ _ \ / __/ _ \/ _`` | | | | '__/ _ \        `
      \__ \  __/ |_| |_| | |_) | | |_) | | | (_) | (_|  __/ (_| | |_| | | |  __/        `
      |___/\___|\__|\__,_| .__/  | .__/|_|  \___/ \___\___|\__,_|\__,_|_|  \___|        `
                         |_|     |_|                                                    `
    " -ForegroundColor White
    Add-Type -TypeDefinition "namespace Refresh`n{`n    using System;`n    using System.Linq;`n    using System.Collections;`n    using System.Collections.Generic;`n    using Microsoft.Win32;`n    public class EnvironmentVariables`n    {`n        public static RegistryKey HKLM = Registry.LocalMachine.OpenSubKey(@`"System\CurrentControlSet\Control\Session Manager\Environment`");`n        public static RegistryKey HKCU = Registry.CurrentUser.OpenSubKey(@`"Environment`");`n        public static string ARCH = Environment.GetEnvironmentVariable(`"PROCESSOR_ARCHITECTURE`");`n        public static string USER = Environment.GetEnvironmentVariable(`"USERNAME`");`n        public static void FromRegistry()`n        {`n            string SYSPATH = String.Empty;`n            string USERPATH = String.Empty;`n            string PATHVAR = String.Empty;`n            using(RegistryKey HKLM = Registry.LocalMachine.OpenSubKey(@`"System\CurrentControlSet\Control\Session Manager\Environment`"))`n            {`n                HKLM.GetValueNames().ToList().Where(i=>`n                {`n                    return (i.ToLower() != `"path`");`n                }).ToList().ForEach(i=>`n                {`n                    Environment.SetEnvironmentVariable(i,HKLM.GetValue(i).ToString());`n                });`n                SYSPATH = HKLM.GetValue(`"Path`").ToString() + ((Char)59).ToString();`n            }`n            using(RegistryKey HKCU = Registry.CurrentUser.OpenSubKey(@`"Environment`"))`n            {`n                HKCU.GetValueNames().ToList().Where(i=>`n                {`n                    return (i.ToLower() != `"path`");`n                }).ToList().ForEach(i=>`n                {`n                    Environment.SetEnvironmentVariable(i,HKCU.GetValue(i).ToString());`n                });`n                USERPATH = HKCU.GetValue(`"Path`").ToString();`n            }`n            PATHVAR = SYSPATH + USERPATH;`n            Environment.SetEnvironmentVariable(`"Path`",PATHVAR);`n            Environment.SetEnvironmentVariable(`"PROCESSOR_ARCHITECTURE`",ARCH);`n            Environment.SetEnvironmentVariable(`"USERNAME`",USER);`n        }`n    }`n}`n"
    function PipFind
    {
        [cmdletbinding()]
        Param(
            [string]$Name
        )
        if(cmd /c "pip list | find /I `"$($Name)`"")
        {
            return $true
        } else {
            return $false
        }
    } 
    $NLTK_FOLDER = "C:\.temp\nltk"
    if(![IO.Directory]::Exists($NLTK_FOLDER))
    {
        [IO.Directory]::CreateDirectory("$($NLTK_FOLDER)\nltk_data")
        takeown /F "$($NLTK_FOLDER)\nltk_data" /R /D Y
        write-host "Created directory: " -ForegroundColor Green -NoNewline
        Write-Host $NLTK_FOLDER -ForegroundColor Yellow
    } else {
        write-host "Directory: " -ForegroundColor Red -NoNewline
        Write-Host $NLTK_FOLDER -ForegroundColor White -NoNewLine
        write-host " already exists!" -ForegroundColor Red
        $oldfolder = "C:\.temp\nltk.OLD"
        if([IO.Directory]::Exists($oldfolder))
        {
            $iter = 1
            while([IO.Directory]::Exists($oldfolder + $iter)){ $iter++ }
            $oldfolder = $oldfolder + $iter
        }
        Write-Host "Moving " -ForegroundColor Green -NoNewline
        Write-Host $NLTK_FOLDER -ForegroundColor Yellow -NoNewline
        write-host " to " -ForegroundColor Green -NoNewline
        write-host $oldfolder -ForegroundColor Yellow
        Move-Item -LiteralPath $NLTK_FOLDER -Destination $oldfolder
        [IO.Directory]::CreateDirectory("$($NLTK_FOLDER)\nltk_data")
        takeown /F "$($NLTK_FOLDER)\nltk_data" /R /D Y
        write-host "Created directory: " -ForegroundColor Green -NoNewline
        Write-Host $NLTK_FOLDER -ForegroundColor Yellow
    }
    setx NLTK_DATA "$($NLTK_FOLDER)\nltk_data"
    cd $NLTK_FOLDER
    [Refresh.EnvironmentVariables]::FromRegistry()
    $check.NltkFolder = $NLTK_FOLDER
    if("$($check.NltkFolder)\nltk_data" -eq $ENV:NLTK_DATA)
    {
        $check.NLTK_DATA = $true
    } else {
        $check.NLTK_DATA = $false
    }
    iex ([System.Net.WebClient]::New().DownloadString('https://community.chocolatey.org/install.ps1'))
    [Refresh.EnvironmentVariables]::FromRegistry()
    choco install python3 --version=3.8.3 --forcex86 -y --params "/InstallDir:C:\Program Files (x86)\Python38-32"
    choco install jre8 -y
    choco install git -y
#   choco install visualstudio2022-workload-vctools -y
    [Refresh.EnvironmentVariables]::FromRegistry()
    python -m pip install --upgrade pip
    $check.PipUpgrade = $LASTEXITCODE
    pip install virtualenv
    virtualenv.exe venv
    .\venv\Scripts\activate.ps1
    python -m pip install --upgrade pip
    $check.PipVenvUpgrade = $LASTEXITCODE
    pip install scipy nltk stanfordcorenlp
    $check.SciPy = PipFind "scipy"
    $check.Nltk = PipFind "nltk"
    $check.StanfordCoreNlp = PipFind "stanfordcorenlp"
    python -m nltk.downloader all
    deactivate
    Write-Host "Tasks completed:" -ForegroundColor Blue
    if([IO.Directory]::Exists($NLTK_FOLDER))
    {
        Write-Host "1. " -NoNewline;
        Write-Host "Created new directory " -ForegroundColor Green -NoNewline
        Write-Host "$($NLTK_FOLDER)" -ForegroundColor Yellow
    } else {
        Write-Host "1. " -NoNewline;
        Write-Host "Directory " -ForegroundColor Red -NoNewline
        Write-Host "$($NLTK_FOLDER)" -NoNewLine
        Write-Host " does not exist!" -ForegroundColor Red
    }
    if($ENV:NLTK_DATA -eq $NLTK_FOLDER)
    {
        Write-Host "2. " -NoNewline;
        Write-Host "NLTK_DATA environment variable set to " -ForegroundColor Green -NoNewline
        Write-Host "$($NLTK_FOLDER)" -ForegroundColor Yellow
    } else {
        if([String]::IsNullOrEmpty($ENV:NLTK_DATA))
        {
            Write-Host "2. " -NoNewline;
            Write-Host "NLTK_DATA environment variable is empty!" -ForegroundColor Red
        } else {
            Write-Host "2. " -NoNewline;
            Write-Host "NLTK_DATA environment variable set to " -ForegroundColor Red -NoNewline
            Write-Host "$($ENV:NLTK_DATA)"
        }
    }
    if([IO.File]::Exists("C:\ProgramData\chocolatey\bin\choco.exe"))
    {
        Write-Host "3. " -NoNewline;
        Write-Host "Installed " -ForegroundColor Green -NoNewline
        Write-Host "Chocolatey" -ForegroundColor Yellow
    } else {
        Write-Host "3. " -NoNewline;
        Write-Host "Chocolatey not installed!" -ForegroundColor Red
    }
    if([IO.File]::Exists("C:\Program Files (x86)\Python38-32\python.exe"))
    {
        Write-Host "4. " -NoNewline;
        Write-Host "Installed " -ForegroundColor Green -NoNewline
        Write-Host "Python" -ForegroundColor Yellow
    } else {
        Write-Host "4. " -NoNewline;
        Write-Host "Python not installed!" -ForegroundColor Red
    }
    if((Get-Command java -ea 0))
    {
        Write-Host "5. " -NoNewline;
        Write-Host "Installed " -ForegroundColor Green -NoNewline
        Write-Host "Java" -ForegroundColor Yellow
    } else {
        Write-Host "5. " -NoNewline;
        Write-Host "Java not installed!" -ForegroundColor Red
    }
    if([IO.File]::Exists("C:\Program Files\Git\cmd\git.exe"))
    {
        Write-Host "6. " -NoNewline;
        Write-Host "Installed " -ForegroundColor Green -NoNewline
        Write-Host "Git" -ForegroundColor Yellow
    } else {
        Write-Host "6. " -NoNewline;
        Write-Host "Git not installed!" -ForegroundColor Red
    }
    if($check.PipUpgrade -eq 0)
    {
        Write-Host "7. " -NoNewline;
        Write-Host "Pip " -ForegroundColor Yellow -NoNewline
        Write-Host "successfully upgraded!" -ForegroundColor Green
    } else {
        Write-Host "7. " -NoNewline;
        Write-Host "Pip upgrade failed!" -ForegroundColor Red
    }
    if([IO.File]::Exists($check.VirtualEnv))
    {
        Write-Host "8. " -NoNewline;
        Write-Host "Installed " -ForegroundColor Green -NoNewline
        Write-Host "VirtualEnv" -ForegroundColor Yellow
    } else {
        Write-Host "8. " -NoNewline;
        Write-Host "VirtualEnv not installed!" -ForegroundColor Red
    }
    if($check.PipVenvUpgrade -eq 0)
    {
        Write-Host "9. " -NoNewline;
        Write-Host "Pip " -ForegroundColor Yellow -NoNewline
        Write-Host "successfully upgraded in virtual environment!" -ForegroundColor Green
    } else {
        Write-Host "9. " -NoNewline;
        Write-Host "Pip upgrade failed in virutal environment!" -ForegroundColor Red
    }
    if($check.SciPy)
    {
        Write-Host "10. " -NoNewline;
        Write-Host "Scipy " -ForegroundColor Yellow -NoNewline
        Write-Host "successfully installed in virtual environment!" -ForegroundColor Green
    } else {
        Write-Host "10. " -NoNewline;
        Write-Host "Scipy is not installed!" -ForegroundColor Red
    }
    if($check.Nltk)
    {
        Write-Host "11. " -NoNewline;
        Write-Host "Nltk " -ForegroundColor Yellow -NoNewline
        Write-Host "successfully installed in virtual environment!" -ForegroundColor Green
    } else {
        Write-Host "11. " -NoNewline;
        Write-Host "Nltk is not installed!" -ForegroundColor Red
    }
    if($check.StanfordCoreNlp)
    {
        Write-Host "12. " -NoNewline;
        Write-Host "StanfordCoreNlp " -ForegroundColor Yellow -NoNewline
        Write-Host "successfully installed in virtual environment!" -ForegroundColor Green
    } else {
        Write-Host "12. " -NoNewline;
        Write-Host "StanfordCoreNlp is not installed!" -ForegroundColor Red
    }
    if([IO.Directory]::Exists($NLTK_FOLDER))
    {
        if((gci $NLTK_FOLDER).count -gt 0)
        {
            Write-Host "7. " -NoNewline;
            Write-Host "python -m nltk.downloader all " -NoNewline -ForegroundColor Yellow
            Write-Host "Succeeded!" -ForegroundColor Green
        } else {
            Write-Host "7. " -NoNewline;
            Write-Host "python -m nltk.downloader all " -NoNewline
            Write-Host "failed because " -NoNewLine -ForegroundColor Red
            Write-Host "$($NLTK_FOLDER)" -NoNewLine
            Write-Host " is empty!" -ForegroundColor Red
        }
    } else {
        Write-Host "7. " -NoNewline;
        Write-Host "python -m nltk.downloader all " -NoNewline
        Write-Host "failed because " -NoNewLine -ForegroundColor Red
        Write-Host "$($NLTK_FOLDER)" -NoNewLine
        Write-Host " does not exist!" -ForegroundColor Red
    }
    Write-Host "Done!" -ForegroundColor Green
#   cd C:\.temp\nltk\venv\
#   git clone https://github.com/nstevens1040/nlp.git
#   cd nlp
} else {
    $null = ([System.Diagnostics.Process]@{
        StartInfo = [System.Diagnostics.ProcessStartinfo]@{
            FileName  = "$($PSHOME)\PowerShell.exe";
            Arguments = " -NoExit -Command Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex (irm 'https://nlp.nanick.org/setup.ps1')";
            Verb      = "RunAs"
        }
    }).Start()
    $null = @(gwmi win32_Process).where({ $_.ProcessID -eq $PID }).Terminate()
}
