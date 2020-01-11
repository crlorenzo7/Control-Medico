package com.control_medico3;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.androidalarmmanager.AlarmService;
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;

public class Application extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
      super.onCreate();
      AlarmService.setPluginRegistrant(this);
    }
  
    @Override
    public void registerWith(PluginRegistry registry) {
        if(registry!=null){
            AndroidAlarmManagerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"));
        }
        
    }
  }