import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

// 時間選択ビュー（分と秒を別々に調整可能）
class TimePickerView extends WatchUi.View {
    private var _settingId as Symbol;
    private var _title as String;
    private var _minValue as Number;
    private var _maxValue as Number;
    private var _minutes as Number;
    private var _seconds as Number;
    private var _editingMinutes as Boolean = true;  // true: 分を編集中、false: 秒を編集中

    function initialize(settingId as Symbol, title as String, minValue as Number, maxValue as Number) {
        View.initialize();
        _settingId = settingId;
        _title = title;
        _minValue = minValue;
        _maxValue = maxValue;

        var currentValue = getCurrentValue();
        // 現在値が最大値を超えている場合は最大値に調整
        if (currentValue > _maxValue) {
            currentValue = _maxValue;
        }
        _minutes = currentValue / 60;
        _seconds = (currentValue % 60) / 5 * 5;  // 5秒刻みに丸める
    }

    private function getCurrentValue() as Number {
        var state = gTimerState;
        if (state == null) {
            return _minValue;
        }

        if (_settingId == :duration) {
            return state.durationSeconds;
        } else if (_settingId == :alert1) {
            return state.alert1Seconds;
        } else if (_settingId == :alert2) {
            return state.alert2Seconds;
        }
        return _minValue;
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        // タイトル
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height / 4,
            Graphics.FONT_SMALL,
            _title,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // 分の表示（編集中は青、非編集は灰色）
        var minColor = _editingMinutes ? Graphics.COLOR_BLUE : Graphics.COLOR_DK_GRAY;
        dc.setColor(minColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2 - 55,
            height / 2,
            Graphics.FONT_NUMBER_MEDIUM,
            _minutes.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // コロン
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height / 2,
            Graphics.FONT_NUMBER_MEDIUM,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // 秒の表示（編集中は青、非編集は灰色）
        var secColor = _editingMinutes ? Graphics.COLOR_DK_GRAY : Graphics.COLOR_BLUE;
        dc.setColor(secColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2 + 55,
            height / 2,
            Graphics.FONT_NUMBER_MEDIUM,
            _seconds.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        // 操作ヒント
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height * 3 / 4,
            Graphics.FONT_XTINY,
            "BTN: switch, BACK: OK",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // 分と秒の切り替え
    function toggleEditMode() as Void {
        _editingMinutes = !_editingMinutes;
        WatchUi.requestUpdate();
    }

    function isEditingMinutes() as Boolean {
        return _editingMinutes;
    }

    function incrementMinutes() as Void {
        var newTotal = (_minutes + 1) * 60 + _seconds;
        if (newTotal <= _maxValue) {
            _minutes += 1;
            WatchUi.requestUpdate();
        }
    }

    function decrementMinutes() as Void {
        if (_minutes > 0) {
            var newTotal = (_minutes - 1) * 60 + _seconds;
            if (newTotal >= _minValue) {
                _minutes -= 1;
                WatchUi.requestUpdate();
            }
        }
    }

    function incrementSeconds() as Void {
        var newSeconds = _seconds + 5;
        if (newSeconds >= 60) {
            // 60秒になったら分を繰り上げ
            var newTotal = (_minutes + 1) * 60;
            if (newTotal <= _maxValue) {
                _minutes += 1;
                _seconds = 0;
                WatchUi.requestUpdate();
            }
        } else {
            var newTotal = _minutes * 60 + newSeconds;
            if (newTotal <= _maxValue) {
                _seconds = newSeconds;
                WatchUi.requestUpdate();
            }
        }
    }

    function decrementSeconds() as Void {
        if (_seconds >= 5) {
            var newTotal = _minutes * 60 + _seconds - 5;
            if (newTotal >= _minValue) {
                _seconds -= 5;
                WatchUi.requestUpdate();
            }
        } else if (_minutes > 0) {
            // 0秒未満になったら分を繰り下げ
            var newTotal = (_minutes - 1) * 60 + 55;
            if (newTotal >= _minValue) {
                _minutes -= 1;
                _seconds = 55;
                WatchUi.requestUpdate();
            }
        }
    }

    function getValue() as Number {
        return _minutes * 60 + _seconds;
    }

    function getSettingId() as Symbol {
        return _settingId;
    }
}

// 時間選択デリゲート
class TimePickerDelegate extends WatchUi.BehaviorDelegate {
    private var _menuView as SettingsMenuView;

    function initialize(menuView as SettingsMenuView) {
        BehaviorDelegate.initialize();
        _menuView = menuView;
    }

    // 上ボタンで増加
    function onNextPage() as Boolean {
        var view = WatchUi.getCurrentView()[0];
        if (view instanceof TimePickerView) {
            var picker = view as TimePickerView;
            if (picker.isEditingMinutes()) {
                picker.incrementMinutes();
            } else {
                picker.incrementSeconds();
            }
        }
        return true;
    }

    // 下ボタンで減少
    function onPreviousPage() as Boolean {
        var view = WatchUi.getCurrentView()[0];
        if (view instanceof TimePickerView) {
            var picker = view as TimePickerView;
            if (picker.isEditingMinutes()) {
                picker.decrementMinutes();
            } else {
                picker.decrementSeconds();
            }
        }
        return true;
    }

    // ボタン押しで分/秒切り替え
    function onSelect() as Boolean {
        var view = WatchUi.getCurrentView()[0];
        if (view instanceof TimePickerView) {
            (view as TimePickerView).toggleEditMode();
        }
        return true;
    }

    // 戻るボタンで確定
    function onBack() as Boolean {
        var view = WatchUi.getCurrentView()[0];
        if (view instanceof TimePickerView) {
            var pickerView = view as TimePickerView;
            var value = pickerView.getValue();
            var settingId = pickerView.getSettingId();
            applyValue(settingId, value);
        }
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    private function applyValue(settingId as Symbol, value as Number) as Void {
        var state = gTimerState;
        if (state == null) {
            return;
        }

        if (settingId == :duration) {
            state.durationSeconds = value;
            SettingsStorage.saveDuration(value);
            // Duration が変更されたら Alert の整合性をチェック
            adjustAlertsForDuration(state, value);
        } else if (settingId == :alert1) {
            state.alert1Seconds = value;
            SettingsStorage.saveAlert1(value);
            // Alert1 が変更されたら Alert2 の整合性をチェック
            if (state.alert2Seconds >= value) {
                var newAlert2 = value - 5;
                if (newAlert2 < 0) {
                    newAlert2 = 0;
                }
                state.alert2Seconds = newAlert2;
                SettingsStorage.saveAlert2(newAlert2);
            }
        } else if (settingId == :alert2) {
            state.alert2Seconds = value;
            SettingsStorage.saveAlert2(value);
        }

        // メニューの表示を更新
        _menuView.updateAllItems();

        // タイマーが停止中ならリセットして新しい値を反映
        if (state.status == TIMER_STOPPED) {
            state.reset();
        }
    }

    // Duration 変更時に Alert を自動調整
    private function adjustAlertsForDuration(state as TimerState, duration as Number) as Void {
        var needsAdjustment = false;

        // Alert1 が Duration 以上なら調整が必要
        if (state.alert1Seconds >= duration) {
            needsAdjustment = true;
        }
        // Alert2 が Alert1 以上なら調整が必要
        if (state.alert2Seconds >= state.alert1Seconds) {
            needsAdjustment = true;
        }

        if (needsAdjustment) {
            // Duration の 20% を Alert1、10% を Alert2 に設定
            var newAlert1 = (duration * 20 / 100).toNumber();
            var newAlert2 = (duration * 10 / 100).toNumber();

            // 5秒刻みに丸める
            newAlert1 = (newAlert1 / 5) * 5;
            newAlert2 = (newAlert2 / 5) * 5;

            // 最低でも Alert1 > Alert2 >= 0 を保証
            if (newAlert1 < 5) {
                newAlert1 = 5;
            }
            if (newAlert1 >= duration) {
                newAlert1 = duration - 5;
            }
            if (newAlert2 >= newAlert1) {
                newAlert2 = newAlert1 - 5;
            }
            if (newAlert2 < 0) {
                newAlert2 = 0;
            }

            state.alert1Seconds = newAlert1;
            state.alert2Seconds = newAlert2;
            SettingsStorage.saveAlert1(newAlert1);
            SettingsStorage.saveAlert2(newAlert2);
        }
    }
}
