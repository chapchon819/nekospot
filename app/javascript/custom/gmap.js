let map, marker;

const latlngDis = document.getElementById('latlngDisplay');
const addressDis = document.getElementById('addressDisplay');

function initMap() {
  const geocoder = new google.maps.Geocoder();

  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 12,
  });

  marker = new google.maps.Marker({
    map: map,
  });
  showCurrentLocation();
}

function codeAddress() {
  const geocoder = new google.maps.Geocoder();
  const inputAddress = document.getElementById('address').value;
  geocoder.geocode({ 'address': inputAddress }, function(results, status) {
    if (status === 'OK') {
      map.setCenter(results[0].geometry.location);
      marker.setPosition(results[0].geometry.location);
      latlngDis.innerHTML = `Latitude: ${results[0].geometry.location.lat()}, Longitude: ${results[0].geometry.location.lng()}`;
      addressDis.innerHTML = results[0].formatted_address;
    } else {
      alert("該当する結果がありませんでした：" + status);
    }
  });
}

function showCurrentLocation(){
    // ユーザーの現在地を取得してマップに設定
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        const userLocation = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
        map.setCenter(userLocation);
        marker.setPosition(userLocation);
        latlngDis.innerHTML = `Latitude: ${userLocation.lat}, Longitude: ${userLocation.lng}`;
      }, function() {
        alert('位置情報の取得に失敗しました。');
        map.setCenter({ lat: 35.6803997, lng: 139.7690174 }); // 東京の座標
      });
    } else {
      // Geolocationがサポートされていないブラウザの場合
      alert('お使いのブラウザでは地理位置情報の取得がサポートされていません。');
      map.setCenter({ lat: 35.6803997, lng: 139.7690174 }); // 東京の座標
    };
}