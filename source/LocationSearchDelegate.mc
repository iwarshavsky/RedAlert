
import Toybox.Communications;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;



class LocationSearchDelegate extends WatchUi.BehaviorDelegate {
/*
Delegate for Location search.
*/

    public function initialize() {
        WatchUi.BehaviorDelegate.initialize();
    }

    /*
    Don't allow to go back which clicking the back button during location search
    */
    public function onBack() as Boolean {
        return true;
    }



}