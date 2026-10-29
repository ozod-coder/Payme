# Pay Demo — Flutter Android app

This is an independent demo app. It does not connect to Payme or any bank.
Transfers only change a virtual in-app balance and are labeled DEMO.

## Build an APK using GitHub Actions (no Flutter installation needed on your computer)

1. Download and extract this ZIP.
2. Sign in to GitHub and create a **new empty repository** (for example, `pay-demo`).
3. Upload the extracted project files and folders to that repository. Make sure `.github/workflows/build-apk.yml` is included.
4. Open the repository's **Actions** tab and select **Build Android APK**. If prompted, enable Actions.
5. Push/commit the files to the `main` branch, or choose **Run workflow**.
6. When the run finishes successfully, open that run and download the `pay-demo-apk` artifact.
7. Extract the downloaded artifact ZIP; it contains `app-release.apk`. Transfer it to your Android phone and install it.

## Build locally instead

With Flutter SDK and Android SDK installed, run:

    flutter create --platforms=android .
    flutter pub get
    flutter build apk --release

The APK will be at:

    build/app/outputs/flutter-apk/app-release.apk

## Demo limitations

- No real money is transferred.
- The balance and transfer history are currently in-memory demo data and reset when the app is restarted.
- Use only fictional card details.
