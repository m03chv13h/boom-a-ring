import Toybox.Activity;
import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

//! Data field that displays "BELL" and plays a tone continuously while
//! active.  On touch devices (Edge 1040) ringing starts on touch-hold and
//! stops when the finger is lifted.  On button devices (Edge 530) the bell
//! rings automatically while the data field is visible and stops when it is
//! hidden (no button input required).
class BellDataField extends WatchUi.DataField {

    //! Whether the bell is currently ringing repeatedly.
    private var _ringing as Boolean = false;

    //! Timer used to repeat the tone while ringing.
    private var _timer as Timer.Timer or Null;

    function initialize() {
        DataField.initialize();
    }

    //! Start ringing when the data field becomes visible (Edge 530 auto-ring).
    //! On touch devices the delegate handles start/stop via touch events.
    function onShow() as Void {
        startRinging();
    }

    //! Stop ringing when the data field is hidden (user navigated away).
    function onHide() as Void {
        stopRinging();
    }

    //! No activity data is needed – this field is purely a bell trigger.
    function compute(info as Activity.Info) as Void {
    }

    //! Play the bell tone when the user presses the lap button.
    //! On Edge 530 (non-touch), key events are not routed to data-field
    //! delegates, so we use onTimerLap() as the trigger for the bell.
    function onTimerLap() as Void {
        playBellTone();
    }

    //! Draw the [bell] label centred on the data-field area.
    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var w = dc.getWidth();
        var h = dc.getHeight();

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            w / 2,
            h / 2,
            Graphics.FONT_LARGE,
            "[bell]",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    //! Returns true if the bell is currently ringing.
    function isRinging() as Boolean {
        return _ringing;
    }

    //! Begin repeating the bell tone.
    function startRinging() as Void {
        if (!_ringing) {
            _ringing = true;
            playBellTone();
            _timer = new Timer.Timer();
            _timer.start(method(:onRingTimer), 500, true);
        }
    }

    //! Stop repeating the bell tone.
    function stopRinging() as Void {
        _ringing = false;
        if (_timer != null) {
            _timer.stop();
            _timer = null;
        }
    }

    //! Timer callback – play another tone if still ringing.
    function onRingTimer() as Void {
        if (_ringing) {
            playBellTone();
        }
    }

    //! Play a bell-like tone using the best available API.
    static function playBellTone() as Void {
        if (Attention has :playTone) {
            if (Attention has :ToneProfile) {
                try {
                    // Bike-bell "tring-tring" pattern: two rapid strikes
                    // with a slight downward frequency sweep to mimic the
                    // resonant decay of a metal dome being struck.
                    var tones = [
                        // First "tring"
                        new Attention.ToneProfile(3200, 80),
                        new Attention.ToneProfile(2800, 60),
                        new Attention.ToneProfile(2500, 40),
                        // Pause between strikes
                        new Attention.ToneProfile(0, 120),
                        // Second "tring"
                        new Attention.ToneProfile(3200, 80),
                        new Attention.ToneProfile(2800, 60),
                        new Attention.ToneProfile(2500, 40),
                    ] as Array<Attention.ToneProfile>;
                    Attention.playTone({:toneProfile => tones});
                    return;
                } catch (e instanceof Lang.Exception) {
                    // ToneProfile not supported at runtime – fall through.
                }
            }
            try {
                Attention.playTone(Attention.TONE_LOUD_BEEP);
            } catch (e instanceof Lang.Exception) {
                // Tone not supported on this device – silently ignore.
            }
        }
    }
}
