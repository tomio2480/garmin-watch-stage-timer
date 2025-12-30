import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class StageTimerView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        // 背景を黒でクリア（AMOLED では電力消費ゼロ）
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // テスト表示: 中央に "Stage Timer" と表示
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var width = dc.getWidth();
        var height = dc.getHeight();
        dc.drawText(
            width / 2,
            height / 2,
            Graphics.FONT_MEDIUM,
            "Stage Timer",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function onHide() as Void {
    }
}
