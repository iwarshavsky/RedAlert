import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Communications;

/*
Create the Basic Drawables custom menu
*/
function pushBasicCustom(match_dict as Dictionary<String, String>, callback as Method) as Void {

    
    var title = new WatchUi.Text({
            :text=>Application.loadResource(Rez.Strings.multichoiceTitle),
            :color=>Graphics.COLOR_WHITE,
            :font=>WatchUi.loadResource(Rez.Fonts.f1_small),
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    var footer = new DrawableMenuFooter();
    var customMenu = new WatchUi.CustomMenu(35, Graphics.COLOR_BLACK, {
        :focusItemHeight=>55,
        :title=>title,
        :footer=>footer
    });

    /*
        :foreground=> Graphics.COLOR_BLUE, //new $.Rez.Drawables.MenuForeground(),
        :title=>new $.DrawableMenuTitle(),
        :footer=>new $.DrawableMenuFooter()
    */

    var keys = match_dict.keys();
    for (var i = 0; i < keys.size(); i++) {
        customMenu.addItem(new $.CustomItem(i.toNumber(), keys[i]));
    }
    if (keys.size() == 0) {
        customMenu.addItem(new $.CustomItem($.NO_LOCATION_FOUND, Application.loadResource(Rez.Strings.noLocationMatch)));
    }
    WatchUi.pushView(customMenu, new $.BasicCustomDelegate(callback), WatchUi.SLIDE_UP);
}



class BasicCustomDelegate extends WatchUi.Menu2InputDelegate {
/*
This is the menu input delegate for the Basic Drawables menu
*/
    private var callback as Method;

    public function initialize(cb) {
        callback = cb;
        Menu2InputDelegate.initialize();
    }

    /*
    Select method for list
    */
    public function onSelect(item as MenuItem) as Void {
        if (item.getId() == $.NO_LOCATION_FOUND) {
            System.println("No match");
        } else {
            self.callback.invoke(item.getLabel());
        }
        if (timer != null) {
            timer.stop();
        }
        timer = null;
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
    }

    /*
    Handle the back key being pressed
    */
    public function onBack() as Void {
        Storage.deleteValue($.alert_location_key);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    /*
    Handle the user navigating off the end of the menu
    @param key The key triggering the menu wrap
    @return true if wrap is allowed, false otherwise
    */
    public function onWrap(key as Key) as Boolean {
        // Don't allow wrapping
        return false;
    }
}


class CustomItem extends WatchUi.CustomMenuItem {
/*
This is the custom item drawable.
It draws the label it is initialized with at the center of the region
*/
    private var _label as String;

    /*
    @param id The identifier for this item
    @param text Text to display
    */
    public function initialize(id, text as String) {
        CustomMenuItem.initialize(id, {});
        _label = text;
    }

    /*
    Draw the item string at the center of the item.
    */
    public function draw(dc as Dc) as Void {
        // var font = Graphics.FONT_SMALL;
        // if (isFocused()) {
        //     font = Graphics.FONT_LARGE;
        // }

        if (isSelected()) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();
        }
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, $.customFont, _label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(0, 0, dc.getWidth(), 0);
        dc.drawLine(0, dc.getHeight() - 1, dc.getWidth(), dc.getHeight() - 1);
    }

    /*
    Get the item label
    */
    public function getLabel() as String {
        return _label;
    }
}


class DrawableMenuFooter extends WatchUi.Drawable {
/*
This is the drawable for the custom menu footer
*/

    public function initialize() {
        Drawable.initialize({});
    }

    /*
    Draw bottom half of the last dividing line below the final item
    */
    public function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawLine(0, 0, dc.getWidth(), 0);
    }
}

//! This is the custom drawable we will use for our main menu title
// class DrawableMenuTitle extends WatchUi.Drawable {

//     //! Constructor
//     public function initialize() {
//         Drawable.initialize({});
//     }

//     //! Draw the application icon and main menu title
//     //! @param dc Device Context
//     public function draw(dc as Dc) as Void {
//         var spacing = 2;
//         var appIcon = WatchUi.loadResource($.Rez.Drawables.LauncherIcon) as BitmapResource;
//         var bitmapWidth = appIcon.getWidth();
//         var labelWidth = dc.getTextWidthInPixels("Menu2", customFont);

//         var bitmapX = (dc.getWidth() - (bitmapWidth + spacing + labelWidth)) / 2;
//         var bitmapY = (dc.getHeight() - appIcon.getHeight()) / 2;
//         var labelX = bitmapX + bitmapWidth + spacing;
//         var labelY = dc.getHeight() / 2;

//         dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
//         dc.clear();

//         dc.drawBitmap(bitmapX, bitmapY, appIcon);
//         dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
//         dc.drawText(labelX, labelY, customFont, "Menu2", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
//     }
// }