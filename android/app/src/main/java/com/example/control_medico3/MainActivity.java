package com.example.control_medico3;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.app.AlarmManager;
import android.app.PendingIntent;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;




public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }

  AlarmManager alarmManager;
  private PendingIntent pending_intent;
  private AlarmReceiver alarm;

  Context context;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    //GeneratedPluginRegistrant.registerWith(this);
    this.context = getApplicationContext();
    final Intent myIntent = new Intent(this.context, AlarmReceiver.class);
    alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
    

    new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),"com.example.control_medico3.messages")
            .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @TargetApi(Build.VERSION_CODES.O)
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        Log.e("MY_RECEIVER ", "on method call");

        if(methodCall.method.equals("scheduleAlarm")){
          Map<String,Object> arg=new HashMap<String,Object>();
          arg=methodCall.argument("event");

          myIntent.putExtra("title", arg.get("title").toString() );
          int timeMili=Integer.parseInt(arg.get("time").toString())*1000;
          int id=Integer.parseInt(arg.get("id").toString());
          pending_intent = PendingIntent.getBroadcast(MainActivity.this, id, myIntent, PendingIntent.FLAG_UPDATE_CURRENT);

          alarmManager.set(AlarmManager.RTC_WAKEUP, timeMili, pending_intent);
          result.success("alarm created");
        }

        if(methodCall.method.equals("cancelAlarm")){

          int arg=methodCall.argument("id");

          pending_intent = PendingIntent.getBroadcast(MainActivity.this, arg, myIntent, PendingIntent.FLAG_UPDATE_CURRENT);

          alarmManager.cancel(pending_intent);
          result.success("alarm deleted");
        }
      }


    });


  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
    //stopService(forService);
  }

  /*@TargetApi(Build.VERSION_CODES.O)
  private void startService(){
    /*if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
      startForegroundService(forService);
    } else {
      startService(forService);
    }*/
    /*startService(forService.putExtra("extra","hola"));
  }*/

}
