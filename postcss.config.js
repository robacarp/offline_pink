const tailwindcss = require('tailwindcss');

const plugins = [ tailwindcss ];

if (false) {
  // https://dzone.com/articles/how-to-setup-tailwind-css-with-parcel-bundler
  const purgecss = require('@fulhuman/postcss-purgecss');
  class TailwindExtractor {
    static extract(content) {
      return content.match(/[A-z0-9-:\/]+/g) || [];
    }
  }

  plugins.push(
    purgecss({
      content: ['src/*.html'],
      extractors: [
        {
          extractor: TailwindExtractor,
          extensions: ['html']
        }
      ]
    })
  );
}

module.exports = {
  plugins: [tailwindcss]
}
