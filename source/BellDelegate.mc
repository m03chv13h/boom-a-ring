import Toybox.WatchUi;

//! Input delegate that replays the bell tone on any key press.
class BellDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the select / enter key.
    function onSelect() as Boolean {
        BellView.playBellTone();
        return true;
    }

    //! Handle any generic key event as a fallback.
    function onKey(keyEvent as WatchUi.KeyEvent) as Boolean {
        BellView.playBellTone();
        return true;
    }
}
