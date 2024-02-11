echo enable-ssh-support >> ~/.gnupg/gpg-agent.conf
echo 9AA3054F8732794A8B33510B5B9E5F9D7211E7B1 >> ~/.gnupg/sshcontrol
git config --global user.name "Marcos Magueta"
git config --global user.signingkey CE25E21959B460A84BDFB93F0AD3A1263F9DE73E
git config --global commit.gpgsign true
git config --global user.email "maguetamarcos@gmail.com"
