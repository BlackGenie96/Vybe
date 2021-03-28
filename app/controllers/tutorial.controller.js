const db = require('../models');
const Tutorial = db.tutorials;

//Create and save new tutorial
exports.create = (req, res) => {

    //validate request
    if(!req.body.title){
        res.status(400).send({message: "Content cannot be empty!"});
        return;
    }

    //Create a Tutorial
    const tutorial = new Tutorial({
        title: req.body.title,
        description: req.body.description,
        published: req.body.published ? req.body.published : false
    });

    //Save tutorial in database
    tutorial
        .save(tutorial)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occured while creating tutorial"
            });
        });
};

//Retrieve all tutorials from the database
exports.findAll = (req, res) => {

    const title = req.query.title;
    var condition = title ? {title : {$regex : new RegExp(title), opitons: "i"}} : {};

    Tutorial.find(condition)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occured while retrieving tutorials."
            });
        });
};

//Find a single tutorial with an id
exports.findOne = (req, res) => {

    const id = req.params.id;
    
    Tutorial.findById(id)
        .then(data => {
            if(!data){
                res.status(404).send({message: "Not found Tutorial with id "+id});
            }else{
                res.send(data);
            }
        })
        .catch(err => {
            res.status(500).send({
                message: "Error retrieving Tutorial with id "+ id
            });
        });
};

//Update a Tutorial by the id in the request
exports.update = (req, res) => {
    if(!req.body){
        return res.status(400).send({
            message: "Data to update can not be empty!"
        });
    }

    const id = req.params.id;

    Tutorial.findByIdAndUpdate(id, req.body, { useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({
                    message: `Cannot upate Tutorial with id=${id}. Maybe Tutorial was not found!`
                });
            }else res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: "Error updating Tutorial with id = "+id
            });
        });
};

//Delete a Tutorial with a specified id
exports.delete = (req, res) => {

    const id = req.params.id;

    Tutorial.findByIdAndRemove(id, {useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({
                    message: `Cannot delete Tutorial with id = ${id}. Maybe Tutorial was not found.`
                });
            }else{
                res.send({
                    message: "Tutorial was deleted successfully."
                });
            } 
        })
        .catch(err => {
            res.status(500).send({
                message: "Could not delete Tutorial with id = " + id     
            });
        });
};

//Delete all Tutorials from the database
exports.deleteAll = (req, res) => {
    
    Tutorial.deleteMany({},{ useFindAndModify: false})
        .then(data => {
            res.send({
                message: `${data.deletedCount} Tutorials were deleted successfully!`
            });
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occured while removing all tutorials."
            })
        })
};

//Find all published tutorials
exports.findAllPublished = (req, res) => {

    Tutorial.find({published: true})
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occured while retrieving tutorials"
            })
        })
};