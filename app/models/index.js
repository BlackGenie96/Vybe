const dbConfig = require("../config/db.config");

const mongoose = require("mongoose");
const bodyParser = require("body-parser");
mongoose.Promise = global.Promise;

const db = {};
db.mongoose = mongoose;
db.url = dbConfig.url;
db.tutorials = require("./tutorial.models")(mongoose);
db.categories = require("./category.models")(mongoose);
db.users = require("./user.models")(mongoose);
db.managers = require("./manager.models")(mongoose);
db.businesses = require("./business.models")(mongoose);
db.products = require("./products.models")(mongoose);
db.posts = require("./posts.models")(mongoose);
db.events = require("./event.models")(mongoose);

module.exports = db;