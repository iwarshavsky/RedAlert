import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.Attention;


class RequestAlert {
    /*
    Alert retrieval class
    */
    private var _alert_location as String = "";
    private var request_made = false;

    public function startSync() as Void {
        _alert_location = Storage.getValue($.alert_location_key);
        sampleAlert();
    }

    /*
    Make alert web request
    */
    private function sampleAlert() as Void {
        if (!request_made) {

            Communications.makeWebRequest(
                $.ALERT_URL,
                null,
                $.ALERT_REQUEST_OPTIONS,
                method(:onReceiveAlert)
            );
            request_made = true;
        }
        else {
            System.println("DECLINED SAMPLE ALERT");
        }
    }

    /*
    Alert received handler. Creates an Alert object from the resulting JSON if responseCode is 200.
    */
    public function onReceiveAlert(responseCode as Number, data as Dictionary or String or Null) as Void {
        request_made = false;
        try {
            if (responseCode == 200) {
                if (data instanceof Dictionary) {
                    if (data.hasKey("data")) {
                        if (Utils.arrayContainsString(data["data"], _alert_location)) {
                            alert(new Alert(data["cat"], data["title"], data["desc"]));
                            return;
                        }
                        else {
                            alert(null);
                        }
                    }
                }
            } else {
                throw new Exception();
            }
        } catch (ex) {
            alert(new Alert("1", "ERROR", "ERROR"));
        }

        WatchUi.requestUpdate();
    }

    /*
    Show an alert
    */
    function alert(alertObj as Alert or Null) as Void {
        if (alertObj != null) {
            WatchUi.pushView(new AlertView(alertObj), null, WatchUi.SLIDE_UP);
            System.println("ALERT!");
            $.cur_state = active_alert;
            
        }
        else {
            System.println("No alert");
            $.cur_state = waiting;
        }

    }

}