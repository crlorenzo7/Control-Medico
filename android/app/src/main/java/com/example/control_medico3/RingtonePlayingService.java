package com.example.control_medico3;

import android.annotation.TargetApi;
import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.RingtoneManager;
import android.net.Uri;
import android.opengl.Visibility;
import android.os.Build;
import android.os.CountDownTimer;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.NotificationCompat;


public class RingtonePlayingService extends Service {

    MediaPlayer media_song;
    int startId;
    boolean isRunning;
    int state=0;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @androidx.annotation.RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i("LocalService", "Received start id " + startId + ": " + intent);

        if(intent!=null){
            if(intent.getExtras().get("state")!=null){
                int state=Integer.parseInt(intent.getExtras().get("state").toString());
                if(state==1){
                    //stopForeground(startId);
                    stopSelf();


                }
            }else{

                int type=intent.getExtras().getInt("type");

                Intent deleteIntent = new Intent(this, RingtonePlayingService.class);
                deleteIntent.putExtra("state", 1);
                PendingIntent deletePendingIntent = PendingIntent.getService(this,
                        0,
                        deleteIntent,
                        PendingIntent.FLAG_CANCEL_CURRENT);


                NotificationManager notify_manager = (NotificationManager) getSystemService(NotificationManager.class);

                Intent intent_main_activity = new Intent(this.getApplicationContext(), MainActivity.class);

                PendingIntent pending_intent_main_activity = PendingIntent.getActivity(this, 0,
                        intent_main_activity, 0);

                Uri notSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

                Intent intent1 = new Intent(this.getApplicationContext(), MainActivity.class);
                PendingIntent pIntent = PendingIntent.getActivity(this, 0, intent1, 0);



                String channelIdAlarm = "control_medico/alarmas";
                String channelIdReminder="control_medico/reminders";
                String nameChannelAlarm="alarmas";
                String nameChannelReminder="recordatorios";

                Uri sound=Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.gallop);

                String channelId=channelIdAlarm;
                String nameChannel=nameChannelAlarm;
                if(type==1){

                    channelId=channelIdReminder;
                    nameChannel=nameChannelReminder;
                }

                Notification.Builder builder = new Notification.Builder(this,channelId)
                        .setDefaults(Notification.DEFAULT_VIBRATE)
                        //.setContentText(intent.getExtras().getString("extra"))
                        .setContentTitle(intent.getExtras().getString("title"))
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setContentIntent(pIntent)
                        .addAction(R.drawable.ic_launcher,"DISMISS",deletePendingIntent)
                        .setAutoCancel(true)
                        .setPriority(Notification.PRIORITY_MAX)
                        .setVisibility(Notification.VISIBILITY_PUBLIC);
                if(type==1){
                    builder.setCategory(Notification.CATEGORY_REMINDER);

                }else{
                    builder.setOngoing(true).setCategory(Notification.CATEGORY_ALARM);
                }

                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                {
                    AudioAttributes audioAttributes = new AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .build();
                    AudioAttributes audioAttributes2 = new AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                            .build();

                    NotificationChannel channel = new NotificationChannel(
                            channelId,
                            nameChannel,
                            NotificationManager.IMPORTANCE_HIGH);
                    if(type==1){
                        channel.setSound(notSound, audioAttributes2);
                    }else {
                        channel.setSound(sound, audioAttributes);
                    }

                    notify_manager.createNotificationChannel(channel);
                    builder.setChannelId(channelId);
                }

                if(type==1){
                    int rem_pos=intent.getExtras().getInt("rem_position");
                    Long original_time=intent.getExtras().getLong("original_time");
                    int id=intent.getExtras().getInt("id");
                    if(rem_pos>0) {
                        Intent myIntent = new Intent(getApplicationContext(), AlarmReceiver.class);
                        AlarmManager alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);

                        myIntent.putExtra("title", intent.getExtras().getString("title"));
                        myIntent.putExtra("type", type);

                        myIntent.putExtra("rem_position", rem_pos - 1);
                        myIntent.putExtra("original_time", original_time);
                        myIntent.putExtra("id",id);
                        Long timeMili = original_time;
                        switch(rem_pos){
                            case 3:
                                timeMili-=(30*60000);
                                builder.setContentText("mañana");
                                break;
                            case 2:
                                timeMili-=(10*60000);
                                builder.setContentText("en 30 minutos");
                                break;
                            case 1:
                                builder.setContentText("en 10 minutos");
                                break;
                        }


                        PendingIntent pending_intent = PendingIntent.getBroadcast(getApplicationContext(), id, myIntent, PendingIntent.FLAG_UPDATE_CURRENT);

                        alarmManager.set(AlarmManager.RTC_WAKEUP, timeMili, pending_intent);
                    }else{
                        builder.setContentText("ahora");
                    }
                }

                startForeground(startId,builder.build());
            }
        }





        Log.e("MyActivity", "In the service");

        return START_NOT_STICKY;
    }



    @Override
    public void onDestroy() {
        // Tell the user we stopped.
        Log.e("on Destroy called", "ta da");

        super.onDestroy();
        this.isRunning = false;
    }



}