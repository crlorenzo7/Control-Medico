package com.control_medico3;

import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.util.Log;


public class AlarmReceiver  extends BroadcastReceiver{


    @TargetApi(Build.VERSION_CODES.O)
    @Override
    public void onReceive(Context context, Intent intent) {

        Log.e("We are in the receiver.", "Yay!");

        // fetch extra strings from the intent
        // tells the app whether the user pressed the alarm on button or the alarm off button
        String title = intent.getExtras().getString("title");
        int type=intent.getExtras().getInt("type");
        Log.e("What is the key? ", title);

        // fetch the extra longs from the intent
        // tells the app which value the user picked from the drop down menu/spinner
        //Integer get_your_whale_choice = intent.getExtras().getInt("whale_choice");

        //Log.e("The whale choice is ", get_your_whale_choice.toString());

        // create an intent to the ringtone service
        Intent service_intent = new Intent(context, RingtonePlayingService.class);

        // pass the extra string from Receiver to the Ringtone Playing Service
        service_intent.putExtra("title", title);
        service_intent.putExtra("type",type);
        if(type==1){
            service_intent.putExtra("rem_position",intent.getExtras().getInt("rem_position"));
            service_intent.putExtra("original_time",intent.getExtras().getLong("original_time"));
            service_intent.putExtra("id",intent.getExtras().getInt("id"));
        }
        // pass the extra integer from the Receiver to the Ringtone Playing Service
        //service_intent.putExtra("whale_choice", get_your_whale_choice);

        // start the ringtone service
        //context.startForegService(service_intent);
        context.startForegroundService(service_intent);

    }

}