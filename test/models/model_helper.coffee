db = require '../../models/db'

beforeEach (done)->
	db.setup done
