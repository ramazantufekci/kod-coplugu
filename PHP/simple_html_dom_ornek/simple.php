<?php
/**
*Author : Ramazan TÜFEKÇİ
*website: https://www.ramazantufekci.com
*/

include_once("simple_html_dom.php");
$url = "http://www.sanatciorganizasyonu.com/sanatcilar/dj/12/";

if(!isset($argv[1]))
{
	$argv[1] = "http://www.sanatciorganizasyonu.com/sanatcilar/isim-sanatcilar/3/pop-sanatcilar/2/";
}

function me($url){
$ch = curl_init();
curl_setopt($ch,CURLOPT_URL,$url);
curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
curl_setopt($ch,CURLOPT_VERBOSE,true);
$data = curl_exec($ch);
curl_close($ch);
//var_export($data);
/*preg_match("#window.initials = (.*?)};#",$data,$data2);
$data2 = $data2[1]."}";
$data2 = json_decode($data2,true);
print_r($data2);
//var_export($argv);
var_export($url = $data2["videoModel"]["sources"]["mp4"]["720p"]);
exec("wget -O \"".$data2["videoModel"]["title"]."\".mp4 --no-check-certificate \"".$url."\"");
*/
//print_r($data);

//print_r($data);
//$html = new simple_html_dom();
$html=str_get_html($data);
//print_r($html,false);
foreach($html->find("div.post_item_title a") as $dd){
print_r($isim = $dd->plaintext);
file_put_contents("dj.txt",$isim.PHP_EOL,FILE_APPEND);
echo PHP_EOL;
}
}
me($url);
//exit();
for($i=1;$i<3;$i++)
{
	me($url."?page=".$i);
}
