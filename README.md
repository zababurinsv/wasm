# FS

docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) emscripten/emsdk emcc -Os --bind ./main.c -o ./dist/main.mjs \