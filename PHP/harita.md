<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
	<title></title>
	<script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
	<script type="text/javascript" >
var map;	
var marker;
	function mapyukle () {
	
	var mapMerkezi= new google.maps.LatLng(38.73122, 35.478729);//bu konum kayserinin konumu. siz isterseniz başka yer yapabilrisinz.
	 var mapOptions = {
                zoom: 12,
                center: mapMerkezi
            };
	//map-canvas isimli html nesnemiz mapOptions özellikleri ile map oluyor.
	map=new google.maps.Map(document.getElementById('map-canvas') 
	,mapOptions);
	//markeri yani işaretimizi haritanın ortasına konumlandırdı. Taşınabilir yaptık. 
	marker=new google.maps.Marker({
                position: map.getCenter(),
                map: map,
                draggable: true
            });
        
        //simdi de haritaya tıklandığında markeri o noktaya alcak kodumuz
        google.maps.event.addListener(map, 'click', function (e) {
                marker.position = e.latLng;
            });

            
}	
function kordinatal() {
	var txt=document.getElementById('txt');
	txt.value=marker.position;
	return false;
}	
	</script>
</head>
<body onload="mapyukle()">
<input type="text" id="txt" value="" />	
<div id="map-canvas" style="width:500px;height:300px;">

</div>
<a href="#" onclick="kordinatal()" > kordinati al</a>
	
</body>
</html>
