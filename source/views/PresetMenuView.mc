import Toybox.Lang;
import Toybox.WatchUi;

// プリセット選択メニュー
class PresetMenuView extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title => "Presets"});

        var presets = PresetManager.getPresets();
        for (var i = 0; i < presets.size(); i++) {
            var preset = presets[i];
            addItem(new WatchUi.MenuItem(
                preset.name,
                formatSeconds(preset.durationSeconds),
                i,
                {}
            ));
        }
    }
}

// プリセット選択デリゲート
class PresetMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _settingsMenuView as SettingsMenuView;

    function initialize(settingsMenuView as SettingsMenuView) {
        Menu2InputDelegate.initialize();
        _settingsMenuView = settingsMenuView;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var index = item.getId() as Number;
        var presets = PresetManager.getPresets();

        if (index >= 0 && index < presets.size()) {
            var preset = presets[index];
            var state = gTimerState;
            if (state != null) {
                PresetManager.applyPreset(preset, state);
                _settingsMenuView.updateAllItems();
            }
        }

        // プリセットメニューを閉じる
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
