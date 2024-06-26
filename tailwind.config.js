module.exports = {
  theme: {
    extend: {
      fontFamily: {
        'zenmaru': ['Zen Maru Gothic', 'sans-serif'],
        'sans': ['Noto Sans JS', 'sans-serif'],
      },
      colors: {
        'line-base': '#06C755',
        'line-hover': '#06B64E',
        'line-click': '#059540',
        'google-hover': '#F2F2F2',
        'google-text': '#1F1F1F',
        'accent-hover': '#FF7D6C',
        'accent-active': '#FFB9B0',
        'primary-hover': '#cbc2c5',
      },
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
          "accent": "#FF9B8E",
          "neutral": "#594A4E",
          "info": "#ffc6c7",
        },
      },
    ],
  },
}
