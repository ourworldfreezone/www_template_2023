# builds if executable isn't found
if [[ ! -f "tailwindcss" ]]; then
    sh build.sh
fi

# initializes and configures tailwind if not configured
if [[ ! -f "tailwind.config.js" ]]; then
    ./tailwindcss init
    sed -i '' "s|  content: \\[\\],|  content: \\['./templates/**/*.html'\\],|g" tailwind.config.js
fi

# compiles Tailwind CSS & launches locally
rm -rf public static/css
./tailwindcss -i css/index.css -o ./static/css/index.css --watch & zola serve &

# wait for the local preview to start
sleep 5

# open the local preview in the default web browser
open "http://127.0.0.1:1111"

# compiles Tailwind CSS for production & builds project
./tailwindcss -i css/index.css -o ./static/css/index.css --minify
zola build

# kill zola and Tailwind CSS background processes on interrupt
trap 'kill $(jobs -p); exit 1' INT
wait
