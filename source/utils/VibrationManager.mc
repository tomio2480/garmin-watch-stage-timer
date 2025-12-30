import Toybox.Lang;
import Toybox.Attention;
import Toybox.Timer;

// バイブレーション管理クラス
class VibrationManager {
    // タイムアップ時の連続バイブ用タイマー
    private var _timeUpTimer as Timer.Timer?;
    private var _isTimeUpVibrating as Boolean = false;

    function initialize() {
    }

    // アラート1: 長振動1回（1000ms）
    function vibrateAlert1() as Void {
        if (Attention has :vibrate) {
            var pattern = [
                new Attention.VibeProfile(100, 1000)  // 強度100%, 1000ms
            ] as Array<Attention.VibeProfile>;
            Attention.vibrate(pattern);
        }
    }

    // アラート2: 短振動4回（500ms ON, 500ms OFF × 4）
    function vibrateAlert2() as Void {
        if (Attention has :vibrate) {
            var pattern = [
                new Attention.VibeProfile(100, 500),  // ON 500ms
                new Attention.VibeProfile(0, 500),    // OFF 500ms
                new Attention.VibeProfile(100, 500),  // ON 500ms
                new Attention.VibeProfile(0, 500),    // OFF 500ms
                new Attention.VibeProfile(100, 500),  // ON 500ms
                new Attention.VibeProfile(0, 500),    // OFF 500ms
                new Attention.VibeProfile(100, 500)   // ON 500ms
            ] as Array<Attention.VibeProfile>;
            Attention.vibrate(pattern);
        }
    }

    // ファイナルカウント: 短振動1回（100ms）
    function vibrateFinalCount() as Void {
        if (Attention has :vibrate) {
            var pattern = [
                new Attention.VibeProfile(100, 100)  // 強度100%, 100ms
            ] as Array<Attention.VibeProfile>;
            Attention.vibrate(pattern);
        }
    }

    // タイムアップ: 連続振動開始（300ms ON, 300ms OFF）
    function startTimeUpVibration() as Void {
        if (_isTimeUpVibrating) {
            return;
        }
        _isTimeUpVibrating = true;

        // 最初のバイブレーション
        vibrateTimeUpOnce();

        // 600ms ごとに繰り返し
        _timeUpTimer = new Timer.Timer();
        _timeUpTimer.start(method(:vibrateTimeUpOnce), 600, true);
    }

    // タイムアップの1回分バイブレーション
    function vibrateTimeUpOnce() as Void {
        if (Attention has :vibrate) {
            var pattern = [
                new Attention.VibeProfile(100, 300)  // ON 300ms
            ] as Array<Attention.VibeProfile>;
            Attention.vibrate(pattern);
        }
    }

    // タイムアップ振動を停止
    function stopTimeUpVibration() as Void {
        _isTimeUpVibrating = false;
        if (_timeUpTimer != null) {
            _timeUpTimer.stop();
            _timeUpTimer = null;
        }
    }

    // 振動中かどうか
    function isTimeUpVibrating() as Boolean {
        return _isTimeUpVibrating;
    }
}
