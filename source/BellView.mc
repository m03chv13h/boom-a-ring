import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! View that displays "BELL" and plays a tone on load.
class BellView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    //! Load resources when the view becomes visible.
    function onShow() as Void {
        playBellTone();
    }

    //! Draw the BELL label centred on screen.
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
            "BELL",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    //! Play a bell-like tone using the best available API.
    static function playBellTone() as Void {
        if (Attention has :playTone) {
            if (Attention has :ToneProfile) {
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
            } else {
                Attention.playTone(Attention.TONE_LOUD_BEEP);
            }
        }
    }
}
