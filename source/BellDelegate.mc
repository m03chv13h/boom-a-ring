import Toybox.Lang;
import Toybox.WatchUi;

//! Input delegate for the bell data field.
//!
//! Handles touch input for Edge 1040: ringing starts on hold and stops on
//! release.  Edge 530 requires no button input – automatic ringing on
//! show/hide is managed by BellDataField itself.
class BellDelegate extends WatchUi.BehaviorDelegate {

    //! Reference to the data field so we can start / stop ringing.
    private var _dataField as BellDataField;

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
}
