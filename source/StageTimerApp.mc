import Toybox.Application;
import Toybox.Application.Properties;
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

    // スマホから設定が変更されたときに呼ばれる
    function onSettingsChanged() as Void {
        loadPropertiesSettings();
        WatchUi.requestUpdate();
    }

    // Properties から設定を読み込み、TimerState に適用
    function loadPropertiesSettings() as Void {
        var state = gTimerState;
        if (state == null) {
            return;
        }

        // プリセットの確認
        var preset = Properties.getValue("preset");
        if (preset != null && preset instanceof Number) {
            var presetNum = preset as Number;
            if (presetNum > 0 && presetNum <= 4) {
                // プリセットが選択されている場合はプリセット値を適用
                applyPresetFromNumber(presetNum, state);
                return;
            }
        }

        // カスタム設定の場合は個別の値を読み込み
        var duration = Properties.getValue("duration");
        if (duration != null && duration instanceof Number) {
            state.durationSeconds = duration as Number;
            SettingsStorage.saveDuration(state.durationSeconds);
        }

        var alert1 = Properties.getValue("alert1");
        if (alert1 != null && alert1 instanceof Number) {
            state.alert1Seconds = alert1 as Number;
            SettingsStorage.saveAlert1(state.alert1Seconds);
        }

        var alert2 = Properties.getValue("alert2");
        if (alert2 != null && alert2 instanceof Number) {
            state.alert2Seconds = alert2 as Number;
            SettingsStorage.saveAlert2(state.alert2Seconds);
        }

        // タイマーが停止中ならリセット
        if (state.status == TIMER_STOPPED) {
            state.reset();
        }
    }

    // プリセット番号からプリセットを適用
    private function applyPresetFromNumber(presetNum as Number, state as TimerState) as Void {
        var presets = PresetManager.getPresets();
        var index = presetNum - 1;  // 1-indexed to 0-indexed
        if (index >= 0 && index < presets.size()) {
            PresetManager.applyPreset(presets[index], state);
        }
    }
}

function getApp() as StageTimerApp {
    return Application.getApp() as StageTimerApp;
}
