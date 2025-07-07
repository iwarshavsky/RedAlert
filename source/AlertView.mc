import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Attention;


class Alert {
/*
Alert message extracted from JSON containing category, title and description.
*/
    public var cat;
    public var title;
    public var desc;
    public function initialize(_cat as String, _title as String, _desc as String) {
        cat = _cat;
        title = _title;
        desc = _desc;
    }
}


class AlertView extends WatchUi.View {
/*
View of active alert. Is visible for a predetermined amount of time - const ALERT_VIEW_TIME.
Alert attention-getter (vibration/sound) is initialized by runAttentionFrame.
*/

    var _title;
    var _body;

    private var second_count = 0;
    private var second_interval_timer = null; // "second" as in the unit of time - should tick once every second.
    
    private var _alert = null;
    
    public function initialize(alertObj as Alert) {
        WatchUi.View.initialize();
        second_interval_timer = new Timer.Timer();
        _alert = alertObj;
    }

    /*
    During layout, determine if the alert category indicates a message or an immediate alert,
    choose an appropriate layout based on this.
    SHOULD_ALERT_CATEGORY determines the category which triggers an alert.
    */
    public function onLayout(dc as Dc) as Void {
        if (_alert.cat.equals($.SHOULD_ALERT_CATEGORY)) {
            setLayout(Rez.Layouts.AlertLayout(dc));
            runAttentionFrame();
        } else {
            setLayout(Rez.Layouts.MessageLayout(dc));
            Attention.vibrate(vibeData);
        }
        _title = findDrawableById("alertTitle") as WatchUi.TextArea;
        _body = findDrawableById("alertBody") as WatchUi.TextArea;
        
    }

    /*
    Progress one second ("Frame") out of the ALERT_VIEW_TIME during which a sound/vibration should occur.
    */
    function runAttentionFrame() as Void {
        if (second_count < $.ALERT_VIEW_TIME) {
            Attention.vibrate(vibeData);
            Attention.playTone(Attention.TONE_ALERT_HI);
            second_interval_timer.start(method(:runAttentionFrame), 1000, false);
            second_count++;
        } else {
            second_interval_timer = null;
        }
    }

    /*
    Reset timer when shown again. 
    */
    public function onShow() as Void {
        timer_hide_alert_view = new Timer.Timer();
        timer_hide_alert_view.start(method(:onTimer), $.ALERT_VIEW_TIME*1000, false);
    }

    /*
    Draw text.
    */
    public function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        if (_title != null and _body != null) {
            _title.setText(_alert.title);
            System.println(_alert.title);
            _body.setText(_alert.desc);
        }
    }

    /*
    Disable timers when view is hidden.
    */
    public function onHide() as Void {
        if (second_interval_timer != null)
        {
            second_interval_timer.stop();
        }
        if (timer_hide_alert_view != null) {
            timer_hide_alert_view.stop();
        }
        timer_hide_alert_view = null;
        second_interval_timer = null;
    }

    /*
    Alert should now disappear.
    */
    public function onTimer() as Void {
        WatchUi.popView(SLIDE_BLINK);
        timer_hide_alert_view = null;
        second_interval_timer = null;
    }

}
