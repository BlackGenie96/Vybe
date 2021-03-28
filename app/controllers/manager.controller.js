const db = require("../models");
const Manager = db.managers;

//create new managers
exports.create = (req, res) => {

    //validate body
    if(!req.body.name && !req.body.surname && !req.body.phone && !req.body.password){
        res.status(404).send({
            message: "Content cannot be empty",
            success: 0
        });

        return;
    }

    //create manager
    let manager = new Manager({
        name: req.body.name,
        surname: req.body.surname,
        email: req.body.email,
        phone: req.body.phone,
        password: req.body.password,
        image: req.body.image
    });

    manager
        .save(manager)
        .then(data => {
            data.success = 1;
            data.message = "Manager registration successful.";
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Error creating manager",
                success: 0
            });
        });
};

//manager login
exports.login = (req, res) => {

    //validate request
    if(!req.body){
        res.status(400).send({message: "Content cannot be empty for login.", success: 0});
        return;
    }

    Manager.findOne({email : req.body.email})
        .then(data => {
            if(!data){
                res.status(404).send({message: "Manager not found. Make sure you are registered.", success: 0});
                return;
            }

            data.validatePassword(req.body.password).then(val => {

                if(val){
                    res.send(data);
                }else{
                    res.send({
                        success: 0,
                        message: "Incorrect Password"
                    });
                }
            });
        });
};

//update manager profile
exports.update = (req, res) => {

    //validate request
    if(!req.body){
        res.status(400).send({message: "Content cannot be empty for updating.", success:0});
        return;
    }

    const id = req.params.id;

    let pass;
    let updateBody = new Manager(req.body);
    updateBody._id = id;
    updateBody.hashPassword().then(val => {
        console.log(val);
        req.body.password = val;

        console.log(req.body);

        Manager.findByIdAndUpdate(id, req.body, {useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({message: `Cannot update Manager with id = ${id}`,success:0});
            }else{
                res.send({
                    success: 1,
                    message: "Updated profile successfully"
                });
            } 
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || `Error updating Manager with id=${id}`,
                success: 0
            });
        });
    });

};

//get organizer profile
exports.getProfile = (req, res) => {

    const id = req.params.id;

    Manager.findById(id)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({message:err.message || "Error retrieving manager profile for id = "+id, success:0});
        });
};