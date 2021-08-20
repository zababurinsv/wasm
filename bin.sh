#!/bin/bash

od \
--output-duplicates \
--address-radix=n \
--width=1 \
--format=u1 ./dist/main.wasm | tr '\n' ',' > ./mjs/wasm

cat ./mjs/start ./mjs/wasm ./mjs/end > ./dist/wasmBinary.mjs
