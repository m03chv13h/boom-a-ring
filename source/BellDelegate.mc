import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Input delegate that plays the bell tone on long press of the up button.
class BellDelegate extends WatchUi.BehaviorDelegate {

    //! Timestamp (ms) when the up button was last pressed down.
    private var _upPressTime as Number = 0;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Record the time when the up button is pressed.
    function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Boolean {
        if (keyEvent.getKey() == WatchUi.KEY_UP) {
            _upPressTime = System.getTimer();
            return true;
        }
        return false;
    }

    //! Play the bell tone if the up button was held for at least 500 ms.
    function onKeyReleased(keyEvent as WatchUi.KeyEvent) as Boolean {
        if (keyEvent.getKey() == WatchUi.KEY_UP) {
            var elapsed = System.getTimer() - _upPressTime;
            _upPressTime = 0;
            if (elapsed >= 500) {
                BellView.playBellTone();
            }
            return true;
        }
        return false;
    }
}
