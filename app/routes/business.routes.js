module.exports = app => {

    const businesses = require("../controllers/business.controller");

    let router = require("express").Router();

    //create new business
    router.post("/create", businesses.create);

    //get business profile
    router.get("/profile/:id", businesses.getBusiness);

    //update business profile
    router.put("/update/profile/:id", businesses.update);

    //delete business profile
    router.delete("/delete/:id", businesses.delete);

    //get business list
    router.get("/list/:cat_id", businesses.getList);

    app.use("/business", router);
}