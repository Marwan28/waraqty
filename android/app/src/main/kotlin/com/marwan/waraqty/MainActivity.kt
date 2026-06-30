package com.marwan.waraqty

import android.Manifest
import android.content.ContentValues
import android.content.pm.PackageManager
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private data class PendingSave(
        val bytes: ByteArray,
        val fileName: String,
        val relativePath: String,
        val result: MethodChannel.Result,
    )

    private var pendingSave: PendingSave? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PDF_STORAGE_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "savePdf" -> handleSavePdf(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun handleSavePdf(call: MethodCall, result: MethodChannel.Result) {
        val bytes = call.argument<ByteArray>("bytes")
        val fileName = call.argument<String>("fileName")
        val relativePath = call.argument<String>("relativePath")

        if (bytes == null || fileName.isNullOrBlank() || relativePath.isNullOrBlank()) {
            result.error("invalid_arguments", "Missing PDF bytes, file name, or path.", null)
            return
        }

        val save = PendingSave(
            bytes = bytes,
            fileName = sanitizeSegment(fileName),
            relativePath = sanitizeRelativePath(relativePath),
            result = result,
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            saveWithMediaStore(save)
            return
        }

        if (
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            saveLegacy(save)
            return
        }

        pendingSave = save
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
            WRITE_STORAGE_REQUEST_CODE,
        )
    }

    private fun saveWithMediaStore(save: PendingSave) {
        val resolver = applicationContext.contentResolver
        val downloadPath = "${Environment.DIRECTORY_DOWNLOADS}/${save.relativePath}"
        val values = ContentValues().apply {
            put(MediaStore.Downloads.DISPLAY_NAME, save.fileName)
            put(MediaStore.Downloads.MIME_TYPE, PDF_MIME_TYPE)
            put(MediaStore.Downloads.RELATIVE_PATH, downloadPath)
            put(MediaStore.Downloads.IS_PENDING, 1)
        }

        var uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
        if (uri == null) {
            save.result.error("create_failed", "Could not create the PDF file.", null)
            return
        }

        try {
            resolver.openOutputStream(uri)?.use { stream ->
                stream.write(save.bytes)
                stream.flush()
            } ?: throw IllegalStateException("Could not open the PDF output stream.")

            values.clear()
            values.put(MediaStore.Downloads.IS_PENDING, 0)
            resolver.update(uri, values, null, null)

            save.result.success(
                mapOf(
                    "displayPath" to "Downloads/${save.relativePath}/${save.fileName}",
                    "uri" to uri.toString(),
                ),
            )
        } catch (error: Exception) {
            resolver.delete(uri, null, null)
            save.result.error("save_failed", error.message, null)
        }
    }

    @Suppress("DEPRECATION")
    private fun saveLegacy(save: PendingSave) {
        try {
            val downloads = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS,
            )
            val directory = File(downloads, save.relativePath)
            if (!directory.exists() && !directory.mkdirs()) {
                throw IllegalStateException("Could not create the destination folder.")
            }

            val outputFile = File(directory, save.fileName)
            FileOutputStream(outputFile).use { stream ->
                stream.write(save.bytes)
                stream.flush()
            }

            save.result.success(
                mapOf(
                    "displayPath" to "Downloads/${save.relativePath}/${save.fileName}",
                    "uri" to outputFile.toURI().toString(),
                ),
            )
        } catch (error: Exception) {
            save.result.error("save_failed", error.message, null)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != WRITE_STORAGE_REQUEST_CODE) return

        val save = pendingSave ?: return
        pendingSave = null

        if (
            grantResults.isNotEmpty() &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED
        ) {
            saveLegacy(save)
        } else {
            save.result.error(
                "permission_denied",
                "Storage permission was denied.",
                null,
            )
        }
    }

    private fun sanitizeRelativePath(value: String): String {
        return value
            .split("/")
            .filter { it.isNotBlank() }
            .joinToString("/") { sanitizeSegment(it) }
    }

    private fun sanitizeSegment(value: String): String {
        return value.replace(Regex("[\\\\:*?\"<>|]"), "_").trim()
    }

    companion object {
        private const val PDF_STORAGE_CHANNEL = "com.marwan.waraqty/pdf_storage"
        private const val PDF_MIME_TYPE = "application/pdf"
        private const val WRITE_STORAGE_REQUEST_CODE = 721
    }
}
