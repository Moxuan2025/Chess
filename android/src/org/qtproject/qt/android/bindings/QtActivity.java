package org.qtproject.qt.android.bindings;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.os.Bundle;
import android.util.Log;

public class QtActivity extends Activity {
    private static final String TAG = "QtActivity";
    private NfcAdapter mNfcAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNfcAdapter = NfcAdapter.getDefaultAdapter(this);
        if (mNfcAdapter == null) {
            Log.w(TAG, "Device does not support NFC");
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mNfcAdapter != null) {
            // 启用前台调度
            Intent intent = new Intent(this, getClass());
            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);

            PendingIntent pendingIntent = PendingIntent.getActivity(
                this, 0, intent, PendingIntent.FLAG_MUTABLE | PendingIntent.FLAG_UPDATE_CURRENT
            );

            // 添加所有支持的NFC类型
            String[][] techLists = new String[][] {
                {"android.nfc.tech.NfcA"},
                {"android.nfc.tech.NfcB"},
                {"android.nfc.tech.NfcF"},
                {"android.nfc.tech.NfcV"},
                {"android.nfc.tech.Ndef"},
                {"android.nfc.tech.NdefFormatable"},
                {"android.nfc.tech.IsoDep"},
                {"android.nfc.tech.MifareClassic"},
                {"android.nfc.tech.MifareUltralight"}
            };

            mNfcAdapter.enableForegroundDispatch(
                this,
                pendingIntent,
                null, // 接收所有NFC intent
                techLists
            );
            Log.d(TAG, "NFC foreground dispatch enabled");
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mNfcAdapter != null) {
            // 禁用前台调度
            mNfcAdapter.disableForegroundDispatch(this);
            Log.d(TAG, "NFC foreground dispatch disabled");
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Log.d(TAG, "Received NFC intent: " + intent.getAction());

        // 检查NFC意图
        if (NfcAdapter.ACTION_TAG_DISCOVERED.equals(intent.getAction()) ||
            NfcAdapter.ACTION_TECH_DISCOVERED.equals(intent.getAction()) ||
            NfcAdapter.ACTION_NDEF_DISCOVERED.equals(intent.getAction())) {

            // 获取标签对象
            Tag tag = intent.getParcelableExtra(NfcAdapter.EXTRA_TAG);
            if (tag != null) {
                Log.d(TAG, "NFC tag detected: " + tag.toString());

                // 通知Qt层NFC事件发生
                QtNative.runOnQtThread(() -> {
                    QtNative.callStaticMethod(
                        "org/qtproject/example/appChess/NfcHandler",
                        "onNfcTagDetected"
                    );
                });
            }
        }
    }
}
