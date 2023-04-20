const path = require('path');
const ESLintPlugin = require('eslint-webpack-plugin');

module.exports = function override(config, env) {
  if (env === 'development') {
    config.devtool = false;

    // Agrega el plugin eslint-webpack-plugin
    config.plugins.push(
      new ESLintPlugin({
        context: path.resolve(__dirname, 'src'),
        files: ['**/*.(js|jsx|mjs)'],
        exclude: ['node_modules'],
        formatter: require('react-dev-utils/eslintFormatter'),
        failOnError: false,
        emitWarning: true,
        quiet: true,
      })
    );

    // Excluir archivos de node_modules del source-map-loader
    config.module.rules.push({
      test: /\.(js|jsx|mjs)$/,
      enforce: 'pre',
      use: ['source-map-loader'],
      exclude: /node_modules/,
    });

    // Configurar el rendimiento y las advertencias
    config.performance = {
      hints: process.env.NODE_ENV === 'production' ? 'warning' : false,
      maxAssetSize: 1000000,
      maxEntrypointSize: 1000000,
    };
  }

  return config;
};
