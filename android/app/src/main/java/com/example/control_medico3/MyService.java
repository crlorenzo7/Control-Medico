  
package com.example.control_medico3;

import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Build;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

public class MyService extends Service {

    MediaPlayer media_song;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        media_song = MediaPlayer.create(this, R.raw.gallop);
        media_song.start();
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"messages")
                .setContentText(intent.getExtras().getString("extra"))
                .setContentTitle("Flutter Background")
                .setSmallIcon(R.drawable.ic_launcher)
                .setPriority(NotificationCompat.PRIORITY_HIGH);

        startForeground(101,builder.build());


        return START_STICKY;
    }


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}