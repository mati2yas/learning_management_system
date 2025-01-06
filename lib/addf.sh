w="notification"
cd src
  mkdir $w && cd $w
  #mkdir data_source repository provider model presentation
  mkdir provider model presentation
  #touch "data_source/${w}_data_source.dart"
  #touch "repository/${w}_repository.dart"
  touch "provider/${w}_provider.dart"
  touch "model/${w}_model.dart"
  mkdir presentation/screens presentation/widgets
  touch "presentation/screens/${w}_screen.dart"
  cd ..
