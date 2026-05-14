import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! Edge Bell application entry point.
class BellApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    //! Return the initial view and its delegate.
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new BellView(), new BellDelegate()];
    }
}
