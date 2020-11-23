package com.sewerganger.liver3rd;

import androidx.annotation.NonNull;
// import com.umeng.analytics.MobclickAgent;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }

  @Override
  public void onResume() {
    super.onResume();
    // MobclickAgent.onResume(this);
  }

  @Override
  public void onPause() {
    super.onPause();
    // MobclickAgent.onPause(this);
  }
}
