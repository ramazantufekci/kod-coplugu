<?php

require 'vendor/autoload.php';
use \InstagramAPI\Response\UserInfoResponse;
$ig = new \InstagramAPI\Instagram();
$ig->login("kullanıcı ismi","şifre");

/**
*dizideki istenmeyen bilgileri siler
*
*/

function sil($kelime)
{
	return str_replace("C:\\inetpub\\wwwroot\\","",$kelime);
}
/**
*Ver id yi sana story i getirsin
*resimleri ve videoları C:\\inetpub\\wwwroot\\ dizinine indirir.
*
*/
$id = "123456789";
$story = $ig->story->getUserReelMediaFeed($id);
foreach($story->getItems() as $item)
{
	var_export($item);
	if($item->getMedia_type() == 1)
	{
		var_export($item->getImage_versions2()->getCandidates()[0]->getUrl());
		file_put_contents("C:\\inetpub\\wwwroot\\".$item->getCode().".jpg",file_get_contents($item->getImage_versions2()->getCandidates()[0]->getUrl()));
	}else
	{
		var_export($item->getVideo_versions()[0]->getUrl());
		file_put_contents("C:\\inetpub\\wwwroot\\".$item->getCode().".mp4",file_get_contents($item->getVideo_versions()[0]->getUrl()));
		
		//break;
	}
	
}

/**
*Video ve resimleri html dosyasının içine ekler
*
*/
$liste = array_map("sil",glob("C:\\inetpub\\wwwroot\\*.mp4"));
foreach($liste as $list)
{
file_put_contents("C:\\inetpub\\wwwroot\\iisstart.htm","<a href=\"".$list."\">{$list}</a><br/><br/><br/>",FILE_APPEND);
}
$liste2 = array_map("sil",glob("C:\\inetpub\\wwwroot\\*.jpg"));
foreach($liste2 as $list2)
{
file_put_contents("C:\\inetpub\\wwwroot\\iisstart.htm","<img src=\"".$list2."\"><br/><br/><br/>",FILE_APPEND);
}
