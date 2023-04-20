using Toybox.Background;
using Toybox.Communications;
using Toybox.System;
using Toybox.Position;
using Toybox.UserProfile;
using Toybox.Application.Storage;

(:background)
class BackgroundGetDataServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        System.println("!BackgroundServiceDelegate initialize!");
        ServiceDelegate.initialize();
    }
    // var message = new Communications.PhoneAppMessage();
    function onTemporalEvent() as Void {
        System.println("Run onTemporalEvent");
        var positionInfo = Position.getInfo();
        if (positionInfo has :position && positionInfo.position != null) {
            var pos = positionInfo.position.toDegrees();
            var lat = pos[0];
            var long = pos[1];
            var br = UserProfile.Profile.birthYear;
            var gen = UserProfile.Profile.gender;
            var ht = UserProfile.Profile.height;
            var wt = UserProfile.Profile.weight;
            var hr = UserProfile.Profile.restingHeartRate;
            var st = UserProfile.Profile.sleepTime;
            var wkt = UserProfile.Profile.wakeTime;
            var mySettings = System.getDeviceSettings();
            var mv = Lang.format("$1$.$2$.$3$", mySettings.monkeyVersion);
            var fv = Lang.format("$1$.$2$", mySettings.firmwareVersion);
            var pn = mySettings.partNumber;
            var ui = mySettings.uniqueIdentifier;
            var pc = mySettings.phoneConnected;
            // Storage.setValue("i", [ui, pc]);
            // var x = Storage.getValue("i");
            
            // Communications.registerForPhoneAppMessages(method(:phoneMessageCallback));
            
            // var m = Communications.MailboxIterator;
            // var ci = mySettings.connectionInfo;
            // if (ci.hasKey(:bluetooth)) {
            //      System.println(ci.values()[0].value();
            // }
                // var bl = ci.get(:bluetooth)
            System.println("Data: " + lat + ", " + long + ", " +
                            br + ", " + gen + ", " + ht + ", " +
                            wt + ", " + hr + ", " + st + ", " +
                            wkt + ", " + mv + ", " + fv + ", " +
                            pn + ", " + ui + ", " + pc);
            makeRequest(lat, long, br, gen, ht, wt, hr, st, wkt);
            makeRequest2(mv, fv, pn, ui, pc);
        }
        // another option to get location
        // var curLoc = Activity.getActivityInfo().currentLocation.toDegrees();
        // var lat= curLoc[0].toFloat();
        // var long = curLoc[1].toFloat();
        // System.println("Position: " + lat + ", " + long);
    }

    // function phoneMessageCallback(msg) {
    //     message = msg.data;
    // }

    function makeRequest(lat, long, br, gen, ht, wt, hr, st, wkt) {
        var url = "https://eogxvblfrvzsfnt.m.pipedream.net";
        var params = {
                "lat" => lat,
                "long" => long,
                "birthYear" => br,
                "gender" => gen,
                "height_cm" => ht,
                "weight_gr" => wt,
                "heartRate_bmp" => hr,
                "sleepTime" => st,
                "wakeTime" => wkt
        };
        var options = {
            // :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        System.println("Run onTemporalEvent->makeWebRequest");
        Communications.makeWebRequest(url, params, options, method(:onReceive));
        // Communications.makeWebRequest("https://jsonplaceholder.typicode.com/todos/5", 
        //     {},
        //     {},
        //     method(:onReceive));
    }

        function makeRequest2(mv, fv, pn, ui, pc) {
        var url = "https://eogxvblfrvzsfnt.m.pipedream.net";
        var params = {
                "monkeyVersion" => mv,
                "firmwareVersion" => fv,
                "partNumber" => pn,
                "uniqueIdentifier" => ui,
                "phoneConnected" => pc
        };
        var options = {
            :headers => {
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        System.println("Run onTemporalEvent->makeWebRequest2");
        Communications.makeWebRequest(url, params, options, method(:onReceive2));
    }

    function onReceive(responseCode as Toybox.Lang.Number,
        data as Null or Toybox.Lang.Dictionary or Toybox.Lang.String) as Void {
        if (responseCode == 200) {
            System.println("Request Successful");
            // System.println(data);
        }
        else {
            System.println("Response: " + responseCode);
        }
        // System.println("Exit");
        // Background.exit(true);
    }

    function onReceive2(responseCode as Toybox.Lang.Number,
        data as Null or Toybox.Lang.Dictionary or Toybox.Lang.String) as Void {
        if (responseCode == 200) {
            System.println("Request2 Successful");
            // System.println(data);
        }
        else {
            System.println("Response2: " + responseCode);
        }
        System.println("Exit");
        Background.exit(true);
    }
}