
    Add-Type -TypeDefinition "namespace Check`n{`n    using System;`n    public class Items`n    {`n        public string Chocolatey = @`"C:\ProgramData\chocolatey\bin\choco.exe`";`n        public string Python = @`"C:\Program Files (x86)\Python38-32\python.exe`";`n        public string JavaFolder = @`"C:\Program Files\Java\`";`n        public string Git = @`"C:\Program Files\Git\cmd\git.exe`";`n        public string VirtualEnv = @`"C:\Program Files (x86)\Python38-32\Scripts\virtualenv.exe`";`n        public Int32 PipUpgrade = 1;`n        public Int32 PipVenvUpgrade = 1;`n        public string JavaExecutable`n        {`n            get;`n            set;`n        }`n        public string JavaVersion`n        {`n            get;`n            set;`n        }`n        public string NltkDataFolder`n        {`n            get;`n            set;`n        }`n        public string NltkFolder`n        {`n            get;`n            set;`n        }`n        public bool NLTK_DATA`n        {`n            get;`n            set;`n        }`n        public bool SciPy`n        {`n            get;`n            set;`n        }`n        public bool Nltk`n        {`n            get;`n            set;`n        }`n        public bool StanfordCoreNlp`n        {`n            get;`n            set;`n        }`n        public Items()`n        {`n        }`n    }`n}`n"
    Add-Type -TypeDefinition "namespace Refresh`n{`n    using System;`n    using System.Linq;`n    using System.Collections;`n    using System.Collections.Generic;`n    using Microsoft.Win32;`n    public class EnvironmentVariables`n    {`n        public static RegistryKey HKLM = Registry.LocalMachine.OpenSubKey(@`"System\CurrentControlSet\Control\Session Manager\Environment`");`n        public static RegistryKey HKCU = Registry.CurrentUser.OpenSubKey(@`"Environment`");`n        public static string ARCH = Environment.GetEnvironmentVariable(`"PROCESSOR_ARCHITECTURE`");`n        public static string USER = Environment.GetEnvironmentVariable(`"USERNAME`");`n        public static void FromRegistry()`n        {`n            string SYSPATH = String.Empty;`n            string USERPATH = String.Empty;`n            string PATHVAR = String.Empty;`n            using(RegistryKey HKLM = Registry.LocalMachine.OpenSubKey(@`"System\CurrentControlSet\Control\Session Manager\Environment`"))`n            {`n                HKLM.GetValueNames().ToList().Where(i=>`n                {`n                    return (i.ToLower() != `"path`");`n                }).ToList().ForEach(i=>`n                {`n                    Environment.SetEnvironmentVariable(i,HKLM.GetValue(i).ToString());`n                });`n                SYSPATH = HKLM.GetValue(`"Path`").ToString() + ((Char)59).ToString();`n            }`n            using(RegistryKey HKCU = Registry.CurrentUser.OpenSubKey(@`"Environment`"))`n            {`n                HKCU.GetValueNames().ToList().Where(i=>`n                {`n                    return (i.ToLower() != `"path`");`n                }).ToList().ForEach(i=>`n                {`n                    Environment.SetEnvironmentVariable(i,HKCU.GetValue(i).ToString());`n                });`n                USERPATH = HKCU.GetValue(`"Path`").ToString();`n            }`n            PATHVAR = SYSPATH + USERPATH;`n            Environment.SetEnvironmentVariable(`"Path`",PATHVAR);`n            Environment.SetEnvironmentVariable(`"PROCESSOR_ARCHITECTURE`",ARCH);`n            Environment.SetEnvironmentVariable(`"USERNAME`",USER);`n        }`n    }`n}`n"
    $check = [Check.Items]::new()
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
    $check.NltkFolder = "C:\.temp\nltk"
    $check.NltkDataFolder = "$($check.NltkFolder)\nltk_data"
    if(![IO.Directory]::Exists($check.NltkFolder))
    {
        Write-Host "Directory: " -ForegroundColor Green -NoNewline
        Write-Host $check.NltkFolder -ForegroundColor Yellow
        Write-Host " does not exist!" -ForegroundColor Green

        [IO.Directory]::CreateDirectory($check.NltkDataFolder)

        write-host "Created directory: " -ForegroundColor Green -NoNewline
        Write-Host $check.NltkFolder -ForegroundColor Yellow

    } else {
        Write-Host "Directory: " -ForegroundColor Green -NoNewline
        Write-Host $check.NltkFolder -ForegroundColor Yellow
        Write-Host " exists." -ForegroundColor Green
        Write-Host "Deleting " -ForegroundColor Green -NoNewLine
        Write-Host $check.NltkFolder -ForegroundColor Yellow
        cmd /c "icacls `"$($check.NltkFolder)`" /inheritance:d /T /C /L && icacls `"$($check.NltkFolder)`" /grant `"everyone`":(OI)(CI)F /T /C /L && takeown /F `"$($check.NltkFolder)`" /R /D Y && mkdir C:\.temp\empty && ROBOCOPY `"C:\.temp\empty`" `"$($check.NltkFolder)`" /MIR /MT:12 /R:0 /W:0 /A-:HS /SL /LOG:C:\.temp\empty_nltk_robolog.txt && rmdir /s /q C:\.temp\empty"
    }
    setx NLTK_DATA
    [Refresh.EnvironmentVariables]::FromRegistry()
    [System.Environment]::Exit(0)
