# build.sh will (should) work on any machine that has Docker installed. This file requires npm, lessc, elm and probably some other stuff I've forgotten.
set -e
mkdir -p out
lessc style.less > out/style.css
cp index.html out
cp -R icons out
elm make Main.elm --output out/paperclips.js
