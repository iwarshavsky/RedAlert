
import Toybox.Communications;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

var timer = null;
var timer2 = null;
var should_sync as Boolean = true;
var message as String = "";


class MainDelegate extends WatchUi.BehaviorDelegate {

    public function initialize() {
        WatchUi.BehaviorDelegate.initialize();
    }

    /*
    When during initial state, i.e. "location" mode, clicking the select button sets location
    */
    public function onSelect() as Boolean {
        if (cur_state == location) {
            getLocation();
        }

        return true;
    }

    /*
    Long-clicking the up button sets location
    */
    public function onMenu() as Boolean {
        getLocation();
        return true;
    }

    /*
    Moves to LocationSearch if menu button is pressed.
    Resets stored location
    */
    public function getLocation() as Void {
        if (timer != null) {
            timer.stop();
        }
        cur_state = location;
        Application.Storage.deleteValue(alert_location_key);
        WatchUi.requestUpdate();
        WatchUi.pushView(new LocationSearchView(), new LocationSearchDelegate(), SLIDE_UP);
    }



}