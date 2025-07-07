import Toybox.Lang;
import Toybox.Attention;
import Toybox.Communications;

const TIMER_SAMPLING_INTERVAL as Number = 7;
const ALERT_VIEW_TIME as Number = 5;


const NO_LOCATION_FOUND as Number = -1;
const SHOULD_ALERT_CATEGORY = "1";

var ALERT_URL =  "https://www.oref.org.il/WarningMessages/alert/alerts.json";
var ALERT_URL_DEBUG = "https://iwarshavsky.github.io/test/alert.json";

var ALERT_REQUEST_OPTIONS = {
    :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
    :headers => {
        "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
        "Referer"=> "https://www.oref.org.il/",
        "User-Agent"=> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36",
        "X-Requested-With"=> "XMLHttpRequest"
    }
};

var LOCATION_REQUEST_OPTIONS = {
    :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
    :headers => {
        "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
    }
};


var vibeData;

const alert_location_key = "alert_location";

enum State {
    location = :STATE_LOCATION,
    waiting = :WAITING,
    active_alert = :ACTIVE_ALERT
}
var timer_hide_alert_view = null;
var cur_state;
var customFont = null;