module.exports = {
  theme: {
    extend: {
      fontFamily: {
        'zenmaru': ['Zen Maru Gothic', 'sans-serif'],
        'sans': ['Noto Sans JS', 'sans-serif'],
      }
    },
  },
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require('daisyui')
  ],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#FAEEE7",
          "secondary": "#837176",
          "accent": "#ff8ba7",
          "neutral": "#594A4E",
          "info": "#ffc6c7",
        },
      },
    ],
  },
}
