const db = require("../models");
const Category = db.categories;

//create and save new category
exports.create = (req, res) => {

    //validate request
    if(!req.body.name && !req.body.path && !req.body.parent){
        res.status(404).send({message: "Content cannot be empty",success:0});
        return;
    }

    //create category
    const category = new Category({
        name: req.body.name,
        path: req.body.path,
        parent: req.body.parent,
        has_children: req.body.has_children
    });

    //save category in database
    category
        .save(category)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occured while creating category",
                success: 0
            });
        });
};

//get categories based on parent 
exports.getCategories = (req, res) => {

    //validate request
    if(!req.params.parent){
        res.status(404).send({message: "Parent category not specified",success: 0});
        return;
    }

    Category.find({"parent.id" : `${req.params.parent}`},{_id: 1, name:1, parent:1, has_children:1})
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                message: err.message || "Some error occured while retrieving categories",
                success: 0
            });
        });
};  

//delete category based on category id
exports.deleteCategory = (req, res) => {

    const id = req.params.id;

    Category.findByIdAndRemove(id, {useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Error delete category"
                });
            }else{
                res.send({
                    success: 1,
                    message: "Successfully deleted category"
                });
            }
        });
};

//get child categories array based on the parent id
exports.getChildCategories = (req, res) => {

    const id = req.params.id;

    if(!id){
        res.status(400).send({
            success: 0,
            message: "Required fields missings."
        });
        return;
    }

    Category.find({"parent.id" : id}, {_id: 1, name:1})
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                success: 0, 
                message: err.message || "Error getting category children"
            });
        });
};