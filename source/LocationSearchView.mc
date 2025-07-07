
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Attention;


class LocationSearchView extends WatchUi.View {
/*
View for Location search.
*/
    private var total = 0;
    private var progress = 0;
    
    public function initialize() {
        WatchUi.View.initialize();
    }

    /*
    Handles with the request using a RequestLocation object
    */
    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.LocationSearch(dc));
        var locationRequest = new RequestLocation();
        locationRequest.startSync(method(:updateProgress));
    }


    public function onShow() as Void {
        WatchUi.requestUpdate();
    }

    /*
    Draw progression arcs
    */
    public function onUpdate(dc as Dc) as Void {
        
        View.onUpdate(dc);
        if (progress >= 1) {
            dc.setPenWidth(4);
            dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2,  (dc.getWidth() / 2)-3, Graphics.ARC_CLOCKWISE, 90, (90-(360/total)*(progress))%360);
            dc.setPenWidth(1);
        }
        
    }

    /*
    Callback for screen update - calls screen update with current progress.
    */
    public function updateProgress(prog as Number, tot as Number) as Void {
        progress = prog;
        total = tot;
        WatchUi.requestUpdate();
    }



}
