import Toybox.Communications;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.System;



class NoBluetoothDelegate extends WatchUi.BehaviorDelegate {
    /*
    Delegate for no Bluetooth view.
    */

    public function initialize() {
        WatchUi.BehaviorDelegate.initialize();
    }

    /*
    If the user hits back during this screen, exit app.
    */
    public function onBack() as Boolean {
        System.exit();
    }

}