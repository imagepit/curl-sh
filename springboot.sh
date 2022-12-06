sudo apt update && sudo apt install -y zip unzip openjdk-17-jdk
curl -s "https://get.sdkman.io" | bash
echo ". $HOME/.sdkman/bin/sdkman-init.sh; sdk install springboot" | bash
sdk install springboot
