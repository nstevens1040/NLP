function Do-SentimentAnalysis
{
    [cmdletbinding()]
    Param()
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -Path C:\.TEMP\BIN\newtonsoft.json.13.0.1\lib\net45\Newtonsoft.Json.dll
    Add-Type -TypeDefinition "namespace Senti`n{`n    using System;`n    public class Row`n    {`n        public Decimal SentimentScore { get; set; }`n        public Decimal SentimentMagnitude { get; set; }`n        public string TranscriptText { get; set; }`n        public Row()`n        {`n        }`n    }`n    public class Ment`n    {`n        public Decimal score { get; set; }`n        public Decimal magnitude { get; set; }`n        public Ment()`n        {`n        }`n    }`n}"
    $sentiment_analysis_script = "import io`nimport tkinter as tk`nfrom tkinter import filedialog as fd`nimport sys`nimport shutil`nimport os`nfrom pathlib import Path`nfrom google.cloud import language_v1`nimport json`nclient = language_v1.LanguageServiceClient()`n`ndir_ = sys.argv[1]`nplaintext_files=[]`nfor i in os.listdir(dir_):`n    fullpath=os.path.join(dir_,i)`n    if os.path.isfile(fullpath):`n        plaintext_files.append(fullpath)`n`nfor transcript_file in plaintext_files:`n    content=open(transcript_file).read()`n    document = language_v1.Document(content=content, type_=language_v1.Document.Type.PLAIN_TEXT)`n    annotations = client.analyze_sentiment(request={'document': document})`n    score = annotations.document_sentiment.score`n    magnitude = annotations.document_sentiment.magnitude`n    sentiment_obj = {}`n    sentiment_obj['score'] = score`n    sentiment_obj['magnitude'] = magnitude`n    jsonfilepath=os.path.dirname(transcript_file) + '\\sentiment\\' + os.path.splitext(os.path.basename(transcript_file))[0] + '_.json'`n    with open(jsonfilepath,'w') as jsf:`n        json.dump(sentiment_obj,jsf)`n`n"
    $file_open = [System.Windows.Forms.OpenFileDialog]::new()
    $file_open.ShowDialog()
    $TranscriptFile = $file_open.FileName
    $file = [io.FileInfo]::New($TranscriptFile)
    $lines = [io.file]::ReadAllLines($file.FullName)
    $folder = [System.IO.Path]::Combine($file.Directory.FullName,[io.path]::GetFileNameWithoutExtension($file.FullName))
    $sentiment_folder = [IO.Path]::Combine($folder,"sentiment")
    if(![io.Directory]::Exists($folder))
    {
        $foi = [io.Directory]::CreateDirectory($folder)
    } else {
        $foi = [io.DirectoryInfo]::New($folder)
    }
    if(![io.Directory]::Exists($sentiment_folder))
    {
        $sfoi = [io.Directory]::CreateDirectory($sentiment_folder)
    } else {
        $sfoi = [io.DirectoryInfo]::New($sentiment_folder)
    }
    cd $foi.FullName
    for($i = 0; $i -lt $lines.Count; $i++)
    {
        $iter = $i
        while("$($iter)".Length -lt 3){ $iter = "0$($iter)" }
        $name = "$($iter)_$($file.Name)"
        $fullname = [io.Path]::Combine($foi.FullName,$name)
        $line = $lines[$i]
        $line_bytes = [System.Text.Encoding]::UTF8.GetBytes($line)
        [io.file]::WriteAllBytes($fullname,$line_bytes)
    }
    python -c $sentiment_analysis_script $foi.FullName
    $pt_files = @(gci -File -Path "$($foi.FullName)" |% FullName)
    $json_files = @(gci -File -Path "$($foi.FullName)\sentiment" |% FullName)
    $all_rows = [System.Collections.Generic.List[Senti.Row]]::new()
    for($i = 0; $i -lt $pt_files.Count; $i++)
    {
        $json_data = [io.file]::ReadAllText($json_files[$i])
        $text = [io.file]::ReadAllText($pt_files[$i])
        $sentiment_obj = [Newtonsoft.Json.JsonConvert]::DeserializeObject($json_data,[Senti.Ment])
        $all_rows.Add([Senti.Row]@{SentimentScore=$sentiment_obj.score; SentimentMagnitude=$sentiment_obj.magnitude; TranscriptText=$text;})
    }
    $csv_file = [System.IO.Path]::Combine($foi.FullName,"$($foi.Name)_sentiment.csv")
    $all_rows | export-csv -NoTypeInformation -Path $csv_file -Encoding UTF8
}
