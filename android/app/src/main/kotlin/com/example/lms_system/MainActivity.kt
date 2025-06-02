package com.exceletacademy.lms

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    private val ROOT_CHECK_CHANNEL = "com.exceletacademy.lms/root_check"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // prevent screenshots and screen records
       // window.setFlags(
        //    WindowManager.LayoutParams.FLAG_SECURE,
          //  WindowManager.LayoutParams.FLAG_SECURE
       // )
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ROOT_CHECK_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "isDeviceRooted") {
                result.success(isRooted())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isRooted(): Boolean {
        val paths = arrayOf(
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su"
        )
        for (path in paths) {
            if (File(path).exists()) {
                return true
            }
        }
        return false
    }
}
