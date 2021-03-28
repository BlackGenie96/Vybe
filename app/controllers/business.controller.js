const db = require("../models");
const Business = db.businesses;

//create new business
exports.create = (req, res) => {

    //validate request
    if(!req.body.name && !req.body.phone && !req.body.about && !req.body.category){
        res.status(400).send({
            message : "Required fields missing.",
            success : 0
        });
        return;
    }

    //create new business
    const business = new Business(req.body);

    business
        .save(business)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                success : 0,
                message : err.message || "Error in creating new business."
            });
        });
};

//get business profile
exports.getBusiness = (req, res) => {

    const id = req.params.id;

    Business
        .findById(id)
        .populate("category", "-path -__v -createdAt -updatedAt")
        .populate("created_by", "-password -createdAt -updatedAt -__v")
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Error retrieving business information from server",
                success: 0
            });
        });
};

//upate business profile
exports.update = (req, res) => {

    //validate input
    if(!req.body){
        res.status(400).send({
            success: 0,
            message: "Content cannot be empty for update"
        });
        return;
    }

    const id = req.params.id;

    Business
        .findByIdAndUpdate(id, req.body, {useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Cannot update business"
                });
            }else{
                res.send({
                    success: 1,
                    message: "Business profile update successful"
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Error updating business information."
            });
        });
};

//delete business profile
exports.delete = (req, res) => {

    const id = req.params.id;

    Business
        .findByIdAndRemove(id, {useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Cannot delete business profile"
                });
            }else{
                res.send({
                    success: 1,
                    message: "Business information deleted successfully"
                })
            }
        })
        .catch(err =>{
            res.status(500).send({
                success: 0,
                message: err.message || "Could not delete business profile"
            });
        });
};

//get list of businesses based category id
exports.getList = (req, res) => {

    const cat_id = req.params.cat_id;

    Business
        .find({"category" : `${cat_id}`}, {_id:1, name:1})
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message
            });
        });
};