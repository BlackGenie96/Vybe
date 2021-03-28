const db = require("../models");
let User = db.users;

//create a new user
exports.create = (req, res) => {

    //validate body
    if(!req.body.name && !req.body.phone && !req.body.password){
        res.status(404).send({
            message: "Content cannot be empty",
            success: 0
        });
        return;
    }

    //create user
    let user = new User({
        name: req.body.name,
        surname: req.body.surname,
        email: req.body.email,
        phone: req.body.phone, 
        password : req.body.password,
        image: req.body.image
    });

    user.save(user)
        .then(data => {
            res.send({
                success: 1,
                message: "Registration Successful",
                data: data
            });
        })
        .catch(err => {
            res.status(500).send({
                message : err.message || "Error creating user.",
                success : 0
            });
        });
};

//update user current category
exports.updateCategory = (req, res) => {

    //validate request
    if(!req.body){
        res.status(400).send({message: "Body cannot be empty for update",success:0});
        return;
    }

    const id = req.params.id;

    User.findByIdAndUpdate(id, req.body,{useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({message: `Cannot update User with id=${id} !`,success:0});
            }else{
                res.send({
                    success: 1,
                    message: "Category update successful",
                    data: data
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                message : err.message || `Error updating User with id=${id}`,
                success : 0
            });
        });
};

//user login
exports.login = (req, res) => {
    //validate request
    if(!req.body.email && !req.body.password){
        res.status(400).send({message:"Body cannot be empty", success:0});
        return;
    }

    let email = req.body.email;
    let password = req.body.password;

    User.findOne({email: email})
        .then(data => {
            if(!data){
                res.status(404).send({message:"User not found", success: 0});
                return;
            }
            
            data.checkPassword(password).then(val => {

                if(val == false){
                    res.send({message: "Incorrect Password", success:0});
                    return;
                    
                }else{
                    res.send({
                        success:1,
                        message:"Login successful",
                        data: data
                    });
                }
            });
        })
        .catch(err => {
            res.status(500).send({message:err.message || "Error logining in. Make sure you are registered",success:0});
        });
};

//get user profile using user id
exports.getUser = (req, res) => {
    const id = req.params.id;

    User.findById(id)
        .then(data => {
            data.success = 1;
            data.message = "Successful";
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({message: err.message || "Error retrieving user profile for id = " +id,success:0});
        });
};

//update user profile
exports.updateUser = (req, res) => {

    if(!req.body){
        res.status(400).send({message: "Body cannot be empty",success:0});
    }

    const id = req.params.id;

    User.findByIdAndUpdate(id, req.body, {useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({message: "Cannot update user.",success:0});
            }else {
                res.send({
                    success: 1,
                    message: "Profile update successful."
                })
            }
        })
        .catch(err => {
            res.status(500).send({message: err.message || "Error updating user",success:0});
        });
};