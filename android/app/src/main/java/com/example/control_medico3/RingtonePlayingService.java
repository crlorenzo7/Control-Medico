package com.example.control_medico3;

import android.annotation.TargetApi;
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

        // fetch the extra string from the alarm on/alarm off values
        //String state = intent.getExtras().getString("extra");
        // fetch the whale choice integer values
        //Integer whale_sound_choice = intent.getExtras().getInt("whale_choice");

        //Log.e("Ringtone extra is ", state);
        //Log.e("Whale choice is ", whale_sound_choice.toString());

        // put the notification here, test it out
        if(intent!=null){
            if(intent.getExtras().get("state")!=null){
                int state=Integer.parseInt(intent.getExtras().get("state").toString());
                if(state==1){
                    //stopForeground(startId);
                    stopSelf();


                }
            }else{
                Intent deleteIntent = new Intent(this, RingtonePlayingService.class);
                deleteIntent.putExtra("state", 1);
                PendingIntent deletePendingIntent = PendingIntent.getService(this,
                        0,
                        deleteIntent,
                        PendingIntent.FLAG_CANCEL_CURRENT);

                // notification
                // set up the notification service
                NotificationManager notify_manager = (NotificationManager) getSystemService(NotificationManager.class);
                // set up an intent that goes to the Main Activity
                Intent intent_main_activity = new Intent(this.getApplicationContext(), MainActivity.class);
                // set up a pending intent
                PendingIntent pending_intent_main_activity = PendingIntent.getActivity(this, 0,
                        intent_main_activity, 0);

                Uri alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM);
                // make the notification parameters
                Intent intent1 = new Intent(this.getApplicationContext(), MainActivity.class);
                PendingIntent pIntent = PendingIntent.getActivity(this, 0, intent1, 0);

                Uri ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
                String channelId = "message18";
                Uri sound=Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.gallop);
                Notification mNotification;


                Notification.Builder builder = new Notification.Builder(this,channelId)
                        .setDefaults(Notification.DEFAULT_VIBRATE)
                        //.setContentText(intent.getExtras().getString("extra"))
                        .setContentTitle(intent.getExtras().getString("title"))
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setContentIntent(pIntent)
                        .setOngoing(true)
                        .addAction(R.drawable.ic_launcher,"DISMISS",deletePendingIntent)
                        .setAutoCancel(true)
                        .setPriority(Notification.PRIORITY_MAX)
                        .setCategory(Notification.CATEGORY_ALARM)
                        .setVisibility(Notification.VISIBILITY_PUBLIC);

                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                {
                    AudioAttributes audioAttributes = new AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .build();
                    NotificationChannel channel = new NotificationChannel(
                            channelId,
                            "messages17",
                            NotificationManager.IMPORTANCE_HIGH);

                    channel.setSound(sound, audioAttributes);

                    notify_manager.createNotificationChannel(channel);
                    builder.setChannelId(channelId);
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