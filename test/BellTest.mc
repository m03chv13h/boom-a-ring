import Toybox.Lang;
import Toybox.Test;

//! Unit tests for the Edge Bell data-field bells functionality.
//!
//! These tests are compiled only when using the -t flag (test mode) and are
//! executed by the Connect IQ simulator / emulator.  They cover the ringing
//! state-machine and the Edge-530-specific auto-ring behaviour triggered via
//! onShow / onHide / onTimerLap.

//! Bell starts in the not-ringing state immediately after construction.
(:test)
function testInitialNotRinging(logger as Test.Logger) as Boolean {
    var field = new BellDataField();
    Test.assertMessage(!field.isRinging(), "Bell should not ring on construction");
    return true;
}

//! startRinging() transitions the field into the ringing state.
(:test)
function testStartRinging(logger as Test.Logger) as Boolean {
    var field = new BellDataField();
    field.startRinging();
    Test.assertMessage(field.isRinging(), "Bell should ring after startRinging()");
    field.stopRinging();
    return true;
}

//! stopRinging() transitions the field out of the ringing state.
(:test)
function testStopRinging(logger as Test.Logger) as Boolean {
    var field = new BellDataField();
    field.startRinging();
    field.stopRinging();
    Test.assertMessage(!field.isRinging(), "Bell should not ring after stopRinging()");
    return true;
}

//! Calling startRinging() while already ringing is a safe no-op.
(:test)
function testStartRingingIdempotent(logger as Test.Logger) as Boolean {
    var field = new BellDataField();
    field.startRinging();
    field.startRinging();   // second call must not change state or crash
    Test.assertMessage(field.isRinging(), "Bell should still be ringing");
    field.stopRinging();
    return true;
}

//! Calling stopRinging() when not ringing must not crash.
(:test)
function testStopWhenNotRinging(logger as Test.Logger) as Boolean {
    var field = new BellDataField();
    field.stopRinging();    // no-op – must not throw
    Test.assertMessage(!field.isRinging(), "Bell should remain not-ringing");
    return true;
}

//! onShow() starts auto-ring – models the Edge 530 behaviour where the bell
//! rings automatically as soon as the data field becomes visible.
(:test)
function testOnShowStartsRinging(logger as Test.Logger) as Boolean {
    var field = new BellDataField();
    field.onShow();
    Test.assertMessage(field.isRinging(), "onShow() should start ringing (Edge 530 auto-ring)");
    field.stopRinging();
    return true;
}

//! onHide() stops auto-ring – models the Edge 530 behaviour where the bell
//! stops when the user navigates away from the data field.
(:test)
function testOnHideStopsRinging(logger as Test.Logger) as Boolean {
    var field = new BellDataField();
    field.onShow();
    field.onHide();
    Test.assertMessage(!field.isRinging(), "onHide() should stop ringing (Edge 530 auto-ring)");
    return true;
}

//! playBellTone() must not throw even when Attention APIs are unavailable.
//! On Edge 530 the simulator may not play audio; the method must fail silently.
(:test)
function testPlayBellToneDoesNotThrow(logger as Test.Logger) as Boolean {
    try {
        BellDataField.playBellTone();
    } catch (e instanceof Lang.Exception) {
        Test.assertMessage(false, "playBellTone() must not throw: " + e.getErrorMessage());
        return false;
    }
    return true;
}

//! onTimerLap() triggers a single bell tone (lap-button press on Edge 530).
//! It must complete without throwing.
(:test)
function testOnTimerLapDoesNotThrow(logger as Test.Logger) as Boolean {
    var field = new BellDataField();
    try {
        field.onTimerLap();
    } catch (e instanceof Lang.Exception) {
        Test.assertMessage(false, "onTimerLap() must not throw: " + e.getErrorMessage());
        return false;
    }
    return true;
}
