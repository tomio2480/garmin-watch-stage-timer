import Toybox.Lang;

// タイマーの状態を表す列挙型
enum TimerStatus {
    TIMER_STOPPED,   // 停止中（初期状態）
    TIMER_RUNNING,   // 実行中
    TIMER_PAUSED,    // 一時停止中
    TIMER_FINISHED   // タイムアップ
}

// タイマーの状態を管理するクラス
class TimerState {
    // 設定値（秒単位）
    public var durationSeconds as Number = 900;  // 15分 = 900秒
    public var alert1Seconds as Number = 300;    // 5分 = 300秒
    public var alert2Seconds as Number = 60;     // 1分 = 60秒

    // 現在の状態
    public var status as TimerStatus = TIMER_STOPPED;
    public var remainingSeconds as Number = 0;

    // アラート発火済みフラグ
    public var alert1Triggered as Boolean = false;
    public var alert2Triggered as Boolean = false;
    public var finalCountStarted as Boolean = false;

    function initialize() {
        SettingsStorage.loadSettings(self);
        reset();
    }

    // タイマーをリセット
    function reset() as Void {
        remainingSeconds = durationSeconds;
        status = TIMER_STOPPED;
        alert1Triggered = false;
        alert2Triggered = false;
        finalCountStarted = false;
    }

    // タイマーを開始
    function start() as Void {
        if (status == TIMER_STOPPED || status == TIMER_PAUSED) {
            status = TIMER_RUNNING;
        }
    }

    // タイマーを一時停止
    function pause() as Void {
        if (status == TIMER_RUNNING) {
            status = TIMER_PAUSED;
        }
    }

    // タイマーを再開
    function resume() as Void {
        if (status == TIMER_PAUSED) {
            status = TIMER_RUNNING;
        }
    }

    // 開始/一時停止をトグル
    function toggleStartPause() as Void {
        if (status == TIMER_STOPPED) {
            start();
        } else if (status == TIMER_RUNNING) {
            pause();
        } else if (status == TIMER_PAUSED) {
            resume();
        }
    }

    // 1秒経過（タイマー更新）
    function tick() as Void {
        if (status != TIMER_RUNNING) {
            return;
        }

        if (remainingSeconds > 0) {
            remainingSeconds -= 1;
        }

        if (remainingSeconds <= 0) {
            status = TIMER_FINISHED;
        }
    }

    // 残り時間をフォーマット（MM:SS）
    function getFormattedTime() as String {
        var minutes = remainingSeconds / 60;
        var seconds = remainingSeconds % 60;
        return minutes.format("%02d") + ":" + seconds.format("%02d");
    }

    // 現在アラート1の状態か
    function isAlert1Active() as Boolean {
        return remainingSeconds <= alert1Seconds && remainingSeconds > alert2Seconds;
    }

    // 現在アラート2の状態か
    function isAlert2Active() as Boolean {
        return remainingSeconds <= alert2Seconds && remainingSeconds > 5;
    }

    // ファイナルカウント中か（残り5秒以下）
    function isFinalCount() as Boolean {
        return remainingSeconds <= 5 && remainingSeconds > 0;
    }
}
