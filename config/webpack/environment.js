const { environment, config } = require('@rails/webpacker')

const webpack = require('webpack')
const path = require('path')

// splitChunks
environment.splitChunks((config) => Object.assign({}, config, {
    optimization: {
	splitChunks: { name: 'vendor' }
    }
}))

// plugins
environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
}))

// resolve alis
aliasConfig = {
    resolve: {
	alias: {
	    '@js': path.resolve(__dirname, '..', '..', config.source_path,'javascripts'),
	    '@components': path.resolve(__dirname, '..', '..', config.source_path,'javascripts', 'components'),
	    '@css': path.resolve(__dirname, '..', '..', config.source_path, 'stylesheets')
	}
    }
}
environment.config.merge(aliasConfig)

module.exports = environment
