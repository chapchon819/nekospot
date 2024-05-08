let map, marker, markers = [];
var apiKey = gon.api_key;
var spots = gon.spots;

const defaultLocation = { lat: 35.6803997, lng: 139.7690174 };

function initMap() {
  const geocoder = new google.maps.Geocoder();
  const mapElement = document.getElementById('map');
  const defaultLat = parseFloat(mapElement.dataset.lat) || defaultLocation.lat;
  const defaultLng = parseFloat(mapElement.dataset.lng) || defaultLocation.lng;

  map = new google.maps.Map(document.getElementById('map'), { 
    zoom: 12,
    streetViewControl: false, // ストリートビューのボタン非表示
    mapTypeControl: false, // 地図、航空写真のボタン非表示
    fullscreenControl: false, // フルスクリーンボタン非表示
    keyboardShortcuts: false //キーボードショートカットオフ、キーボードボタン非表示
     });

  const icons = {
  "猫カフェ": {
    url: mapElement.dataset.cafeIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  },
  "動物園": {
    url: mapElement.dataset.zooIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  },
  "島": {
    url: mapElement.dataset.islandIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  }
};

centerPin = new google.maps.Marker({
  map: map,
  draggable: true,
  position: map.getCenter(), // 初期位置をマップの中心に設定
  title: "現在地"
});


spots.forEach(function(spot) {
  let marker = new google.maps.Marker({
    map: map,
    position: { lat: parseFloat(spot.latitude), lng: parseFloat(spot.longitude) },
    title: spot.name,
    icon: icons[spot.category] || null // デフォルトアイコンを設定
  });

    markers.push(marker);  // マーカーを配列に追加

    marker.addListener('click', function() {
      updateInfoCard(spot);
    });
  });

  // ピンのドラッグ終了イベント
  centerPin.addListener('dragend', function() {
    map.setCenter(centerPin.getPosition());
    updateSpotsList(); // スポットリストを更新
  });

  // マップのドラッグ終了イベント
  map.addListener('dragend', function() {
    centerPin.setPosition(map.getCenter());
    updateSpotsList(); // スポットリストを更新
  });

  // 現在地の読み込み
  showCurrentLocation();
}

// initMapをグローバルスコープに
window.initMap = initMap;

function updateInfoCard(spot) {
  // 他の全ての情報カードを非表示にする
  document.querySelectorAll('[id^="infoCard-"]').forEach(card => {
    card.classList.add('hidden');
  });
  
  var infoCardId = 'infoCard-' + spot.id;
  var infoCard = document.getElementById(infoCardId);
  if (infoCard) {
    infoCard.classList.remove('hidden');
    const imageUrl = `https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&maxwidth=1000&photo_reference=${spot.image}&key=${apiKey}`;
    infoCard.querySelector(`#spotImage-${spot.id}`).src = imageUrl;
    infoCard.querySelector(`#spotName-${spot.id}`).textContent = spot.name;
    infoCard.querySelector(`#spotRating-${spot.id}`).textContent = `⭐️ ${spot.rating}`;
    infoCard.querySelector(`#spotCategory-${spot.id}`).textContent = spot.category;
  } else {
    console.error('Info card element not found:', infoCardId);
  }
}

function hideInfoCard(event, spotId) {
  // イベントのバブリングを停止
  event.stopPropagation();
  // デフォルトのイベントをキャンセル
  event.preventDefault();

  const infoCard = document.getElementById(`infoCard-${spotId}`);
  if (infoCard) {
    infoCard.classList.add('hidden');
  } else {
    console.error('Info card element not found:', `infoCard-${spotId}`);
  }
}


function showCurrentLocation(){
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const userLocation = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
            map.setCenter(userLocation);
            centerPin.setPosition(userLocation);
            updateSpotsList();
          }, function() {
            alert('位置情報の取得に失敗しました。');
            map.setCenter(defaultLocation); // 東京の座標
            updateSpotsList();
        });
    } else {
        alert('お使いのブラウザでは地理位置情報の取得がサポートされていません。');
        map.setCenter(defaultLocation); // 東京の座標
        updateSpotsList();
    }
}

// showCurrentLocationをグローバルスコープに追加
window.showCurrentLocation = showCurrentLocation;

function updateSpotsList() {
  const center = map.getCenter();

  fetch(`/spots/list?latitude=${center.lat()}&longitude=${center.lng()}`)
    .then(response => response.json())
    .then(data => {
        const frame = document.getElementById('spots_list');
        frame.innerHTML = '';  // Frame の内容をクリア

        data.forEach(spot => {
            const imageUrl = `https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&maxwidth=1000&photo_reference=${spot.image}&key=${apiKey}`;
            const spotElement = document.createElement('div');
            spotElement.className = 'spot-item';
            spotElement.innerHTML = `
            <a href="/spots/${spot.id}" class="block w-full h-full" data-turbo="false">
              <div class="bg-white border rounded-xl shadow-sm flex mx-auto w-11/12 relative z-10 mb-50 hover:shadow-lg group truncate">
                <div class="flex-shrink-0 relative rounded-t-xl overflow-hidden h-33 w-32 md:w-1/3 rounded-s-xl md:rounded-se-none">
                  <img src="${imageUrl}" class="w-full h-full absolute top-0 left-0 object-cover transition-transform duration-200 ease-in-out group-hover:scale-110">
                </div>
                <div class="flex flex-wrap">
                  <div class="p-4 flex flex-col h-full sm:p-2">
                    <h3 class="text-lg md:text-xs font-bold text-neutral font-zenmaru overflow-hidden whitespace-nowrap pr-1 line-clamp-1">${spot.name}</h3>
                    <div class="justify-start flex md:space-x-4 space-x-2 mt-2">
                      <div class="mt-1 inline-flex">
                        <p class="text-xs text-white py-1 px-1 rounded-full bg-accent dark:text-neutral-500">${spot.category}</p>
                      </div>
                      <p class="mt-1 md:text-sm font-semibold text-secondary">⭐️ ${spot.rating}</p>
                    </div>
                  </div>
                </div>
              </div>
              </a>
            `;
            frame.appendChild(spotElement);
        });
    })
    .catch(error => console.error('スポットリストの更新に失敗しました：', error));
}

document.addEventListener("turbo:load", function() {
  if (!map) initMap(); // マップが初期化されていなければ初期化
  showCurrentLocation();
  updateSpotsList();
});
