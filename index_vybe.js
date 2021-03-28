const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

var corsOptions = {
    origin: "http://localhost:8081"
};

app.use(cors(corsOptions));

//parse request of content-type - application/json
app.use(bodyParser.json());

//parse request of content-type - application/json
//app.use(bodyParser.urlencoded({extended: true}));

const db = require("./app/models");
db.mongoose
    .connect(db.url, {
        useNewUrlParser: true, 
        useUnifiedTopology: true
    }).then(() =>{
        console.log('Connected to database!');
    }).catch(err => {
        console.log("Cannot connect to database!", err);
        process.exit();
    });
//simple route
app.get('/', (req, res) => {
    res.json({message: "Welcome to Vybe home"});
});

require("./app/routes/tutorial.routes")(app);
require("./app/routes/category.routes")(app);
require("./app/routes/user.routes")(app);
require("./app/routes/manager.routes")(app);
require("./app/routes/business.routes")(app);
require("./app/routes/product.routes")(app);
require("./app/routes/posts.routes")(app);
require("./app/routes/event.routes")(app);

//set port, listen for requests
const PORT = process.env.PORT || 8080;
app.listen(PORT, () =>{
    console.log(`Server is running on port ${PORT}.`);
});