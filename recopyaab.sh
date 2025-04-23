rm ~/Desktop/excelet.apk
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/excelet.apk
rm ~/Desktop/excelet_app.aab
cp build/app/outputs/bundle/release/app-release.aab ~/Desktop/excelet_app.aab
rm -rf ~/Desktop/symbols
cp -r build/app/intermediates/merged_native_libs/release/out/lib ~/Desktop/symbols;
