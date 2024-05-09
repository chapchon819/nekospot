document.addEventListener("DOMContentLoaded", function() {
    window.initMap = function() {
      var spotLocation = { lat: parseFloat(document.getElementById('map').dataset.lat), lng: parseFloat(document.getElementById('map').dataset.lng) };
  
      var map = new google.maps.Map(document.getElementById('map'), {
        center: spotLocation,
        zoom: 15
      });
  
      var marker = new google.maps.Marker({
        position: spotLocation,
        map: map,
        title: document.getElementById('map').dataset.name
      });
    }
  });