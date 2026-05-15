import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! Edge Bell data-field application entry point.
class BellApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    //! Return the data-field view and its input delegate.
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var dataField = new BellDataField();
        var delegate = new BellDelegate(dataField);
        return [dataField, delegate];
    }
}
