let map, marker, markers = [];
var apiKey = gon.api_key;
var spots = gon.spots;
let currentCategoryId = null;
let activeMarker = null;

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
  },
  "宿泊施設": {
    url: mapElement.dataset.hotelIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  },
  "飲食店": {
    url: mapElement.dataset.eatingIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  },
  "アニマルカフェ": {
    url: mapElement.dataset.animalCafeIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  },
  "書店・雑貨店": {
    url: mapElement.dataset.shopIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  },
  "公園": {
    url: mapElement.dataset.parkIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  },
  "シェルター": {
    url: mapElement.dataset.shelterIcon,
    size: new google.maps.Size(52, 52),
    scaledSize: new google.maps.Size(52, 52)
  },
  "銭湯": {
    url: mapElement.dataset.furoIcon,
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
    icon: icons[spot.category] || null, // デフォルトアイコンを設定
    categoryId: spot.category_id  // カテゴリIDを正しく設定
  });

    markers.push(marker);  // マーカーを配列に追加

    marker.addListener('click', function() {
      updateInfoCard(spot);
      addBounceAnimation(marker);
    });
  });

  // ピンのドラッグ終了イベント
  centerPin.addListener('dragend', function() {
    map.setCenter(centerPin.getPosition());
    updateSpotsList(currentCategoryId); // スポットリストを更新
  });

  // マップのドラッグ終了イベント
  map.addListener('dragend', function() {
    centerPin.setPosition(map.getCenter());
    updateSpotsList(currentCategoryId); // スポットリストを更新
  });

  // 現在地の読み込み
  showCurrentLocation();

  // カテゴリーボタンにイベントリスナーを追加
  const buttons = document.querySelectorAll("#category-buttons button");
  buttons.forEach(button => {
    button.addEventListener("click", function() {
      const categoryId = parseInt(this.getAttribute('data-category-id'));
      currentCategoryId = categoryId;
      filterSpotsByCategory(categoryId);
      updateSpotsList(categoryId);
    });
  });

  // 解除ボタンにイベントリスナーを追加
  document.getElementById("reset-button").addEventListener("click", function() {
      currentCategoryId = null;
      filterSpotsByCategory(null);
      updateSpotsList(null);
  });

  // マップの読み込み完了イベント
  google.maps.event.addListenerOnce(map, 'idle', function() {
    // 現在地の取得が完了しているかをチェック
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        // 現在地取得が完了していたらローディングアニメーションを非表示にする
        const loadingSpinner = document.getElementById('loading-spinner');
        if (loadingSpinner) {
          loadingSpinner.style.display = 'none';
        }
      });
    } else {
      // 現在地取得がサポートされていない場合もローディングアニメーションを非表示にする
      const loadingSpinner = document.getElementById('loading-spinner');
      if (loadingSpinner) {
        loadingSpinner.style.display = 'none';
      }
    }
  });
}

// initMapをグローバルスコープに
window.initMap = initMap;

function filterSpotsByCategory(categoryId) {
    markers.forEach(marker => {
      if (categoryId === null || marker.categoryId === categoryId) {
        marker.setVisible(true);
      } else {
        marker.setVisible(false);
      }
    });
  }

// filterSpotsByCategoryをグローバルスコープに追加
window.filterSpotsByCategory = filterSpotsByCategory;

// 都道府県ボタンのイベントリスナー設定
document.addEventListener("DOMContentLoaded", function() {
  const prefectureButtons = document.querySelectorAll(".prefecture-btn");
  prefectureButtons.forEach(button => {
    button.addEventListener("click", function() {
      const lat = parseFloat(this.dataset.lat);
      const lng = parseFloat(this.dataset.lng);
      const newCenter = new google.maps.LatLng(lat, lng);
      map.setCenter(newCenter);
      centerPin.setPosition(newCenter);
      map.setZoom(8);
      updateSpotsList(currentCategoryId);  // スポットリストを更新
    });
  });
});

function updateInfoCard(spot) {
  // 他の全ての情報カードを非表示にする
  document.querySelectorAll('[id^="infoCard-"]').forEach(card => {
    card.classList.add('hidden');
  });
  
  var infoCardId = 'infoCard-' + spot.id;
  var infoCard = document.getElementById(infoCardId);
  if (infoCard) {
    infoCard.classList.remove('hidden');
    let imageUrl;
    if (!spot.image || spot.image === 'default.png') {
      imageUrl = window.defaultImagePath; // デフォルト画像のURL
    } else {
      imageUrl = `https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&maxwidth=1000&photo_reference=${spot.image}&key=${apiKey}`;
    }
    infoCard.querySelector(`#spotImage-${spot.id}`).src = imageUrl;
    infoCard.querySelector(`#spotName-${spot.id}`).textContent = spot.name;
    infoCard.querySelector(`#spotRating-${spot.id}`).textContent = `⭐️ ${spot.rating}`;
    infoCard.querySelector(`#spotCategory-${spot.id}`).textContent = spot.category;
  } else {
    console.error('Info card element not found:', infoCardId);
  }
}

// infoCardのxボタン
function hideInfoCard(event, spotId) {
  // イベントのバブリングを停止
  event.stopPropagation();
  // デフォルトのイベントをキャンセル
  event.preventDefault();
  clearAllAnimations();

  const infoCard = document.getElementById(`infoCard-${spotId}`);
  if (infoCard) {
    infoCard.classList.add('hidden');
  } else {
    console.error('Info card element not found:', `infoCard-${spotId}`);
  }
}

window.hideInfoCard = hideInfoCard

// infoCardのリンクのクリックイベントをキャンセルするリスナーを追加
document.querySelectorAll('.infoCard-link').forEach(link => {
  link.addEventListener('click', function(event) {
    // もしクリックしたのがボタンであれば、リンクのイベントを無効化
    if (event.target.closest('button')) {
      event.stopPropagation();
      event.preventDefault();
    }
  });
});

function showCurrentLocation(){
    // ローディングアニメーションを表示
    const loadingSpinner = document.getElementById('loading-spinner');
    if (loadingSpinner) {
      loadingSpinner.style.display = 'flex';
    }

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const userLocation = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
            map.setCenter(userLocation);
            centerPin.setPosition(userLocation);
            updateSpotsList(currentCategoryId);
            // ローディングアニメーションを非表示
            if (loadingSpinner) {
              loadingSpinner.style.display = 'none';
            }
          }, function() {
            alert('位置情報の取得に失敗しました。');
            map.setCenter(defaultLocation); // 東京の座標
            updateSpotsList(currentCategoryId);
            // ローディングアニメーションを非表示
            if (loadingSpinner) {
              loadingSpinner.style.display = 'none';
            }
        });
    } else {
        alert('お使いのブラウザでは地理位置情報の取得がサポートされていません。');
        map.setCenter(defaultLocation); // 東京の座標
        updateSpotsList(currentCategoryId);

      // ローディングアニメーションを非表示
      if (loadingSpinner) {
        loadingSpinner.style.display = 'none';
      }
    }
}

// showCurrentLocationをグローバルスコープに追加
window.showCurrentLocation = showCurrentLocation;

function updateSpotsList(categoryId) {
  if (!map) {
    console.error('Map is not initialized.');
    return;
  }
  
  const center = map.getCenter() || defaultLocation;
  if (!center) {
    console.error('マップの中心が利用できません。デフォルトの位置を使用します。');
  }

  const url = categoryId
  ? `/spots/list?latitude=${center.lat()}&longitude=${center.lng()}&category=${categoryId}`
  : `/spots/list?latitude=${center.lat()}&longitude=${center.lng()}`;

  fetch(url)
    .then(response => response.json())
    .then(data => {
        const frame = document.getElementById('spots_list');
        frame.innerHTML = '';  // Frame の内容をクリア

        data.forEach(spot => {
          let imageUrl;
          if (!spot.image || spot.image === 'default.png') {
            imageUrl = window.defaultImagePath; // デフォルト画像のURL
          } else {
            imageUrl = `https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&maxwidth=1000&photo_reference=${spot.image}&key=${apiKey}`;
          }
            const spotElement = document.createElement('div');
            spotElement.className = 'spot-item';
            spotElement.innerHTML = `
            <a href="/spots/${spot.id}" class="block w-full h-full" data-turbo="false">
              <div class="bg-white border rounded-xl shadow-sm flex mx-auto relative z-10 mb-2 hover:shadow-lg group truncate">
                <div class="flex-shrink-0 relative rounded-l-xl overflow-hidden h-33 w-32 md:w-1/3 rounded-s-xl md:rounded-se-none">
                  <img src="${imageUrl}" class="w-full h-full absolute top-0 left-0 object-cover transition-transform duration-200 ease-in-out group-hover:scale-110">
                </div>
                <div class="flex flex-wrap">
                  <div class="p-4 flex flex-col h-full sm:p-2">
                    <h3 class="text-lg md:text-xs font-bold text-neutral font-zenmaru whitespace-pre-wrap pr-1 line-clamp-1">${spot.name}</h3>
                    <div class="justify-start flex md:space-x-4 space-x-2 mt-2">
                      <div class="mt-1 inline-flex">
                        <p class="text-xs text-white py-1 px-2 rounded-full bg-accent font-semibold dark:text-neutral-500"><i class="ph-fill ph-star"></i> ${spot.rating}</p>
                      </div>
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

document.addEventListener("DOMContentLoaded", function() {
  if (!window.google || !window.google.maps) {
    return;
  }
  if (typeof map === 'undefined') initMap(); // マップが初期化されていなければ初期化
  showCurrentLocation();
  updateSpotsList();
});


function addBounceAnimation(marker) {
  // 既存のアクティブなマーカーのアニメーションをクリア
  if (activeMarker) {
    activeMarker.setAnimation(null);
  }
  // クリックされたマーカーにバウンスアニメーションを追加
  marker.setAnimation(google.maps.Animation.BOUNCE);
  activeMarker = marker;
}

function clearAllAnimations() {
  markers.forEach(marker => {
    marker.setAnimation(null);
  });
}

window.addBounceAnimation = addBounceAnimation
window.clearAllAnimations = clearAllAnimations