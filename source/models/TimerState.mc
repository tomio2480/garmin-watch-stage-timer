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
    // 設定値
    public var durationMinutes as Number = 15;
    public var alert1Minutes as Number = 5;
    public var alert2Minutes as Number = 1;

    // テスト用設定（秒単位）- 0 の場合は本番設定を使用
    private var _testDurationSeconds as Number = 0;
    private var _testAlert1Seconds as Number = 0;
    private var _testAlert2Seconds as Number = 0;

    // 現在の状態
    public var status as TimerStatus = TIMER_STOPPED;
    public var remainingSeconds as Number = 0;

    // アラート発火済みフラグ
    public var alert1Triggered as Boolean = false;
    public var alert2Triggered as Boolean = false;
    public var finalCountStarted as Boolean = false;

    function initialize() {
        reset();
    }

    // タイマーをリセット
    function reset() as Void {
        if (_testDurationSeconds > 0) {
            remainingSeconds = _testDurationSeconds;
        } else {
            remainingSeconds = durationMinutes * 60;
        }
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

    // アラート1の残り秒数を取得
    function getAlert1Seconds() as Number {
        if (_testAlert1Seconds > 0) {
            return _testAlert1Seconds;
        }
        return alert1Minutes * 60;
    }

    // アラート2の残り秒数を取得
    function getAlert2Seconds() as Number {
        if (_testAlert2Seconds > 0) {
            return _testAlert2Seconds;
        }
        return alert2Minutes * 60;
    }

    // 現在アラート1の状態か
    function isAlert1Active() as Boolean {
        var alert1Sec = getAlert1Seconds();
        var alert2Sec = getAlert2Seconds();
        return remainingSeconds <= alert1Sec && remainingSeconds > alert2Sec;
    }

    // 現在アラート2の状態か
    function isAlert2Active() as Boolean {
        var alert2Sec = getAlert2Seconds();
        return remainingSeconds <= alert2Sec && remainingSeconds > 5;
    }

    // ファイナルカウント中か（残り5秒以下）
    function isFinalCount() as Boolean {
        return remainingSeconds <= 5 && remainingSeconds > 0;
    }
}
