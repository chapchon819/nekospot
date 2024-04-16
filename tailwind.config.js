module.exports = {
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
          "secondary": "#FF8BA7",
          "accent": "#C3F0CA",
          "neutral": "#594A4E",
        },
      },
    ],
  },
}
