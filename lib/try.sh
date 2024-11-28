mkdir src core
cd src
for w in auth home courses shared_course profile saved menu subscription exams  
do
  mkdir $w && cd $w
  mkdir data_source repository provider model presentation
  touch "data_source/${w}_data_source.dart"
  touch "repository/${w}_repository.dart"
  touch "provider/${w}_provider.dart"
  touch "model/${w}_model.dart"
  mkdir presentation/screens presentation/widgets
  touch "presentation/screens/${w}_screen.dart"
  cd ..
done
cd ../core
mkdir common_widgets constants utils
touch app_router.dart 
