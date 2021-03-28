module.exports = app => {
     
    const categories = require("../controllers/category.controller");

    let router = require("express").Router();

    //create new category
    router.post("/", categories.create);

    //get categories
    router.get("/:parent", categories.getCategories);

    //get subcategories
    router.get("/get/subcategories/:id")

    app.use('/categories', router);
}