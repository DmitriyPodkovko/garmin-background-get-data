import Toybox.Application;
import Toybox.WatchUi;


(:background)
class BackgroundGetDataApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        // var targetApp = new Toybox.System.Intent(
        //     "manifest-id://376ad127-8199-452a-92bb-1233db75d807" ,
        //     {"arg"=>"CurrentAppName"}
        //     );
        // System.exitTo(targetApp);
        // var thisComplication = new Complications.Id(Toybox.Complications.COMPLICATION_TYPE_STEPS);
        // System.exitTo(thisComplication);
        // // System.exitTo(Toybox.Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE);
        if(Toybox.System has :ServiceDelegate) {
            Background.registerForTemporalEvent(new Time.Duration(5 * 60));
        } else {
            System.println("****background not available on this device****");
        }
        return [ new BackgroundGetDataView()];
    }

    // This method runs each time the background process starts
    function getServiceDelegate() {
        return [new BackgroundGetDataServiceDelegate()];
    }

}

function getApp() as BackgroundGetDataApp {
    return Application.getApp() as BackgroundGetDataApp;
}