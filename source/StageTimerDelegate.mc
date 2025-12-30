import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class StageTimerDelegate extends WatchUi.BehaviorDelegate {
    // 長押し判定用
    private var _keyDownTime as Number = 0;
    private const LONG_PRESS_DURATION = 3000; // 3秒

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // 右上ボタン（Enter/Select）の処理
    function onSelect() as Boolean {
        return handleStartPause();
    }

    // キー押下開始
    function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
            _keyDownTime = System.getTimer();
        }
        return false;
    }

    // キー離し
    function onKeyReleased(keyEvent as WatchUi.KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
            var duration = System.getTimer() - _keyDownTime;
            if (duration >= LONG_PRESS_DURATION) {
                // 長押し: リセット
                return handleReset();
            }
        }
        return false;
    }

    // タップ操作
    function onTap(clickEvent as WatchUi.ClickEvent) as Boolean {
        return handleStartPause();
    }

    // 長押し操作（タッチスクリーン）
    function onHold(clickEvent as WatchUi.ClickEvent) as Boolean {
        return handleReset();
    }

    // 開始/一時停止/再開の処理
    private function handleStartPause() as Boolean {
        var state = gTimerState;
        if (state == null) {
            return false;
        }

        if (state.status == TIMER_FINISHED) {
            // タイムアップ状態からタップでリセット
            state.reset();
        } else {
            state.toggleStartPause();
        }

        WatchUi.requestUpdate();
        return true;
    }

    // リセット処理
    private function handleReset() as Boolean {
        var state = gTimerState;
        if (state == null) {
            return false;
        }

        // 実行中または一時停止中のみリセット可能
        if (state.status == TIMER_RUNNING || state.status == TIMER_PAUSED) {
            state.reset();
            WatchUi.requestUpdate();
            return true;
        }

        return false;
    }

    // 戻るボタン（アプリ終了）
    function onBack() as Boolean {
        var state = gTimerState;
        if (state != null && state.status == TIMER_STOPPED) {
            // 停止中のみ戻るボタンでアプリ終了
            return false; // システムに処理を委譲
        }
        // 実行中・一時停止中は戻るボタンを無効化
        return true;
    }
}
