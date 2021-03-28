const db = require('../models');
const Product = db.products;

//create product or products
exports.create = (req, res) => {

    //validate input
    if(!req.body){
        res.status(400).send({
            success: 0,
            message: "Content cannot be empty"
        });
        return;
    }

    if(req.body.products instanceof Array){
        let successCount = 0;
        for(let i=0; i < req.body.products.length; i++){
            let temp = req.body.products[i];
            
            //check if business id has been specified
            if(!req.body.owned_by){
                res.status(404).send({
                    success: 0,
                    message: "Business owner must be specified."
                });
                return;
            }
            temp.owned_by = req.body.owned_by;

            let product = new Product(temp);

            product
                .save(product)
                .then(data => {
                    console.log(i +" "+data);
                })
                .catch(err =>{
                    console.log(i +" "+err.message)
                });
        }

        res.send({
            success:1,
            message: "Successfully added products"
        });
    }else{
        console.log('not array');
    }
    
};

//retrieve products based on business id
exports.getBusinessProducts = (req, res) => {
    
    const id = req.params.id;

    if(!id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    Product.find({owned_by:id})
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Some error occured retrieving products"
            })
        })
};

//update product based on business id
exports.updateProduct = (req, res) => {

    //validate body
    if(!req.body){
        res.status(400).send({
            success: 0, 
            message: "Required fields missing"
        });
        return;
    }

    if(req.body.products instanceof Array){
       
        for(let i=0; i < req.body.products.length; i++){
            let temp = req.body.products[i];

            Product.findByIdAndUpdate(temp._id, temp, {useFindAndModify: false})
            .then(data => {

                if(!data) {
                    console.log(`{success: 0, message: 'Could not update products'}`);
                    return;
                }
                else console.log(data);
            }).catch(err => {
                res.status(500).send(err.message);
            });
        }
        res.send({
            success: 1,
            message: "Successfully update products content"
        });
    }else{
        console.log('not an array in update');
    }
};

//delete product based on product id
exports.deleteByProductId = (req, res) => {

    //validate id
    const id = req.params.id;

    if(!id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing."
        });
        return;
    }

    Product.findByIdAndRemove(id, {useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Could not delete product"
                });
            }else res.send({
                success: 1,
                message: "Successfully delete product from menu"
            });
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Error deleting business menu product"
            });
        });
};

//delete products based on the product id
exports.deleteByBusinessId = (req, res) => {

    const id = req.params.id;

    if(!id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    Product.deleteMany({owned_by: id},{useFindAndModify: false})
        .then(data => {
            if(!data){
                res.send({
                    success: 0,
                    message: "Could not delete products belonging to Business id: "+id
                });
            }else res.send({success: 1, message: "Successfully deleted products for Business id: "+id});
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Error deleting business products"
            });
        });
};