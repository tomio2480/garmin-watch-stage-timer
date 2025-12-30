import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class StageTimerApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new StageTimerView(), new StageTimerDelegate()];
    }
}

function getApp() as StageTimerApp {
    return Application.getApp() as StageTimerApp;
}
