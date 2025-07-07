import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.Attention;

class RequestLocation {
    /*
    Location retrieval class
    */
    private var _matches as Dictionary<String, String> = {}; // Valid locations from JSON
    private var _queries as Dictionary<String, String> = {}; // Reverse Geolocation results
    private const _positions_total = 5;
    private var _positions_done = 0;
    private var _location_json_array = null;
    private var progress_handler = null;


    var _positions = new [5];

    public function initialize() {}

    /*
    Self explanatory. Loads JSON only if not loaded.
    */
    public function startSync(handler) as Void {
        progress_handler = handler;
        _matches = {};
        System.println("StartSync");
        if ($.cur_state != location) {
            return;
        }
        if (_location_json_array == null) {
            _location_json_array = Application.loadResource(Rez.JsonData.location_json);
        }
        _positions_done = 0;
        // Start GPS, callback method needed to continue - only start searching when there is GPS
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:locationRequest));
        // locationRequest();
    }

    /*
    Callback for GPS event. Proceed and turn off GPS only when the quality is good enough. 
    */
    function locationRequest(info as $.Toybox.Position.Info) as Void   {
        // var info = Position.getInfo();

        if (info.accuracy != Position.QUALITY_NOT_AVAILABLE){
            var positionInfo = info.position;
            _positions = [positionInfo.toDegrees()].addAll(getSurroundingLocations(positionInfo));
            System.println(positionInfo.toDegrees());
            // Turn GPS off - we are done
            Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
            startNextLocationDownload();
        }

    }

    /*
    Return array with current position, with additional points 2km north, south, east and west of center point.
    */
    private function getSurroundingLocations(pos_info) 
    {
        return [pos_info.getProjectedLocation(0, 2000).toDegrees(), 
                pos_info.getProjectedLocation(0, -2000).toDegrees(), 
                pos_info.getProjectedLocation(3.14/2, 2000).toDegrees(), 
                pos_info.getProjectedLocation(3.14/2, -2000).toDegrees()];
    }

    /*
    Reverse geolocation points to get possible names for current location
    */
    function startNextLocationDownload() {
        var url_format = "https://nominatim.openstreetmap.org/reverse?lat=$1$&lon=$2$&zoom=10&format=jsonv2&accept-language=he";
        var url = Lang.format(url_format, _positions[_positions_done]);
        Communications.makeWebRequest(
            url,
            null,
            $.LOCATION_REQUEST_OPTIONS,
            method(:onReceive)
        );
    }

    /*
    Callback for reverse geolocation webrequest. Update progress (multiple requests are made)
    */
    public function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void {
        try {
            if (responseCode == 200) {
                System.println("200");
                if (data.hasKey("error")) {
                    System.println("ERROR");
                    WatchUi.popView(WatchUi.SLIDE_BLINK);
                    return;
                } else {
                    // check if empty
                    // Go over all fields in address except
                    extractLocationQueriesFromResponse(data);
                }
            
            } else {
                // ERROR
                WatchUi.popView(WatchUi.SLIDE_BLINK);
                return;

            }

            _positions_done += 1;
            if (_positions_done != _positions_total) {

                startNextLocationDownload();
                progress_handler.invoke(_positions_done, _positions_total);
                // We will determine if we are done the next time we try to sync.
            } else {
                progress_handler.invoke(_positions_done, _positions_total);
                populateMatchesFromJSON();
                _location_json_array = null;
                WatchUi.popView(WatchUi.SLIDE_BLINK);
                $.pushBasicCustom(_matches, self.method(:callback_setAlertLocation));
            }
        } catch (ex){
            WatchUi.popView(WatchUi.SLIDE_BLINK);
        }

        WatchUi.requestUpdate();
    }
    
    /*
    Extract location queries from response
    */
    function extractLocationQueriesFromResponse(data as Dictionary) as Void {
        if (data.hasKey("address")) {
            var address_dict = data["address"];
            // var queries = {};
            for (var index = 0; index < address_dict.keys().size(); index++) {
                var key = address_dict.keys()[index];
                var value = address_dict[key];
                switch (key) {
                    case "country_code":
                    case "country":
                    case "state":
                    case "state_district":
                    continue;
                }
                if (_queries.hasKey(value)) {
                    continue;
                } else {
                    _queries.put(value,key);
                }
            }

        }
    }

    /*
    Populate _matches with locations retrieved from the reverse geolocation if the reversed are substrings.
    */
    function populateMatchesFromJSON() as Void { //as Dictionary<String, String>{
        // Queries now has all possible location names matching the GPS location we provided. 
        // Now we need to compare it to the json file
        var keys = _queries.keys();
        for (var j = 0; j < _location_json_array.size(); j++) {
            var json_entry = _location_json_array[j]["n"];
            for (var qi = 0; qi < keys.size(); qi++) {
                var key = keys[qi];
                if (json_entry.find(key) != null) {
                    if (_matches.hasKey(json_entry)) {
                        continue;
                    }
                    _matches.put(json_entry, "");
                    break;
                }
            }
        }
        System.println("Done");
        
    }

    /*
    Callback for location selection in custom menu (manual selection by the user)
    */
    public function callback_setAlertLocation(str as String or Null) as Void {
        if (str != null)
        {
            Storage.setValue($.alert_location_key, str);
            $.cur_state = waiting;
        } else {
            Storage.deleteValue($.alert_location_key);
            $.cur_state = location;
        }

    }

}


