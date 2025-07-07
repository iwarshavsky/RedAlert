import Toybox.Application;
import Toybox.Background;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
using Toybox.Time.Gregorian;
import Toybox.Attention;


class RedAlertApp extends Application.AppBase {
    /*
    Initialize global variables which are objects
    */
    function initialize() {
        AppBase.initialize();
        cur_state = location;
        customFont = Application.loadResource(Rez.Fonts.f1_small);
        vibeData = [new Attention.VibeProfile(50, 450), // On for two seconds
                    new Attention.VibeProfile(0, 450)] as VibeProfile;
        if (TIMER_SAMPLING_INTERVAL <= ALERT_VIEW_TIME) {
            System.println("ERROR - The following must hold: TIMER_SAMPLING_INTERVAL > ALERT_VIEW_TIME");
            System.exit();
        }
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        // state is not empty if called using System.Intent
        // When the user returns to your application, you will be called with a :resume option
        // When launched from a notification, :launchedFromNotification
        
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
         // AppBase.onStop() will be called with a :suspend option to inform you that you are being terminated if lacking resources.
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        // if (!bluetoothEnabled()) {
        //     return [new NoBluetoothView(), new NoBluetoothDelegate()];
        // }
        var view = new $.MainView();
        var delegate = new $.MainDelegate();
        return [view, delegate];
    }

    function onInactive(state as Dictionary or Null) as Void {
        // This is called when the app is no longer the active app
        // You can save state here if needed
    }
    function onActive(state as Dictionary or Null) as Void {
        // This is called when the app becomes the active app again
        
    }
    function onStorageChanged() as Void {
        // This is called when the storage state changes, such as when a file is added or removed
        // You can refresh your view or data here if needed
        // SHOULD I USE PROPERTY instead? https://developer.garmin.com/connect-iq/core-topics/persisting-data/

    }

}

/*
Returns true if Bluetooth is enabled
*/
public function bluetoothEnabled() as Boolean {
    
    var possibleConnection = false;

    var deviceSettings = System.getDeviceSettings();
    var bluetoothStatus = deviceSettings.connectionInfo[:bluetooth];
    if (bluetoothStatus != null) {
        if (bluetoothStatus.state == System.CONNECTION_STATE_CONNECTED) {
            possibleConnection = true;
        }
    }

    return possibleConnection;

}