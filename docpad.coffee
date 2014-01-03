# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
	# ...
	port: process.env.PORT|81

	plugins:
		repocloner:
			repos: [
				name: 'BoundStar Content'
				path: 'src/documents'
				branch: 'master'
				url: 'https://github.com/digitaldesigndj/boundstar-content'
			]

	# DocPad Events
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server,express} = opts
			docpad = @docpad
			request = require('request')

			# DocPad Regenerate Hook
			# Automatically regenerate when new changes are pushed to our documentation
			server.all '/regenerate', (req,res) ->
				if req.query?.key is process.env.WEBHOOK_KEY
					docpad.log('info', 'Regenerating for documentation change')
					docpad.action('generate')
					res.send(200, 'regenerated')
				else
					res.send(400, 'key is incorrect')
}

# Export the DocPad Configuration
module.exports = docpadConfig
