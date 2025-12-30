import Toybox.Lang;
import Toybox.Application.Storage;

// 設定の永続化（秒単位）
class SettingsStorage {
    private static const KEY_DURATION = "duration_sec";
    private static const KEY_ALERT1 = "alert1_sec";
    private static const KEY_ALERT2 = "alert2_sec";

    // デフォルト値（秒単位）
    private static const DEFAULT_DURATION = 900;  // 15分
    private static const DEFAULT_ALERT1 = 300;    // 5分
    private static const DEFAULT_ALERT2 = 60;     // 1分

    // 設定を読み込んでTimerStateに適用
    static function loadSettings(state as TimerState) as Void {
        state.durationSeconds = loadDuration();
        state.alert1Seconds = loadAlert1();
        state.alert2Seconds = loadAlert2();
    }

    // Duration を読み込み
    static function loadDuration() as Number {
        var value = Storage.getValue(KEY_DURATION);
        if (value != null && value instanceof Number) {
            return value as Number;
        }
        return DEFAULT_DURATION;
    }

    // Alert1 を読み込み
    static function loadAlert1() as Number {
        var value = Storage.getValue(KEY_ALERT1);
        if (value != null && value instanceof Number) {
            return value as Number;
        }
        return DEFAULT_ALERT1;
    }

    // Alert2 を読み込み
    static function loadAlert2() as Number {
        var value = Storage.getValue(KEY_ALERT2);
        if (value != null && value instanceof Number) {
            return value as Number;
        }
        return DEFAULT_ALERT2;
    }

    // Duration を保存
    static function saveDuration(value as Number) as Void {
        Storage.setValue(KEY_DURATION, value);
    }

    // Alert1 を保存
    static function saveAlert1(value as Number) as Void {
        Storage.setValue(KEY_ALERT1, value);
    }

    // Alert2 を保存
    static function saveAlert2(value as Number) as Void {
        Storage.setValue(KEY_ALERT2, value);
    }
}
