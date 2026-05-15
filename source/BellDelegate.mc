import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

//! Input delegate for the bell data field.
//!
//! Handles touch input for Edge 1040: ringing starts on hold and stops on
//! release.  Edge 530 requires no button input – automatic ringing on
//! show/hide is managed by BellDataField itself.
//!
//! Additionally, on any device with a laps button (KEY_ENTER), a long press
//! (500 ms) starts ringing continuously until the button is released.
class BellDelegate extends WatchUi.BehaviorDelegate {

    //! Reference to the data field so we can start / stop ringing.
    private var _dataField as BellDataField;

    //! Timer used to detect a 500 ms long-press on the laps button.
    private var _longPressTimer as Timer.Timer or Null;

    //! Whether we triggered ringing via a long-press (to know if we should
    //! stop on release).
    private var _longPressActive as Boolean = false;

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

    // ── Laps button long-press ───────────────────────────────────

    //! Start a 500 ms timer when the laps button (KEY_ENTER) is pressed.
    function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Boolean {
        if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            _cancelLongPressTimer();
            _longPressTimer = new Timer.Timer();
            _longPressTimer.start(method(:onLongPressTimer), 500, false);
            return true;
        }
        return false;
    }

    //! Stop ringing and cancel the timer when the laps button is released.
    function onKeyReleased(keyEvent as WatchUi.KeyEvent) as Boolean {
        if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            _cancelLongPressTimer();
            if (_longPressActive) {
                _longPressActive = false;
                _dataField.stopRinging();
            }
            return true;
        }
        return false;
    }

    //! Timer callback – 500 ms elapsed, begin ringing.
    function onLongPressTimer() as Void {
        _longPressActive = true;
        _dataField.startRinging();
    }

    //! Cancel the pending long-press timer if it hasn't fired yet.
    private function _cancelLongPressTimer() as Void {
        if (_longPressTimer != null) {
            _longPressTimer.stop();
            _longPressTimer = null;
        }
    }
}
