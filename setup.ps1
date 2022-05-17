if([Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    [System.Console]::BackgroundColor = [System.ConsoleColor]::Black
    [System.Console]::Clear()
    Write-Host "`
     _   _ _   _______ _  __                  _                                      _`
    | \ | | | |__   __| |/ /                 (_)                                    | |`
    |  \| | |    | |  | ' /    ___ _ ____   ___ _ __ ___  _ __  _ __ ___   ___ _ __ | |`
    | . `` | |    | |  |  <    / _ \ '_ \ \ / / | '__/ _ \| '_ \| '_ `` _ \ / _ \ '_ \| __|`
    | |\  | |____| |  | . \  |  __/ | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_`
    |_| \_|______|_|  |_|\_\  \___|_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|`
             | |                                            | |`
     ___  ___| |_ _   _ _ __    _ __  _ __ ___   ___ ___  __| |_   _ _ __ ___`
    / __|/ _ \ __| | | | '_ \  | '_ \| '__/ _ \ / __/ _ \/ _`` | | | | '__/ _ \`
    \__ \  __/ |_| |_| | |_) | | |_) | | | (_) | (_|  __/ (_| | |_| | | |  __/`
    |___/\___|\__|\__,_| .__/  | .__/|_|  \___/ \___\___|\__,_|\__,_|_|  \___|`
                       | |     | |`
                       |_|     |_|`
    " -ForegroundColor White
    cmd /c "pause"
    Add-Type -TypeDefinition "namespace Refresh`n{`n    using System;`n    using System.Linq;`n    using System.Collections;`n    using System.Collections.Generic;`n    using Microsoft.Win32;`n    public class EnvironmentVariables`n    {`n        public static RegistryKey HKLM = Registry.LocalMachine.OpenSubKey(@`"System\CurrentControlSet\Control\Session Manager\Environment`");`n        public static RegistryKey HKCU = Registry.CurrentUser.OpenSubKey(@`"Environment`");`n        public static string ARCH = Environment.GetEnvironmentVariable(`"PROCESSOR_ARCHITECTURE`");`n        public static string USER = Environment.GetEnvironmentVariable(`"USERNAME`");`n        public static void FromRegistry()`n        {`n            string SYSPATH = String.Empty;`n            string USERPATH = String.Empty;`n            string PATHVAR = String.Empty;`n            using(RegistryKey HKLM = Registry.LocalMachine.OpenSubKey(@`"System\CurrentControlSet\Control\Session Manager\Environment`"))`n            {`n                HKLM.GetValueNames().ToList().Where(i=>`n                {`n                    return (i.ToLower() != `"path`");`n                }).ToList().ForEach(i=>`n                {`n                    Environment.SetEnvironmentVariable(i,HKLM.GetValue(i).ToString());`n                });`n                SYSPATH = HKLM.GetValue(`"Path`").ToString() + ((Char)59).ToString();`n            }`n            using(RegistryKey HKCU = Registry.CurrentUser.OpenSubKey(@`"Environment`"))`n            {`n                HKCU.GetValueNames().ToList().Where(i=>`n                {`n                    return (i.ToLower() != `"path`");`n                }).ToList().ForEach(i=>`n                {`n                    Environment.SetEnvironmentVariable(i,HKCU.GetValue(i).ToString());`n                });`n                USERPATH = HKCU.GetValue(`"Path`").ToString();`n            }`n            PATHVAR = SYSPATH + USERPATH;`n            Environment.SetEnvironmentVariable(`"Path`",PATHVAR);`n            Environment.SetEnvironmentVariable(`"PROCESSOR_ARCHITECTURE`",ARCH);`n            Environment.SetEnvironmentVariable(`"USERNAME`",USER);`n        }`n    }`n}`n"
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
    cd $NLTK_FOLDER
    iex ([System.Net.WebClient]::New().DownloadString('https://community.chocolatey.org/install.ps1'))
    choco install python3 --version=3.8.3 --forcex86 -y --params "/InstallDir:C:\Program Files (x86)\Python38-32"
    choco install jre8 -y
    choco install git -y
    choco install visualstudio2022-workload-vctools -y
    [Refresh.EnvironmentVariables]::FromRegistry()
    python -m pip install --upgrade pip
    pip install virtualenv
    virtualenv.exe venv
    .\venv\Scripts\activate.ps1
    python -m pip install --upgrade pip
    pip install scipy nltk stanfordcorenlp
    python -m nltk.downloader all
    cd C:\.temp\nltk\venv\
    git clone https://github.com/nstevens1040/nlp.git
    cd nlp
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
