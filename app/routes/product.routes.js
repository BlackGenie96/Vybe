module.exports = app => {

    const products = require("../controllers/product.controller");
    let router = require("express").Router();

    //create products for the business
    router.post("/create", products.create);

    //retrieve business products
    router.get("/business/:id", products.getBusinessProducts);

    //update product based on business id
    router.put("/update/item", products.updateProduct);

    //delete product based on product id
    router.delete("/delete/one/:id", products.deleteByProductId);

    //delete products based on business id
    router.delete("/delete/many/:id", products.deleteByBusinessId);


    app.use("/products", router);
}