import Toybox.Lang;
import Toybox.System;
import Toybox.Timer;
import Toybox.WatchUi;

//! Input delegate for the bell data field.
//!
//! Touch devices (Edge 1040): ringing starts on hold and stops on release.
//! Button devices (Edge 530): ringing starts after the up button has been
//! held for 500 ms and stops when the button is released.
class BellDelegate extends WatchUi.BehaviorDelegate {

    //! Reference to the data field so we can start / stop ringing.
    private var _dataField as BellDataField;

    //! Timestamp (ms) when the up button was last pressed down.
    private var _upPressTime as Number = 0;

    //! Whether the up-button hold threshold has been reached.
    private var _upHeld as Boolean = false;

    //! One-shot timer to detect the 500 ms hold threshold.
    private var _holdTimer as Timer.Timer or Null;

    function initialize(dataField as BellDataField) {
        BehaviorDelegate.initialize();
        _dataField = dataField;
    }

    // ── Touch input (Edge 1040) ──────────────────────────────────

    //! Start ringing when the user holds on the touch screen.
    function onHold(clickEvent as WatchUi.ClickEvent) as Boolean {
        _dataField.startRinging();
        return true;
    }

    //! Stop ringing when the user lifts the finger.
    function onRelease(clickEvent as WatchUi.ClickEvent) as Boolean {
        _dataField.stopRinging();
        return true;
    }

    //! A quick tap plays a single tone.
    function onTap(clickEvent as WatchUi.ClickEvent) as Boolean {
        BellDataField.playBellTone();
        return true;
    }

    // ── Button input (Edge 530) ──────────────────────────────────

    //! Record the press time and start a 500 ms hold timer.
    function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Boolean {
        if (keyEvent.getKey() == WatchUi.KEY_UP) {
            _upPressTime = System.getTimer();
            _holdTimer = new Timer.Timer();
            _holdTimer.start(method(:onHoldTimeout), 500, false);
            return true;
        }
        return false;
    }

    //! Called by the hold timer – 500 ms elapsed, start ringing.
    function onHoldTimeout() as Void {
        _upHeld = true;
        _dataField.startRinging();
    }

    //! Stop ringing (or cancel the hold timer) when the button is released.
    function onKeyReleased(keyEvent as WatchUi.KeyEvent) as Boolean {
        if (keyEvent.getKey() == WatchUi.KEY_UP) {
            if (_holdTimer != null) {
                _holdTimer.stop();
                _holdTimer = null;
            }
            if (_upHeld) {
                _dataField.stopRinging();
                _upHeld = false;
            }
            _upPressTime = 0;
            return true;
        }
        return false;
    }
}
