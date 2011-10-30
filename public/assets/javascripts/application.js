var getBikesUrl = "/bikes";

var geocoder;
var map;
var iconAttributes = [];  

var bikes = [];

function Bike( data ) {
  this.id           = data.id;
  this.lat          = data.lat;
  this.lng          = data.lng;
  this.pic          = data.pic;
  this.pic_min      = data.pic_min;
  this.date         = data.date;
  this.marker       = addMarker( this );
  this.zoom         = function() { zoom( this ) };
  this.nextBike     = null;
  this.previousBike = null;
}

function loadIconAttributes() {
  iconAttributes["image"] = 
    new google.maps.MarkerImage(
      '/assets/images/icon_bike.png',
      new google.maps.Size(32,37),
      new google.maps.Point(0,0),
      new google.maps.Point(16,37)
    );
    
  iconAttributes["image_selected"] = 
    new google.maps.MarkerImage(
      '/assets/images/icon_bike_selected.png',
      new google.maps.Size(32,37),
      new google.maps.Point(0,0),
      new google.maps.Point(16,37)
    );
    
  iconAttributes["shadow"] = 
    new google.maps.MarkerImage(
      '/assets/images/icon_shadow.png',
      new google.maps.Size(54,37),
      new google.maps.Point(0,0),
      new google.maps.Point(16,37)
    );

  iconAttributes["shape"] = {
    coord: [30,0,31,1,31,2,31,3,31,4,31,5,31,6,31,7,31,8,31,9,31,10,31,11,31,12,31,13,31,14,31,15,31,16,31,17,31,18,31,19,31,20,31,21,31,22,31,23,31,24,31,25,31,26,31,27,31,28,31,29,31,30,30,31,24,32,23,33,22,34,21,35,20,36,11,36,10,35,9,34,8,33,7,32,1,31,0,30,0,29,0,28,0,27,0,26,0,25,0,24,0,23,0,22,0,21,0,20,0,19,0,18,0,17,0,16,0,15,0,14,0,13,0,12,0,11,0,10,0,9,0,8,0,7,0,6,0,5,0,4,0,3,0,2,0,1,1,0,30,0],
    type: 'poly'
  };
}

function initialize() {
  geocoder      = new google.maps.Geocoder();
  var latlng    = new google.maps.LatLng(52.4933, 13.39638);
  var myOptions = {
    zoom      : 15,
    center    : latlng,
    mapTypeId : google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map"), myOptions);
}

function codeAddress( address ) {
  history.pushState( null, null, $.url().attr( "fragment", "a=" + address ) );
  $('#address-field').attr( 'value', address );
  
  geocoder.geocode( 
    { 'address': address }, 
    function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        map.setZoom(15);
        var marker = 
          new google.maps.Marker({
            map       : map, 
            position  : results[0].geometry.location
          });
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    }
  );
}

function addMarker( bike ) {
  
  marker =
    new google.maps.Marker({
      icon      : iconAttributes["image"],
      shadow    : iconAttributes["shadow"],
      shape     : iconAttributes["shape"],
      position  : new google.maps.LatLng( bike.lat, bike.lng ), 
      map       : map,
      title     : "Hello World!"
    });
  
  google.maps.event.addListener( marker, 'click', function() {
    showBike( bike );
  });
  
  return marker;
}

function addBike( data ){
  bikes.push( new Bike( data ) );
}

function showBike( bike ){
  console.log( "showBike: ", bike );
  console.log( "showBike.id: ", bike.id );
  
  history.pushState( null, null, $.url().attr( "fragment", "b=" + bike.id ) );
  
  $.each( bikes, function( index, bike ){
    bike.marker.setIcon( iconAttributes["image"] );
  });
  bike.marker.setIcon( iconAttributes["image_selected"] );

  $("#bike h1 #id").html( bike.id );
  $("#bike #address").html( bike.address );
  $("#bike img").attr( "src", bike.pic_min );
  $("#bike #date").html( bike.date );
  $("#bike").show();
  
  $("#bike img").unbind('click');
  $("#bike img").click( function() {
    bike.zoom();
  });

  $("#previous-bike-link").unbind('click');  
  $("#previous-bike-link").click( function() {
    showBike( bike.previousBike );
    return false;
  });
  
  $("#next-bike-link").unbind('click');
  $("#next-bike-link").click( function() {
    showBike( bike.nextBike );
    return false;
  });
  
  
  centerMap( bike.lat, bike.lng );
}

function centerMap( lat, lng ) {
  var latlng = new google.maps.LatLng( lat, lng )
  map.panTo( latlng );
}

function loadBikes( call_back ) {
  $.get( 
    getBikesUrl,
    function( data ){
      $.each( data, function(){ addBike( this ); });
      chainBikes();
      if( call_back ) call_back.call();
    },
    "json"
  );
}

function chainBikes() {
  console.log( "chainBikes" );
  $.each( bikes, function( index, bike ){
    var previousIndex = (index == 0) ? (bikes.length - 1) : (index - 1);
    var nextIndex     = (index == (bikes.length - 1)) ? 0 : (index + 1);
    bike.previousBike = bikes[ previousIndex ];
    bike.nextBike     = bikes[ nextIndex ];
    
    console.log( "previousBike: ", bike.previousBike );
    console.log( "nextBike: ", bike.nextBike );
  });
}

function zoom( bike ) {
  $("#zoom").css( 'background-image', 'url( "' + bike.pic + '" )' );
  $("#zoom").show();
}

function closeZoom() {
  $("#zoom").fadeOut( 'fast' );
}

function getBike( id ) {
  var result = null;
  
  $.each( bikes, function( index, bike ) {
    if( bike.id == id ) {
      result = bike;
      return false;
    }
  });
  
  return result;
}

$(function(){
  loadIconAttributes();
  initialize();
  
  var bike_id = $.url().fparam('b');
  var address = $.url().fparam('a');
  
  if( bike_id ) {
    loadBikes( function() { showBike( getBike( parseInt( bike_id ) ) ) } );
  } else {
    loadBikes();
  }
  
  if( address ) {
    codeAddress( address );
  }
});