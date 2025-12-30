import Toybox.Lang;

// プリセットデータ
class Preset {
    public var name as String;
    public var durationSeconds as Number;
    public var alert1Seconds as Number;
    public var alert2Seconds as Number;

    function initialize(name as String, duration as Number, alert1 as Number, alert2 as Number) {
        self.name = name;
        self.durationSeconds = duration;
        self.alert1Seconds = alert1;
        self.alert2Seconds = alert2;
    }
}

// 組み込みプリセット
class PresetManager {
    private static var _presets as Array<Preset>?;

    // プリセット一覧を取得
    static function getPresets() as Array<Preset> {
        if (_presets == null) {
            _presets = [
                new Preset("LT (5min)", 300, 60, 30),
                new Preset("Standard (15min)", 900, 300, 60),
                new Preset("Long (20min)", 1200, 300, 60),
                new Preset("Presentation (45min)", 2700, 600, 120)
            ] as Array<Preset>;
        }
        return _presets as Array<Preset>;
    }

    // プリセットをTimerStateに適用
    static function applyPreset(preset as Preset, state as TimerState) as Void {
        state.durationSeconds = preset.durationSeconds;
        state.alert1Seconds = preset.alert1Seconds;
        state.alert2Seconds = preset.alert2Seconds;

        // ストレージに保存
        SettingsStorage.saveDuration(preset.durationSeconds);
        SettingsStorage.saveAlert1(preset.alert1Seconds);
        SettingsStorage.saveAlert2(preset.alert2Seconds);

        // タイマーをリセット
        if (state.status == TIMER_STOPPED) {
            state.reset();
        }
    }
}
