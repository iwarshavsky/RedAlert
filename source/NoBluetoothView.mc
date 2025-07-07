import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Attention;


class NoBluetoothView extends WatchUi.View {
    /*
    View shown when no Bluetooth available
    */

    public function initialize() {
        WatchUi.View.initialize();
    }

    /*
    Stops timer and restores previous view if Bluetooth is enabled.
    */
    function check_connection() as Void {
        if (bluetoothEnabled()) {
            if (timer != null) {
                timer.stop();
            }
            timer = null;
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            WatchUi.requestUpdate();
        }
    }

    /*
    Set timer to check every second if Bluetooth is active
    */
    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.NoBluetoothLayout(dc));
        if (timer == null) {
            timer = new Timer.Timer();
            System.println("TIMER ONLAYOUT - timer is null");
        } else {
            timer.stop();
        }
        System.println("TIMER ONLAYOUT");
        timer.start(method(:check_connection), 1000, true);

    }

    public function onShow() as Void {
        WatchUi.requestUpdate();
    }

    public function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

    }




}
