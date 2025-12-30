import Toybox.Lang;
import Toybox.WatchUi;

class StageTimerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(keyEvent as WatchUi.KeyEvent) as Boolean {
        return false;
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Boolean {
        return false;
    }
}
