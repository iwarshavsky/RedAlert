
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Application.Storage;

//! Shows the web request result
class MainView extends WatchUi.View {
    // private var timer_count = 0;
    private var _message as String; // = "Press menu or\nselect button";
    var title_mainActive as String;
    var title_mainPending as String;
    var title_mainDisabled as String;
    var title_mainShouldClick as String;
    var dc_width as Number = 0;
    var dc_height as Number = 0;
    var alertRequest; // This is a member variable since we need to check if more alerts were made in the time being, the object prevents multiple alerts.
    //! Constructor

    /*
    Load strings from resources and RequestAlert object.
    */
    public function initialize() {
        WatchUi.View.initialize();
        alertRequest = new RequestAlert();
        title_mainActive = Application.loadResource(Rez.Strings.mainActive);
        title_mainPending = Application.loadResource(Rez.Strings.mainPending);
        title_mainDisabled = Application.loadResource(Rez.Strings.mainDisabled);
        title_mainShouldClick = Application.loadResource(Rez.Strings.mainShouldClick);
        _message = title_mainDisabled;
    }

    /*
    Set current state based on value under alert_location_key
    */
    public function onLayout(dc as Dc) as Void {
        if (Storage.getValue(alert_location_key) != null)
        {
            cur_state = waiting;
            _message = title_mainActive;
        } else {
            cur_state = location;
            _message = title_mainPending;
        }
        dc_height = dc.getHeight();
        dc_width = dc.getWidth();

    }

    public function onShow() as Void {

    }
    
    /*
    Timer callback - check BT status and if valid check if there is an alert.
    */
    function timerCallback() as Void {
        if (timer == null) {
            System.println("timerCallback called with null timer");
            throw new Exception();
        }
        
        if (!bluetoothEnabled()) {
            WatchUi.pushView(new NoBluetoothView(), new NoBluetoothDelegate(), WatchUi.SLIDE_BLINK);
            System.println("MainView timerCallback NoBluetoothView");
            return;
        }
        if (cur_state == location) {
        } else {
            alertRequest.startSync();
        }
        System.println("TIMER CALL BACK");
        timer.start(method(:timerCallback), $.TIMER_SAMPLING_INTERVAL*1000, false);
        WatchUi.requestUpdate();
    }

    /*
    Update text on screen, set timer if none.
    */
    public function onUpdate(dc as Dc) as Void {
        if (!bluetoothEnabled()) {
            WatchUi.pushView(new NoBluetoothView(), new NoBluetoothDelegate(), WatchUi.SLIDE_BLINK);
            System.println("MainView onUpdate NoBluetoothView");
            return;
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        if (cur_state == location) {
            System.println("location");
            _message = title_mainShouldClick;
            drawArc_SelectBtn(dc);
        } else {
            if (timer == null)
            {
                System.println("TIMER ONUPDATE");
                timer = new Timer.Timer();
                timerCallback();
            }
            _message = title_mainActive;
            drawArc_MenuBtn(dc);
        }


        var result = Storage.getValue($.alert_location_key);
        if (!(result instanceof String)) {
            result = "";
        }

        dc.drawText(dc_width / 2, dc_height / 2, $.customFont, _message + "\n" + result, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }

    /*
    Draw arcs next to the select button
    */
    public function drawArc_SelectBtn(dc as Dc) as Void {
        dc.drawArc(dc_width / 2, dc_height / 2,  (dc_width / 2)-2, Graphics.ARC_COUNTER_CLOCKWISE, 20, 40);
        dc.drawArc(dc_width / 2, dc_height / 2,  (dc_width / 2)-6, Graphics.ARC_COUNTER_CLOCKWISE, 20, 40);
        dc.drawArc(dc_width / 2, dc_height / 2,  (dc_width / 2)-10, Graphics.ARC_COUNTER_CLOCKWISE, 20, 40);
    }

    /*
    Draw one wide arc next to the "up" button.
    */
    public function drawArc_MenuBtn(dc as Dc) as Void {
        dc.setPenWidth(4);
        dc.setColor(Graphics.COLOR_DK_RED,Graphics.COLOR_DK_RED);
        dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2,  (dc.getWidth() / 2)-3, Graphics.ARC_COUNTER_CLOCKWISE, 170, 190);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    }
}

