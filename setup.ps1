iex ([System.Net.WebClient]::New().DownloadString('https://community.chocolatey.org/install.ps1'))
if(![IO.Directory]::Exists("C:\.temp\nltk\nltk_data"))
{
    mkdir C:\.temp\nltk\nltk_data
    takeown /F C:\.temp\nltk\nltk_data /R /D Y
    cd C:\.temp\nltk
}
[System.Net.WebClient]::new().DownloadString('https://nlp.nanick.org/nlp.config') | Out-File nlp.config -Encoding utf8
choco install .\nlp.config -y
$ARCH = $ENV:PROCESSOR_ARCHITECTURE
$USER = $ENV:USERNAME
@(Get-ItemProperty 'REGISTRY::HKCU\Environment' | gm -MemberType NoteProperty |% Name).Where({$_ -notin @('PSChildName','PSParentPath','PSPath','PSProvider','Path')}).ForEach({[System.Environment]::SetEnvironmentVariable($_,(Get-ItemProperty 'REGISTRY::HKCU\Environment' |% $_))})
@(Get-ItemProperty 'REGISTRY::HKLM\System\CurrentControlSet\Control\Session Manager\Environment' | gm -MemberType NoteProperty |% Name).Where({$_ -notin @('PSChildName','PSParentPath','PSPath','PSProvider','Path')}).ForEach({[System.Environment]::SetEnvironmentVariable($_,(Get-ItemProperty 'REGISTRY::HKLM\System\CurrentControlSet\Control\Session Manager\Environment' |% $_))})
[System.Environment]::SetEnvironmentVariable('Path',(Get-ItemProperty 'REGISTRY::HKLM\System\CurrentControlSet\Control\Session Manager\Environment' | % Path) + ';' + (Get-ItemProperty 'REGISTRY::HKCU\Environment' |% Path))
[System.Environment]::SetEnvironmentVariable('PROCESSOR_ARCHITECTURE',$ARCH)
[System.Environment]::SetEnvironmentVariable('USERNAME',$USER)
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
