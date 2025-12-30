import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

// 秒を MM:SS 形式にフォーマット
function formatSeconds(seconds as Number) as String {
    var min = seconds / 60;
    var sec = seconds % 60;
    return min.format("%d") + ":" + sec.format("%02d");
}

// 設定メニュー
class SettingsMenuView extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title => "Settings"});

        var state = gTimerState;
        if (state != null) {
            addItem(new WatchUi.MenuItem(
                "Duration",
                formatSeconds(state.durationSeconds),
                :duration,
                {}
            ));
            addItem(new WatchUi.MenuItem(
                "Alert 1",
                formatSeconds(state.alert1Seconds),
                :alert1,
                {}
            ));
            addItem(new WatchUi.MenuItem(
                "Alert 2",
                formatSeconds(state.alert2Seconds),
                :alert2,
                {}
            ));
        }
    }

    // メニュー項目のサブラベルを更新
    function updateItemSubLabel(id as Symbol, seconds as Number) as Void {
        var index = findItemById(id);
        if (index != -1) {
            var item = getItem(index);
            if (item != null) {
                item.setSubLabel(formatSeconds(seconds));
            }
        }
    }

    // 全項目を更新
    function updateAllItems() as Void {
        var state = gTimerState;
        if (state != null) {
            updateItemSubLabel(:duration, state.durationSeconds);
            updateItemSubLabel(:alert1, state.alert1Seconds);
            updateItemSubLabel(:alert2, state.alert2Seconds);
        }
    }
}

// 設定メニューのデリゲート
class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _menuView as SettingsMenuView;

    function initialize(menuView as SettingsMenuView) {
        Menu2InputDelegate.initialize();
        _menuView = menuView;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        var state = gTimerState;
        if (state == null) {
            return;
        }

        if (id == :duration) {
            // Duration: 10秒 ~ 3600秒（1時間）
            WatchUi.pushView(
                new TimePickerView(:duration, "Duration", 10, 3600),
                new TimePickerDelegate(:duration, _menuView),
                WatchUi.SLIDE_LEFT
            );
        } else if (id == :alert1) {
            // Alert1: 0秒 ~ Duration - 1秒
            var maxAlert1 = state.durationSeconds - 1;
            if (maxAlert1 < 0) {
                maxAlert1 = 0;
            }
            WatchUi.pushView(
                new TimePickerView(:alert1, "Alert 1", 0, maxAlert1),
                new TimePickerDelegate(:alert1, _menuView),
                WatchUi.SLIDE_LEFT
            );
        } else if (id == :alert2) {
            // Alert2: 0秒 ~ Alert1 - 1秒
            var maxAlert2 = state.alert1Seconds - 1;
            if (maxAlert2 < 0) {
                maxAlert2 = 0;
            }
            WatchUi.pushView(
                new TimePickerView(:alert2, "Alert 2", 0, maxAlert2),
                new TimePickerDelegate(:alert2, _menuView),
                WatchUi.SLIDE_LEFT
            );
        }
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
