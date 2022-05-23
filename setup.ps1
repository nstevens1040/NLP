if([Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Add-Type -TypeDefinition "namespace Check`n{`n    using System;`n    public class Items`n    {`n        public string Chocolatey = @`"C:\ProgramData\chocolatey\bin\choco.exe`";`n        public string Python = @`"C:\Program Files (x86)\Python38-32\python.exe`";`n        public string JavaFolder = @`"C:\Program Files\Java\`";`n        public string Git = @`"C:\Program Files\Git\cmd\git.exe`";`n        public string VirtualEnv = @`"C:\Program Files (x86)\Python38-32\Scripts\virtualenv.exe`";`n        public Int32 PipUpgrade = 1;`n        public Int32 PipVenvUpgrade = 1;`n        public string JavaExecutable`n        {`n            get;`n            set;`n        }`n        public string JavaVersion`n        {`n            get;`n            set;`n        }`n        public string NltkDataFolder`n        {`n            get;`n            set;`n        }`n        public string NltkFolder`n        {`n            get;`n            set;`n        }`n        public bool NLTK_DATA`n        {`n            get;`n            set;`n        }`n        public bool SciPy`n        {`n            get;`n            set;`n        }`n        public bool Nltk`n        {`n            get;`n            set;`n        }`n        public bool StanfordCoreNlp`n        {`n            get;`n            set;`n        }`n        public Items()`n        {`n        }`n    }`n}`n"
    Add-Type -TypeDefinition "namespace Refresh`n{`n    using System;`n    using System.Linq;`n    using System.Collections;`n    using System.Collections.Generic;`n    using Microsoft.Win32;`n    public class EnvironmentVariables`n    {`n        public static RegistryKey HKLM = Registry.LocalMachine.OpenSubKey(@`"System\CurrentControlSet\Control\Session Manager\Environment`");`n        public static RegistryKey HKCU = Registry.CurrentUser.OpenSubKey(@`"Environment`");`n        public static string ARCH = Environment.GetEnvironmentVariable(`"PROCESSOR_ARCHITECTURE`");`n        public static string USER = Environment.GetEnvironmentVariable(`"USERNAME`");`n        public static void FromRegistry()`n        {`n            string SYSPATH = String.Empty;`n            string USERPATH = String.Empty;`n            string PATHVAR = String.Empty;`n            using(RegistryKey HKLM = Registry.LocalMachine.OpenSubKey(@`"System\CurrentControlSet\Control\Session Manager\Environment`"))`n            {`n                HKLM.GetValueNames().ToList().Where(i=>`n                {`n                    return (i.ToLower() != `"path`");`n                }).ToList().ForEach(i=>`n                {`n                    Environment.SetEnvironmentVariable(i,HKLM.GetValue(i).ToString());`n                });`n                SYSPATH = HKLM.GetValue(`"Path`").ToString() + ((Char)59).ToString();`n            }`n            using(RegistryKey HKCU = Registry.CurrentUser.OpenSubKey(@`"Environment`"))`n            {`n                HKCU.GetValueNames().ToList().Where(i=>`n                {`n                    return (i.ToLower() != `"path`");`n                }).ToList().ForEach(i=>`n                {`n                    Environment.SetEnvironmentVariable(i,HKCU.GetValue(i).ToString());`n                });`n                USERPATH = HKCU.GetValue(`"Path`").ToString();`n            }`n            PATHVAR = SYSPATH + USERPATH;`n            Environment.SetEnvironmentVariable(`"Path`",PATHVAR);`n            Environment.SetEnvironmentVariable(`"PROCESSOR_ARCHITECTURE`",ARCH);`n            Environment.SetEnvironmentVariable(`"USERNAME`",USER);`n        }`n    }`n}`n"
    $check = [Check.Items]::new()
#   [System.Console]::SetBufferSize(200,3000)
   [System.Console]::BackgroundColor = [System.ConsoleColor]::Black
   [System.Console]::Clear()
    write-host "`
    888b    888 888      8888888b.                         888                      `
    8888b   888 888      888   Y88b                        888                      `
    88888b  888 888      888    888                        888                      `
    888Y88b 888 888      888   d88P      .d8888b   .d88b.  888888 888  888 88888b.  `
    888 Y88b888 888      8888888P`"       88K      d8P  Y8b 888    888  888 888 `"88b `
    888  Y88888 888      888             `"Y8888b. 88888888 888    888  888 888  888 `
    888   Y8888 888      888                  X88 Y8b.     Y88b.  Y88b 888 888 d88P `
    888    Y888 88888888 888              88888P'  `"Y8888   `"Y888  `"Y88888 88888P`"  `
                                                                           888      `
                                                                           888      `
                                                                           888      `
    " -ForegroundColor Yellow
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
    $check.NltkFolder = "C:\.temp\nltk"
    $check.NltkDataFolder = "$($check.NltkFolder)\nltk_data"
    if(![IO.Directory]::Exists($check.NltkFolder))
    {
        [IO.Directory]::CreateDirectory($check.NltkDataFolder)
        cmd /c "icacls `"$($check.NltkFolder)`" /inheritance:d /T /C /L && icacls `"$($check.NltkFolder)`" /grant `"everyone`":(OI)(CI)F /T /C /L && takeown /F `"$($check.NltkFolder)`" /R /D Y"
        write-host "Created directory: " -ForegroundColor Green -NoNewline
        Write-Host $check.NltkFolder -ForegroundColor Yellow
    } else {
        write-host "Directory: " -ForegroundColor Red -NoNewline
        Write-Host $check.NltkFolder -ForegroundColor White -NoNewLine
        write-host " already exists!" -ForegroundColor Red
        $oldfolder = "C:\.temp\nltk.OLD"
        if([IO.Directory]::Exists($oldfolder))
        {
            $iter = 1
            while([IO.Directory]::Exists($oldfolder + $iter)){ $iter++ }
            $oldfolder = $oldfolder + $iter
        }
        Write-Host "Moving " -ForegroundColor Green -NoNewline
        Write-Host $check.NltkFolder -ForegroundColor Yellow -NoNewline
        write-host " to " -ForegroundColor Green -NoNewline
        write-host $oldfolder -ForegroundColor Yellow
        cmd /c "icacls `"$($check.NltkFolder)`" /inheritance:d /T /C /L && icacls `"$($check.NltkFolder)`" /grant `"everyone`":(OI)(CI)F /T /C /L && takeown /F `"$($check.NltkFolder)`" /R /D Y"
        Move-Item -LiteralPath $check.NltkFolder -Destination $oldfolder
        [IO.Directory]::CreateDirectory($check.NltkDataFolder)
        cmd /c "icacls `"$($check.NltkFolder)`" /inheritance:d /T /C /L && icacls `"$($check.NltkFolder)`" /grant `"everyone`":(OI)(CI)F /T /C /L && takeown /F `"$($check.NltkFolder)`" /R /D Y"
        write-host "Created directory: " -ForegroundColor Green -NoNewline
        Write-Host $check.NltkFolder -ForegroundColor Yellow
    }
    setx NLTK_DATA $check.NltkDataFolder
    cd $check.NltkFolder
    [Refresh.EnvironmentVariables]::FromRegistry()
    [System.Environment]::Exit(0)
  iex ([System.Net.WebClient]::New().DownloadString('https://community.chocolatey.org/install.ps1'))
  [Refresh.EnvironmentVariables]::FromRegistry()
  choco install python3 --version=3.8.3 --forcex86 -y --params "/InstallDir:C:\Program Files (x86)\Python38-32"
  choco install jre8 -y
  choco install git -y
  choco install visualstudio2022-workload-vctools -y
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
    Write-Host "`nTasks completed:" -ForegroundColor Blue
    if([IO.Directory]::Exists($check.NltkFolder))
    {
        Write-Host "1. " -NoNewline;
        Write-Host "Created new directory " -ForegroundColor Green -NoNewline
        Write-Host "$($check.NltkFolder)" -ForegroundColor Yellow
    } else {
        Write-Host "1. " -NoNewline;
        Write-Host "Directory " -ForegroundColor Red -NoNewline
        Write-Host "$($check.NltkFolder)" -NoNewLine
        Write-Host " does not exist!" -ForegroundColor Red
    }
    if($ENV:NLTK_DATA -eq $check.NltkDataFolder)
    {
        Write-Host "2. " -NoNewline;
        Write-Host "NLTK_DATA environment variable set to " -ForegroundColor Green -NoNewline
        Write-Host "$($ENV:NLTK_DATA)" -ForegroundColor Yellow
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
    if([IO.File]::Exists($check.Chocolatey))
    {
        Write-Host "3. " -NoNewline;
        Write-Host "Installed " -ForegroundColor Green -NoNewline
        Write-Host "Chocolatey" -ForegroundColor Yellow
    } else {
        Write-Host "3. " -NoNewline;
        Write-Host "Chocolatey not installed!" -ForegroundColor Red
    }
    if([IO.File]::Exists($check.Python))
    {
        Write-Host "4. " -NoNewline;
        Write-Host "Installed " -ForegroundColor Green -NoNewline
        Write-Host "Python 3.8.3 32-bit" -ForegroundColor Yellow
    } else {
        Write-Host "4. " -NoNewline;
        Write-Host "Python not installed!" -ForegroundColor Red
    }
    if([IO.Directory]::Exists($check.JavaFolder))
    {
        $check.JavaExecutable = @(gci $check.JavaFolder -Recurse).Where({$_.Name -eq 'java.exe'})[0].FullName
        if(![String]::IsNullOrEmpty($check.JavaExecutable))
        {
            $check.JavaVersion = (cmd /c "`"$($check.JavaExecutable)`" -version 2>&1")[0].Split('"')[1]
            if($check.JavaVersion -match "^1.8")
            {
                Write-Host "5. " -NoNewline;
                Write-Host "Installed " -ForegroundColor Green -NoNewline
                Write-Host "Java Platform SE Binary 64-bit version $($check.JavaVersion)" -ForegroundColor Yellow
            } else {
                Write-Host "5. " -NoNewline;
                Write-Host "Java install failed because Java version is $($check.JavaVersion)!" -ForegroundColor Red
            }
        } else {
            Write-Host "5. " -NoNewline;
            Write-Host "Java install failed because java.exe does not exist in $($check.JavaFolder)!" -ForegroundColor Red
        }
    } else {
        Write-Host "5. " -NoNewline;
        Write-Host "Java install failed because $($check.JavaFolder) does not exist!" -ForegroundColor Red
    }
    if([IO.File]::Exists($check.Git))
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
    if([IO.Directory]::Exists($check.NltkFolder))
    {
        if((gci $check.NltkFolder).count -gt 0)
        {
            Write-Host "13. " -NoNewline;
            Write-Host "python -m nltk.downloader all " -NoNewline -ForegroundColor Yellow
            Write-Host "Succeeded!" -ForegroundColor Green
        } else {
            Write-Host "13. " -NoNewline;
            Write-Host "python -m nltk.downloader all " -NoNewline
            Write-Host "failed because " -NoNewLine -ForegroundColor Red
            Write-Host "$($check.NltkFolder)" -NoNewLine
            Write-Host " is empty!" -ForegroundColor Red
        }
    } else {
        Write-Host "13. " -NoNewline;
        Write-Host "python -m nltk.downloader all " -NoNewline
        Write-Host "failed because " -NoNewLine -ForegroundColor Red
        Write-Host "$($check.NltkFolder)" -NoNewLine
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
           Arguments = " -Command Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex (irm 'https://nlp.nanick.org/setup.ps1'); exit";
           Verb      = "RunAs"
       }
   }).Start()
   [System.Environment]::Exit(0)
}
