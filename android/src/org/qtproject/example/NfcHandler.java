package org.qtproject.example.appChess;

import org.qtproject.qt.android.QtNative;

public class NfcHandler {
    private static long lastTagTime = 0;
    private static final long DEBOUNCE_TIME = 500; // 500ms防抖

    public static void onNfcTagDetected() {
        // 防抖处理
        long currentTime = System.currentTimeMillis();
        if (currentTime - lastTagTime < DEBOUNCE_TIME) {
            return;
        }
        lastTagTime = currentTime;

        // 通知Qt层NFC标签已检测到
        if (QtNative.isQtApplicationLoaded()) {
            QtNative.runOnQtThread(() -> {
                // 调用QML中的处理函数
                QtNative.invokeQtMethod(
                    "onNfcTagDetected"
                );
            });
        }
    }
}
