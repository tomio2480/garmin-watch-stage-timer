import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

// グローバルなタイマー状態（アプリ全体で共有）
var gTimerState as TimerState?;
var gVibrationManager as VibrationManager?;

class StageTimerView extends WatchUi.View {
    private var _timer as Timer.Timer?;

    function initialize() {
        View.initialize();
        if (gTimerState == null) {
            gTimerState = new TimerState();
        }
        if (gVibrationManager == null) {
            gVibrationManager = new VibrationManager();
        }
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
        // 設定画面から戻ったときにタイマーをリセット
        var state = gTimerState;
        if (state != null && state.status == TIMER_STOPPED) {
            state.reset();
        }

        // 1秒ごとのタイマーを開始
        _timer = new Timer.Timer();
        _timer.start(method(:onTimerTick), 1000, true);
    }

    function onTimerTick() as Void {
        var state = gTimerState;
        var vibManager = gVibrationManager;

        if (state != null) {
            // tick の前の残り秒数を記録
            var prevSeconds = state.remainingSeconds;

            state.tick();

            // バイブレーション処理
            if (vibManager != null && state.status == TIMER_RUNNING) {
                checkAndTriggerVibration(state, vibManager, prevSeconds);
            }

            // タイムアップ時のバイブレーション開始
            if (vibManager != null && state.status == TIMER_FINISHED) {
                if (!vibManager.isTimeUpVibrating()) {
                    vibManager.startTimeUpVibration();
                }
            }
        }

        WatchUi.requestUpdate();
    }

    // バイブレーションのチェックとトリガー
    private function checkAndTriggerVibration(state as TimerState, vibManager as VibrationManager, prevSeconds as Number) as Void {
        var currentSeconds = state.remainingSeconds;
        var alert1Sec = state.alert1Seconds;
        var alert2Sec = state.alert2Seconds;

        // アラート1: 残り時間がアラート1秒数に達した瞬間
        if (prevSeconds > alert1Sec && currentSeconds <= alert1Sec && !state.alert1Triggered) {
            vibManager.vibrateAlert1();
            state.alert1Triggered = true;
        }

        // アラート2: 残り時間がアラート2秒数に達した瞬間
        if (prevSeconds > alert2Sec && currentSeconds <= alert2Sec && !state.alert2Triggered) {
            vibManager.vibrateAlert2();
            state.alert2Triggered = true;
        }

        // ファイナルカウント: 残り5,4,3,2,1秒で各1回
        if (currentSeconds <= 5 && currentSeconds >= 1 && prevSeconds != currentSeconds) {
            if (!state.finalCountStarted || currentSeconds < 5) {
                vibManager.vibrateFinalCount();
                state.finalCountStarted = true;
            }
        }
    }

    function onUpdate(dc as Dc) as Void {
        var state = gTimerState;
        if (state == null) {
            return;
        }

        var width = dc.getWidth();
        var height = dc.getHeight();

        // 背景色とテキスト色を状態に応じて設定
        var bgColor = Graphics.COLOR_BLACK;
        var textColor = Graphics.COLOR_WHITE;
        var statusText = "";

        if (state.status == TIMER_FINISHED) {
            // タイムアップ: 白背景、黒文字
            bgColor = Graphics.COLOR_WHITE;
            textColor = Graphics.COLOR_BLACK;
            statusText = "Time Up!";
        } else if (state.status == TIMER_PAUSED) {
            // 一時停止: グレー文字
            textColor = Graphics.COLOR_LT_GRAY;
            statusText = "PAUSED";
        } else if (state.status == TIMER_STOPPED) {
            // 停止中
            statusText = "READY";
        } else if (state.status == TIMER_RUNNING) {
            // 実行中: アラート状態に応じて色を変更
            if (state.isFinalCount() || state.isAlert2Active()) {
                textColor = 0xFF00FF; // マゼンタ
            } else if (state.isAlert1Active()) {
                textColor = Graphics.COLOR_YELLOW;
            }
            statusText = "RUNNING";
        }

        // 背景をクリア
        dc.setColor(bgColor, bgColor);
        dc.clear();

        // 残り時間を大きく表示
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height / 2 - 20,
            Graphics.FONT_NUMBER_HOT,
            state.getFormattedTime(),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // ステータス表示
        dc.drawText(
            width / 2,
            height / 2 + 50,
            Graphics.FONT_SMALL,
            statusText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // 操作ヒント（停止中のみ）
        if (state.status == TIMER_STOPPED) {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2,
                height * 3 / 4,
                Graphics.FONT_XTINY,
                "Swipe for Settings",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
    }

    function onHide() as Void {
        // タイマーを停止
        if (_timer != null) {
            _timer.stop();
            _timer = null;
        }
        // バイブレーションを停止
        if (gVibrationManager != null) {
            gVibrationManager.stopTimeUpVibration();
        }
    }
}
