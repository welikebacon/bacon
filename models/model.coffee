class Model
	
	@fromJSON: (json)->
		@fromData JSON.parse json
	@fromData: (data)->

	toJSON: ->
		JSON.stringify data
	toData: ->
		{}


module.exports = 
	Model: Model