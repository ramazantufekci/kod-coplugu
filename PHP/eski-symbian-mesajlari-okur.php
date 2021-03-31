<?php
function getDirContents($dir, &$results = array()) {
    $files = scandir($dir);

    foreach ($files as $key => $value) {
        $path = realpath($dir . DIRECTORY_SEPARATOR . $value);
        if (!is_dir($path)) {
            $results[] = $path;
        } else if ($value != "." && $value != "..") {
            getDirContents($path, $results);
            $results[] = $path;
        }
    }

    return $results;
}
$data = getDirContents(__DIR__."/../");
foreach($data as $dat)
{

    if(!is_dir($dat) && !strstr($dat,'.'))
    {
        $fp = fopen($dat,"r");
        $hex = "";
        while(!feof($fp))
        {
            $hex .= bin2hex(fread($fp,filesize($dat)));
        }

        fclose($fp);
        $text = pack("H*",$hex);
        $str="";
        preg_match_all("/[a-zA-Zçışğüçö\s\.\?0-9!\+]+/",$text,$bulunan);
        foreach($bulunan[0] as $bul)
        {
            if(strlen($bul)>2)
            {
                $str.=$bul;
            }
        }
        file_put_contents("mesajlar.txt",$str.PHP_EOL,FILE_APPEND);
    }
    
}
